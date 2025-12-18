import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Parcel, ParcelStatus } from './parcels.shema';
import { CreateParcelDto } from './dto/create-parcel.dto';
import { UpdateParcelDto } from './dto/update-parcel.dto';


@Injectable()
export class ParcelsService {
constructor(@InjectModel(Parcel.name) private model: Model<Parcel>) {}


create(dto: CreateParcelDto) { return this.model.create(dto); }
findAll() { return this.model.find().lean(); }
findOne(id: string) { return this.model.findById(id).lean(); }
findByTrackingId(trackingId: string) { return this.model.findOne({ trackingId }).lean(); }
update(id: string, dto: UpdateParcelDto) { return this.model.findByIdAndUpdate(id, dto, { new: true }).lean(); }
remove(id: string) { return this.model.findByIdAndDelete(id).lean(); }
markDelivered(id: string) { return this.model.findByIdAndUpdate(id, { status: ParcelStatus.DELIVERED }, { new: true }).lean(); }
findByCourier(courierId: string) {
  return this.model
    .find({ courierId })
    .lean();
}

}