"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProofsService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
const proof_schema_1 = require("./proof.schema");
const parcels_shema_1 = require("../parcels/parcels.shema");
const tours_service_1 = require("../tours/tours.service");
function haversineMeters(lat1, lng1, lat2, lng2) {
    const toRad = (d) => d * Math.PI / 180;
    const R = 6371000; // m
    const dLat = toRad(lat2 - lat1);
    const dLng = toRad(lng2 - lng1);
    const a = Math.sin(dLat / 2) ** 2 + Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.sin(dLng / 2) ** 2;
    return 2 * R * Math.asin(Math.sqrt(a));
}
let ProofsService = class ProofsService {
    constructor(model, parcelModel, tours) {
        this.model = model;
        this.parcelModel = parcelModel;
        this.tours = tours;
    }
    async create(dto) {
        const parcel = await this.parcelModel.findById(dto.parcelId);
        if (!parcel)
            throw new common_1.BadRequestException('Parcel not found');
        if (!parcel.destination)
            throw new common_1.BadRequestException('Parcel missing destination');
        const [destLng, destLat] = parcel.destination.coordinates;
        const dist = haversineMeters(dto.lat, dto.lng, destLat, destLng);
        if (dist > 200)
            throw new common_1.BadRequestException(`Proof too far (${Math.round(dist)}m)`);
        const proof = await this.model.create({
            parcelId: new mongoose_2.Types.ObjectId(dto.parcelId),
            photoUrl: dto.photoUrl,
            location: { type: 'Point', coordinates: [dto.lng, dto.lat] },
            timestamp: new Date(),
            courierId: new mongoose_2.Types.ObjectId(dto.courierId),
        });
        await this.parcelModel.findByIdAndUpdate(dto.parcelId, { status: parcels_shema_1.ParcelStatus.DELIVERED });
        if (parcel.tourId)
            await this.tours.markCompletedIfAllDelivered(parcel.tourId.toString());
        return { proofId: proof._id, distanceMeters: Math.round(dist) };
    }
    findByTrackingId(trackingId) {
        return this.model.aggregate([
            { $lookup: { from: 'parcels', localField: 'parcelId', foreignField: '_id', as: 'parcel' } },
            { $unwind: '$parcel' },
            { $match: { 'parcel.trackingId': trackingId } },
            { $sort: { timestamp: -1 } },
        ]);
    }
};
exports.ProofsService = ProofsService;
exports.ProofsService = ProofsService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectModel)(proof_schema_1.Proof.name)),
    __param(1, (0, mongoose_1.InjectModel)(parcels_shema_1.Parcel.name)),
    __metadata("design:paramtypes", [mongoose_2.Model,
        mongoose_2.Model,
        tours_service_1.ToursService])
], ProofsService);
//# sourceMappingURL=proofs.service.js.map