import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { Point } from '../common/geo.type';
import { PointSchema } from '../common/point.schema';

export type ParcelDocument = HydratedDocument<Parcel>;

export enum ParcelStatus {
  PENDING = 'PENDING',
  OUT_FOR_DELIVERY = 'OUT_FOR_DELIVERY',
  DELIVERED = 'DELIVERED',
}

@Schema({ timestamps: true })
export class Parcel {
  @Prop({ required: true, unique: true })
  trackingId: string;

  @Prop({ required: true })
  weightKg: number;

  @Prop({ required: true })
  recipientName: string;

  @Prop({ required: true })
  address: string;

  @Prop({ type: PointSchema, required: false })
  destination?: Point;

  @Prop({ enum: Object.values(ParcelStatus), default: ParcelStatus.PENDING })
  status: ParcelStatus;

  @Prop({ type: Types.ObjectId, ref: 'User', required: true, index: true })
  clientId: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'Tour' })
  tourId?: Types.ObjectId;
}

export const ParcelSchema = SchemaFactory.createForClass(Parcel);
ParcelSchema.index({ destination: '2dsphere' });
