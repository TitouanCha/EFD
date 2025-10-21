"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PointSchema = void 0;
const mongoose_1 = require("mongoose");
exports.PointSchema = new mongoose_1.Schema({
    type: { type: String, enum: ['Point'], default: 'Point' },
    coordinates: { type: [Number], required: true },
}, { _id: false });
//# sourceMappingURL=point.schema.js.map