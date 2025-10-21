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
exports.ProofsController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const proofs_service_1 = require("./proofs.service");
const create_proof_dto_1 = require("./dto/create-proof.dto");
const roles_decorator_1 = require("../common/decorators/roles.decorator");
const roles_1 = require("../common/roles");
const roles_guard_1 = require("../common/guards/roles.guard");
const passport_1 = require("@nestjs/passport");
let ProofsController = class ProofsController {
    constructor(proofs) {
        this.proofs = proofs;
    }
    create(dto) { return this.proofs.create(dto); }
    // Public – Client app
    byTracking(trackingId) { return this.proofs.findByTrackingId(trackingId); }
};
exports.ProofsController = ProofsController;
__decorate([
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.UseGuards)((0, passport_1.AuthGuard)('jwt'), roles_guard_1.RolesGuard),
    (0, roles_decorator_1.Roles)(roles_1.Role.COURIER),
    (0, common_1.Post)(),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_proof_dto_1.CreateProofDto]),
    __metadata("design:returntype", void 0)
], ProofsController.prototype, "create", null);
__decorate([
    (0, common_1.Get)('by-tracking/:trackingId'),
    __param(0, (0, common_1.Param)('trackingId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], ProofsController.prototype, "byTracking", null);
exports.ProofsController = ProofsController = __decorate([
    (0, swagger_1.ApiTags)('proofs'),
    (0, common_1.Controller)('proofs'),
    __metadata("design:paramtypes", [proofs_service_1.ProofsService])
], ProofsController);
//# sourceMappingURL=proofs.controller.js.map