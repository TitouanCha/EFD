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
exports.ToursService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
const parcels_shema_1 = require("../parcels/parcels.shema");
const parcels_service_1 = require("../parcels/parcels.service");
const tour_schema_1 = require("./tour.schema");
let ToursService = class ToursService {
    constructor(model, parcelModel, parcels) {
        this.model = model;
        this.parcelModel = parcelModel;
        this.parcels = parcels;
    }
    async create(date, parcelIds, courierId) {
        const tour = await this.model.create({ date, parcelIds, courierId, status: courierId ? tour_schema_1.TourStatus.ASSIGNED : tour_schema_1.TourStatus.DRAFT });
        await this.parcelModel.updateMany({ _id: { $in: parcelIds } }, { status: parcels_shema_1.ParcelStatus.OUT_FOR_DELIVERY, tourId: tour._id });
        return tour;
    }
    findAll() { return this.model.find().lean(); }
    findOne(id) { return this.model.findById(id).lean(); }
    async update(id, patch) { return this.model.findByIdAndUpdate(id, patch, { new: true }).lean(); }
    async remove(id) {
        const t = await this.model.findByIdAndDelete(id);
        if (t)
            await this.parcelModel.updateMany({ _id: { $in: t.parcelIds } }, { status: parcels_shema_1.ParcelStatus.PENDING, tourId: undefined });
        return { deleted: true };
    }
    async assign(tourId, courierId) {
        return this.update(tourId, { courierId: new mongoose_2.Types.ObjectId(courierId), status: tour_schema_1.TourStatus.ASSIGNED });
    }
    async autoAssign(date) {
        // Simplifié : distribue équitablement par nombre de colis entre livreurs dispos
        const tours = await this.model.find({ date }).lean();
        const couriers = await this.model.db.model('User').find({ role: 'COURIER' }).lean();
        if (!couriers.length)
            throw new common_1.BadRequestException('No couriers');
        let idx = 0;
        const updates = [];
        for (const t of tours) {
            const courier = couriers[idx % couriers.length];
            updates.push(this.assign(t._id.toString(), courier._id.toString()));
            idx++;
        }
        return Promise.all(updates);
    }
    async markCompletedIfAllDelivered(tourId) {
        const t = await this.model.findById(tourId).lean();
        if (!t)
            return;
        const count = await this.parcelModel.countDocuments({ _id: { $in: t.parcelIds }, status: { $ne: parcels_shema_1.ParcelStatus.DELIVERED } });
        if (count === 0)
            await this.model.findByIdAndUpdate(tourId, { status: tour_schema_1.TourStatus.COMPLETED });
    }
};
exports.ToursService = ToursService;
exports.ToursService = ToursService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectModel)(tour_schema_1.Tour.name)),
    __param(1, (0, mongoose_1.InjectModel)(parcels_shema_1.Parcel.name)),
    __metadata("design:paramtypes", [mongoose_2.Model,
        mongoose_2.Model,
        parcels_service_1.ParcelsService])
], ToursService);
//# sourceMappingURL=tours.service.js.map