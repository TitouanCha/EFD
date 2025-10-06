import { Module } from '@nestjs/common';
import { TrackingController } from './tracking.controller';
import { MongooseModule } from '@nestjs/mongoose';
import { Parcel, ParcelSchema } from '../parcels/parcel.schema';
import { Tour, TourSchema } from '../tours/tour.schema';


@Module({
imports: [
MongooseModule.forFeature([
{ name: Parcel.name, schema: ParcelSchema },
{ name: Tour.name, schema: TourSchema },
]),
],
controllers: [TrackingController],
})
export class TrackingModule {}