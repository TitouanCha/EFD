import { Schema as MongooseSchema } from 'mongoose';

export const PointSchema = new MongooseSchema(
  {
    type: { type: String, enum: ['Point'], default: 'Point' },
    coordinates: { type: [Number], required: true },
  },
  { _id: false }
);
