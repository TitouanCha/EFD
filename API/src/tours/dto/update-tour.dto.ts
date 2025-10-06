import { PartialType } from '@nestjs/swagger';
import { CreateTourDto } from './create-tour.dto';
export class UpdateTourDto extends PartialType(CreateTourDto) {}


# src/tours/tours.module.ts
import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { Tour, TourSchema } from './tour.schema';
import { ToursService } from './tours.service';
import { ToursController } from './tours.controller';
import { ParcelsModule } from '../parcels/parcels.module';


@Module({
imports: [
MongooseModule.forFeature([{ name: Tour.name, schema: TourSchema }]),
ParcelsModule,
],
providers: [ToursService],
controllers: [ToursController],
exports: [ToursService]
})
export class ToursModule {}