import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { ParcelsService } from './parcels.service';
import { ParcelsController } from './parcels.controller';
import { Parcel, ParcelSchema } from './parcels.shema';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Parcel.name, schema: ParcelSchema }]),
  ],
  providers: [ParcelsService],
  controllers: [ParcelsController],
  exports: [ParcelsService, MongooseModule],
})
export class ParcelsModule {}
