import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';


export type ProofDocument = HydratedDocument<Proof>;


@Schema({ timestamps: true })
export class Proof {
@Prop({ type: Types.ObjectId, ref: 'Parcel', required: true }) parcelId: Types.ObjectId;
@Prop({ required: true }) photoUrl: string;
@Prop({ type: { type: String, enum: ['Point'], default: 'Point' }, required: true })
location: { type: 'Point'; coordinates: [number, number] };
@Prop({ required: true }) timestamp: Date;
@Prop({ type: Types.ObjectId, ref: 'User', required: true }) courierId: Types.ObjectId;
}


export const ProofSchema = SchemaFactory.createForClass(Proof);
ProofSchema.index({ location: '2dsphere' });
ProofSchema.index({ parcelId: 1, timestamp: -1 });