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
exports.TourSchema = exports.Tour = exports.TourStatus = void 0;
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
var TourStatus;
(function (TourStatus) {
    TourStatus["DRAFT"] = "DRAFT";
    TourStatus["ASSIGNED"] = "ASSIGNED";
    TourStatus["IN_PROGRESS"] = "IN_PROGRESS";
    TourStatus["COMPLETED"] = "COMPLETED";
})(TourStatus || (exports.TourStatus = TourStatus = {}));
let Tour = class Tour {
};
exports.Tour = Tour;
__decorate([
    (0, mongoose_1.Prop)({ required: true }),
    __metadata("design:type", String)
], Tour.prototype, "date", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: mongoose_2.Types.ObjectId, ref: 'User' }),
    __metadata("design:type", mongoose_2.Types.ObjectId)
], Tour.prototype, "courierId", void 0);
__decorate([
    (0, mongoose_1.Prop)({ type: [{ type: mongoose_2.Types.ObjectId, ref: 'Parcel' }], default: [] }),
    __metadata("design:type", Array)
], Tour.prototype, "parcelIds", void 0);
__decorate([
    (0, mongoose_1.Prop)({ enum: Object.values(TourStatus), default: TourStatus.DRAFT }),
    __metadata("design:type", String)
], Tour.prototype, "status", void 0);
exports.Tour = Tour = __decorate([
    (0, mongoose_1.Schema)({ timestamps: true })
], Tour);
exports.TourSchema = mongoose_1.SchemaFactory.createForClass(Tour);
exports.TourSchema.index({ date: 1, courierId: 1 });
//# sourceMappingURL=tour.schema.js.map