import { Controller, Get, Param } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Parcel } from '../parcels/parcels.shema';
import { Tour } from '../tours/tour.schema';


@Controller('tracking')
export class TrackingController {
constructor(
@InjectModel(Parcel.name) private parcelModel: Model<Parcel>,
@InjectModel(Tour.name) private tourModel: Model<Tour>,
) {}


// Public: état d’un colis + estimation position livreur par dernière preuve
@Get(':trackingId')
async track(@Param('trackingId') trackingId: string) {
const parcel = await this.parcelModel.findOne({ trackingId }).lean();
if (!parcel) return { error: 'Not found' };


let courierEstimate: any = null;
if (parcel.tourId) {
const Proof = (this.tourModel.db as any).model('Proof');
const last = await Proof.aggregate([
{ $match: { parcelId: parcel._id } },
{ $sort: { timestamp: -1 } },
{ $limit: 1 },
]);
if (last[0]) {
courierEstimate = {
eta: null,
lastKnown: { lat: last[0].location.coordinates[1], lng: last[0].location.coordinates[0], at: last[0].timestamp },
};
}
}


return {
trackingId: parcel.trackingId,
status: parcel.status,
destination: parcel.destination,
tourId: parcel.tourId,
courierEstimate,
};
}
}