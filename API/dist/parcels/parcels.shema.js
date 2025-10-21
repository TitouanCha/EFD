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
Object.defineProperty(exports, "__esModule", { value: true });
exports.ParcelSchema = exports.Parcel = exports.ParcelStatus = void 0;
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
var ParcelStatus;
(function (ParcelStatus) {
    ParcelStatus["PENDING"] = "PENDING";
    ParcelStatus["OUT_FOR_DELIVERY"] = "OUT_FOR_DELIVERY";
    ParcelStatus["DELIVERED"] = "DELIVERED";
})(ParcelStatus || (exports.ParcelStatus = ParcelStatus = {}));
let Parcel = class Parcel {
};
exports.Parcel = Parcel;
__decorate([
    (0, mongoose_1.Prop)({ required: true, unique: true }),
    __metadata("design:type", String)
], Parcel.prototype, "trackingId", void 0);
__decorate([
    (0, mongoose_1.Prop)({ required: true }),
    __metadata("design:type", Number)
], Parcel.prototype, "weightKg", void 0);
__decorate([
    (0, mongoose_1.Prop)({ required: true }),
    __metadata("design:type", String)
], Parcel.prototype, "recipientName", void 0);
__decorate([
    (0, mongoose_1.Prop)({ required: true }),
    __metadata("design:type", String)
], Parcel.prototype, "address", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: { type: String, enum: ['Point'], default: 'Point' } }),
    __metadata("design:type", Object)
], Parcel.prototype, "destination", void 0);
__decorate([
    (0, mongoose_1.Prop)({ enum: Object.values(ParcelStatus), default: ParcelStatus.PENDING }),
    __metadata("design:type", String)
], Parcel.prototype, "status", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: mongoose_2.Types.ObjectId, ref: 'Tour' }),
    __metadata("design:type", mongoose_2.Types.ObjectId)
], Parcel.prototype, "tourId", void 0);
exports.Parcel = Parcel = __decorate([
    (0, mongoose_1.Schema)({ timestamps: true })
], Parcel);
exports.ParcelSchema = mongoose_1.SchemaFactory.createForClass(Parcel);
exports.ParcelSchema.index({ destination: '2dsphere' });
//# sourceMappingURL=parcels.shema.js.map