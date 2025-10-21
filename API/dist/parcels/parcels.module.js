"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ParcelsModule = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const parcels_service_1 = require("./parcels.service");
const parcels_controller_1 = require("./parcels.controller");
const parcels_shema_1 = require("./parcels.shema");
let ParcelsModule = class ParcelsModule {
};
exports.ParcelsModule = ParcelsModule;
exports.ParcelsModule = ParcelsModule = __decorate([
    (0, common_1.Module)({
        imports: [
            mongoose_1.MongooseModule.forFeature([{ name: parcels_shema_1.Parcel.name, schema: parcels_shema_1.ParcelSchema }]),
        ],
        providers: [parcels_service_1.ParcelsService],
        controllers: [parcels_controller_1.ParcelsController],
        exports: [parcels_service_1.ParcelsService, mongoose_1.MongooseModule],
    })
], ParcelsModule);
//# sourceMappingURL=parcels.module.js.map