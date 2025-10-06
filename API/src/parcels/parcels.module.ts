import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { ParcelsService } from './parcels.service';
import { ParcelsController } from './parcels.controller';
import { Parcel, ParcelSchema } from './parcel.schema';


@Module({
imports: [MongooseModule.forFeature([{ name: Parcel.name, schema: ParcelSchema }])],
providers: [ParcelsService],
controllers: [ParcelsController],
exports: [ParcelsService],
})
export class ParcelsModule {}