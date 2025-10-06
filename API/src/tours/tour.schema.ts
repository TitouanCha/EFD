import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';


export type TourDocument = HydratedDocument<Tour>;
export enum TourStatus { DRAFT='DRAFT', ASSIGNED='ASSIGNED', IN_PROGRESS='IN_PROGRESS', COMPLETED='COMPLETED' }


@Schema({ timestamps: true })
export class Tour {
@Prop({ required: true }) date: string; // YYYY-MM-DD
@Prop({ type: Types.ObjectId, ref: 'User' }) courierId?: Types.ObjectId;
@Prop({ type: [{ type: Types.ObjectId, ref: 'Parcel' }], default: [] }) parcelIds: Types.ObjectId[];
@Prop({ enum: Object.values(TourStatus), default: TourStatus.DRAFT }) status: TourStatus;
}
export const TourSchema = SchemaFactory.createForClass(Tour);
TourSchema.index({ date: 1, courierId: 1 });