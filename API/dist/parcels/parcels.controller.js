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
exports.ParcelsController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const parcels_service_1 = require("./parcels.service");
const create_parcel_dto_1 = require("./dto/create-parcel.dto");
const update_parcel_dto_1 = require("./dto/update-parcel.dto");
const roles_decorator_1 = require("../common/decorators/roles.decorator");
const roles_1 = require("../common/roles");
const roles_guard_1 = require("../common/guards/roles.guard");
const passport_1 = require("@nestjs/passport");
let ParcelsController = class ParcelsController {
    constructor(parcels) {
        this.parcels = parcels;
    }
    create(dto) { return this.parcels.create(dto); }
    findAll() { return this.parcels.findAll(); }
    findOne(id) { return this.parcels.findOne(id); }
    update(id, dto) { return this.parcels.update(id, dto); }
    remove(id) { return this.parcels.remove(id); }
};
exports.ParcelsController = ParcelsController;
__decorate([
    (0, roles_decorator_1.Roles)(roles_1.Role.ADMIN, roles_1.Role.CLIENT),
    (0, common_1.Post)(),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_parcel_dto_1.CreateParcelDto]),
    __metadata("design:returntype", void 0)
], ParcelsController.prototype, "create", null);
__decorate([
    (0, roles_decorator_1.Roles)(roles_1.Role.ADMIN),
    (0, common_1.Get)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], ParcelsController.prototype, "findAll", null);
__decorate([
    (0, roles_decorator_1.Roles)(roles_1.Role.ADMIN, roles_1.Role.CLIENT),
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], ParcelsController.prototype, "findOne", null);
__decorate([
    (0, roles_decorator_1.Roles)(roles_1.Role.ADMIN, roles_1.Role.CLIENT),
    (0, common_1.Patch)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, update_parcel_dto_1.UpdateParcelDto]),
    __metadata("design:returntype", void 0)
], ParcelsController.prototype, "update", null);
__decorate([
    (0, roles_decorator_1.Roles)(roles_1.Role.ADMIN),
    (0, common_1.Delete)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], ParcelsController.prototype, "remove", null);
exports.ParcelsController = ParcelsController = __decorate([
    (0, swagger_1.ApiTags)('parcels'),
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.UseGuards)((0, passport_1.AuthGuard)('jwt'), roles_guard_1.RolesGuard),
    (0, common_1.Controller)('parcels'),
    __metadata("design:paramtypes", [parcels_service_1.ParcelsService])
], ParcelsController);
//# sourceMappingURL=parcels.controller.js.map