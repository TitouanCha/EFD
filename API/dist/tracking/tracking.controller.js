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
exports.TrackingController = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
const parcels_shema_1 = require("../parcels/parcels.shema");
const tour_schema_1 = require("../tours/tour.schema");
let TrackingController = class TrackingController {
    constructor(parcelModel, tourModel) {
        this.parcelModel = parcelModel;
        this.tourModel = tourModel;
    }
    // Public: état d’un colis + estimation position livreur par dernière preuve
    async track(trackingId) {
        const parcel = await this.parcelModel.findOne({ trackingId }).lean();
        if (!parcel)
            return { error: 'Not found' };
        let courierEstimate = null;
        if (parcel.tourId) {
            const Proof = this.tourModel.db.model('Proof');
            const last = await Proof.aggregate([
                { $match: { parcelId: parcel._id } },
                { $sort: { timestamp: -1 } },
                { $limit: 1 },
            ]);
            if (last[0]) {
                courierEstimate = {
                    eta: null,
                    lastKnown: { lat: last[0].location.coordinates[1], lng: last[0].location.coordinates[0], at: last[0].timestamp },
                };
            }
        }
        return {
            trackingId: parcel.trackingId,
            status: parcel.status,
            destination: parcel.destination,
            tourId: parcel.tourId,
            courierEstimate,
        };
    }
};
exports.TrackingController = TrackingController;
__decorate([
    (0, common_1.Get)(':trackingId'),
    __param(0, (0, common_1.Param)('trackingId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], TrackingController.prototype, "track", null);
exports.TrackingController = TrackingController = __decorate([
    (0, common_1.Controller)('tracking'),
    __param(0, (0, mongoose_1.InjectModel)(parcels_shema_1.Parcel.name)),
    __param(1, (0, mongoose_1.InjectModel)(tour_schema_1.Tour.name)),
    __metadata("design:paramtypes", [mongoose_2.Model,
        mongoose_2.Model])
], TrackingController);
//# sourceMappingURL=tracking.controller.js.map