import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';


export type ParcelDocument = HydratedDocument<Parcel>;


export enum ParcelStatus {
PENDING = 'PENDING',
OUT_FOR_DELIVERY = 'OUT_FOR_DELIVERY',
DELIVERED = 'DELIVERED',
}


@Schema({ timestamps: true })
export class Parcel {
@Prop({ required: true, unique: true }) trackingId: string;
@Prop({ required: true }) weightKg: number;
@Prop({ required: true }) recipientName: string;
@Prop({ required: true }) address: string;
@Prop({ type: { type: String, enum: ['Point'], default: 'Point' } })
destination?: { type: 'Point'; coordinates: [number, number] }; // [lng, lat]
@Prop({ enum: Object.values(ParcelStatus), default: ParcelStatus.PENDING })
status: ParcelStatus;
@Prop({ type: Types.ObjectId, ref: 'Tour' })
tourId?: Types.ObjectId;
}


export const ParcelSchema = SchemaFactory.createForClass(Parcel);
ParcelSchema.index({ destination: '2dsphere' });