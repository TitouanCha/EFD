import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { Point } from '../common/geo.type';
import { PointSchema } from '../common/point.schema';

export type ProofDocument = HydratedDocument<Proof>;

@Schema({ timestamps: true })
export class Proof {
  @Prop({ type: Types.ObjectId, ref: 'Parcel', required: true }) parcelId!: Types.ObjectId;
  @Prop({ required: true }) photoUrl!: string;

  @Prop({ type: PointSchema, required: true })
  location!: Point;

  @Prop({ required: true }) timestamp!: Date;
  @Prop({ type: Types.ObjectId, ref: 'User', required: true }) courierId!: Types.ObjectId;
}
export const ProofSchema = SchemaFactory.createForClass(Proof);


(ProofSchema as any).index({ location: '2dsphere' });
(ProofSchema as any).index({ parcelId: 1, timestamp: -1 });