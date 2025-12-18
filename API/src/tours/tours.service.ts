import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Parcel, ParcelStatus } from '../parcels/parcels.shema';
import { ParcelsService } from '../parcels/parcels.service';
import { Tour, TourStatus } from './tour.schema';


@Injectable()
export class ToursService {
constructor(
@InjectModel(Tour.name) private model: Model<Tour>,
@InjectModel(Parcel.name) private parcelModel: Model<Parcel>,
private parcels: ParcelsService,
) {}


async create(date: string, parcelIds: string[], courierId?: string) {
    const objectIdParcels = parcelIds.map(id => new Types.ObjectId(id));
    const objectIdCourier = courierId ? new Types.ObjectId(courierId) : undefined;

    const tour = await this.model.create({ 
      date, 
      parcelIds: objectIdParcels, 
      courierId: objectIdCourier, 
      status: courierId ? TourStatus.ASSIGNED : TourStatus.DRAFT 
    });

    await this.parcelModel.updateMany(
      { _id: { $in: objectIdParcels } }, 
      { status: ParcelStatus.OUT_FOR_DELIVERY, tourId: tour._id }
    );
    return this.model
      .findById(tour._id)
      .populate('parcelIds', 'trackingId recipientName address destination status weightKg')
      
      .lean();
  }

async findAll() { 
    return this.model 
        .find() 
        .populate({
            path: 'parcelIds',
            select: 'trackingId recipientName address destination status weightKg'
          })
          .populate('courierId', '_id name email phone')
        .lean(); 
}

findOne(id: string) { return this.model.findById(id).lean(); }
async update(id: string, patch: Partial<Tour>) { return this.model.findByIdAndUpdate(id, patch, { new: true }).lean(); }
async remove(id: string) {
const t = await this.model.findByIdAndDelete(id);
if (t) await this.parcelModel.updateMany({ _id: { $in: t.parcelIds } }, { status: ParcelStatus.PENDING, tourId: undefined });
return { deleted: true };
}


async assign(tourId: string, courierId: string) {
return this.update(tourId, { courierId: new Types.ObjectId(courierId), status: TourStatus.ASSIGNED });
}


async autoAssign(date: string) {
    // Simplifié : distribue équitablement par nombre de colis entre livreurs dispos
    const tours = await this.model.find({ date }).lean();
    const couriers = await (this.model.db as any).model('User').find({ role: 'COURIER' }).lean();
    if (!couriers.length) throw new BadRequestException('No couriers');
    let idx = 0;
    const updates = [] as any[];
    for (const t of tours) {
        const courier = couriers[idx % couriers.length];
        updates.push(this.assign(t._id.toString(), courier._id.toString()));
        idx++;
    }
    return Promise.all(updates);
}


async markCompletedIfAllDelivered(tourId: string) {
const t = await this.model.findById(tourId).lean();
if (!t) return;
const count = await this.parcelModel.countDocuments({ _id: { $in: t.parcelIds }, status: { $ne: ParcelStatus.DELIVERED } });
if (count === 0) await this.model.findByIdAndUpdate(tourId, { status: TourStatus.COMPLETED });
}

findByCourier(courierId: string) {
  return this.model
    .find({
      courierId,
      status: { $ne: TourStatus.DRAFT }
    })
    .populate('parcelIds')
    .lean();
}

async updateStatus(tourId: string, status: TourStatus) {
  return this.model.findByIdAndUpdate(
    tourId,
    { status },
    { new: true }
  ).lean();
}

}