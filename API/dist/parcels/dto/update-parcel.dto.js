"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.UpdateParcelDto = void 0;
const swagger_1 = require("@nestjs/swagger");
const create_parcel_dto_1 = require("./create-parcel.dto");
class UpdateParcelDto extends (0, swagger_1.PartialType)(create_parcel_dto_1.CreateParcelDto) {
}
exports.UpdateParcelDto = UpdateParcelDto;
//# sourceMappingURL=update-parcel.dto.js.map