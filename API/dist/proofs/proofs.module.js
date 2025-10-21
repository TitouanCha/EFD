"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProofsModule = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const proof_schema_1 = require("./proof.schema");
const proofs_service_1 = require("./proofs.service");
const proofs_controller_1 = require("./proofs.controller");
const parcels_module_1 = require("../parcels/parcels.module");
const tours_module_1 = require("../tours/tours.module");
let ProofsModule = class ProofsModule {
};
exports.ProofsModule = ProofsModule;
exports.ProofsModule = ProofsModule = __decorate([
    (0, common_1.Module)({
        imports: [
            mongoose_1.MongooseModule.forFeature([{ name: proof_schema_1.Proof.name, schema: proof_schema_1.ProofSchema }]),
            parcels_module_1.ParcelsModule,
            tours_module_1.ToursModule,
        ],
        providers: [proofs_service_1.ProofsService],
        controllers: [proofs_controller_1.ProofsController],
        exports: [proofs_service_1.ProofsService],
    })
], ProofsModule);
//# sourceMappingURL=proofs.module.js.map