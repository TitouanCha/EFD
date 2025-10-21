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
exports.ParcelsService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
const parcels_shema_1 = require("./parcels.shema");
let ParcelsService = class ParcelsService {
    constructor(model) {
        this.model = model;
    }
    create(dto) { return this.model.create(dto); }
    findAll() { return this.model.find().lean(); }
    findOne(id) { return this.model.findById(id).lean(); }
    findByTrackingId(trackingId) { return this.model.findOne({ trackingId }).lean(); }
    update(id, dto) { return this.model.findByIdAndUpdate(id, dto, { new: true }).lean(); }
    remove(id) { return this.model.findByIdAndDelete(id).lean(); }
    markDelivered(id) { return this.model.findByIdAndUpdate(id, { status: parcels_shema_1.ParcelStatus.DELIVERED }, { new: true }).lean(); }
};
exports.ParcelsService = ParcelsService;
exports.ParcelsService = ParcelsService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectModel)(parcels_shema_1.Parcel.name)),
    __metadata("design:paramtypes", [mongoose_2.Model])
], ParcelsService);
//# sourceMappingURL=parcels.service.js.map