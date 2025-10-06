import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Proof } from './proof.schema';
import { Parcel, ParcelStatus } from '../parcels/parcel.schema';
import { ToursService } from '../tours/tours.service';


function haversineMeters(lat1:number,lng1:number,lat2:number,lng2:number){
const toRad=(d:number)=>d*Math.PI/180;
const R=6371000; // m
const dLat=toRad(lat2-lat1); const dLng=toRad(lng2-lng1);
const a=Math.sin(dLat/2)**2 + Math.cos(toRad(lat1))*Math.cos(toRad(lat2))*Math.sin(dLng/2)**2;
return 2*R*Math.asin(Math.sqrt(a));
}


@Injectable()
export class ProofsService {
constructor(
@InjectModel(Proof.name) private model: Model<Proof>,
@InjectModel(Parcel.name) private parcelModel: Model<Parcel>,
private tours: ToursService,
) {}


async create(dto: { parcelId: string; photoUrl: string; lat: number; lng: number; courierId: string }) {
const parcel = await this.parcelModel.findById(dto.parcelId);
if (!parcel) throw new BadRequestException('Parcel not found');
if (!parcel.destination) throw new BadRequestException('Parcel missing destination');
const [destLng, destLat] = parcel.destination.coordinates;
const dist = haversineMeters(dto.lat, dto.lng, destLat, destLng);
if (dist > 200) throw new BadRequestException(`Proof too far (${Math.round(dist)}m)`);


const proof = await this.model.create({
parcelId: new Types.ObjectId(dto.parcelId),
photoUrl: dto.photoUrl,
location: { type: 'Point', coordinates: [dto.lng, dto.lat] },
timestamp: new Date(),
courierId: new Types.ObjectId(dto.courierId),
});
await this.parcelModel.findByIdAndUpdate(dto.parcelId, { status: ParcelStatus.DELIVERED });
if (parcel.tourId) await this.tours.markCompletedIfAllDelivered(parcel.tourId.toString());
return { proofId: proof._id, distanceMeters: Math.round(dist) };
}


findByTrackingId(trackingId: string) {
return this.model.aggregate([
{ $lookup: { from: 'parcels', localField: 'parcelId', foreignField: '_id', as: 'parcel' } },
{ $unwind: '$parcel' },
{ $match: { 'parcel.trackingId': trackingId } },
{ $sort: { timestamp: -1 } },
]);
}
}