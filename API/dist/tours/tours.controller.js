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
exports.ToursController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const roles_decorator_1 = require("../common/decorators/roles.decorator");
const roles_1 = require("../common/roles");
const roles_guard_1 = require("../common/guards/roles.guard");
const passport_1 = require("@nestjs/passport");
const tours_service_1 = require("./tours.service");
let ToursController = class ToursController {
    constructor(tours) {
        this.tours = tours;
    }
    create(body) {
        return this.tours.create(body.date, body.parcelIds, body.courierId);
    }
    findAll() { return this.tours.findAll(); }
    findOne(id) { return this.tours.findOne(id); }
    update(id, body) { return this.tours.update(id, body); }
    remove(id) { return this.tours.remove(id); }
    assign(id, courierId) { return this.tours.assign(id, courierId); }
    autoAssign(body) { return this.tours.autoAssign(body.date); }
};
exports.ToursController = ToursController;
__decorate([
    (0, roles_decorator_1.Roles)(roles_1.Role.ADMIN),
    (0, common_1.Post)(),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], ToursController.prototype, "create", null);
__decorate([
    (0, roles_decorator_1.Roles)(roles_1.Role.ADMIN),
    (0, common_1.Get)(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], ToursController.prototype, "findAll", null);
__decorate([
    (0, roles_decorator_1.Roles)(roles_1.Role.ADMIN),
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], ToursController.prototype, "findOne", null);
__decorate([
    (0, roles_decorator_1.Roles)(roles_1.Role.ADMIN),
    (0, common_1.Patch)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Object]),
    __metadata("design:returntype", void 0)
], ToursController.prototype, "update", null);
__decorate([
    (0, roles_decorator_1.Roles)(roles_1.Role.ADMIN),
    (0, common_1.Delete)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], ToursController.prototype, "remove", null);
__decorate([
    (0, roles_decorator_1.Roles)(roles_1.Role.ADMIN),
    (0, common_1.Post)('assign/:id/:courierId'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Param)('courierId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String]),
    __metadata("design:returntype", void 0)
], ToursController.prototype, "assign", null);
__decorate([
    (0, roles_decorator_1.Roles)(roles_1.Role.ADMIN),
    (0, common_1.Post)('auto-assign'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], ToursController.prototype, "autoAssign", null);
exports.ToursController = ToursController = __decorate([
    (0, swagger_1.ApiTags)('tours'),
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.UseGuards)((0, passport_1.AuthGuard)('jwt'), roles_guard_1.RolesGuard),
    (0, common_1.Controller)('tours'),
    __metadata("design:paramtypes", [tours_service_1.ToursService])
], ToursController);
//# sourceMappingURL=tours.controller.js.map