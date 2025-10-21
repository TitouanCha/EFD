import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { ToursService } from './tours.service';
import { ToursController } from './tours.controller';
import { Tour, TourSchema } from './tour.schema';
import { Parcel, ParcelSchema } from '../parcels/parcels.shema';
import { ParcelsModule } from '../parcels/parcels.module';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Tour.name, schema: TourSchema },
      { name: Parcel.name, schema: ParcelSchema },
    ]),
    ParcelsModule,
  ],
  providers: [ToursService],
  controllers: [ToursController],
  exports: [ToursService],
})
export class ToursModule {}
