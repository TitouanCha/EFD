import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Proof } from './proof.schema';
import { Parcel, ParcelStatus } from '../parcels/parcels.shema';
import { ToursService } from '../tours/tours.service';
import { TourStatus } from '../tours/tour.schema';

/**
 * Distance haversine en mètres
 */
function haversineMeters(
  lat1: number,
  lng1: number,
  lat2: number,
  lng2: number
) {
  const toRad = (d: number) => (d * Math.PI) / 180;
  const R = 6371000; // rayon Terre en mètres

  const dLat = toRad(lat2 - lat1);
  const dLng = toRad(lng2 - lng1);

  const a =
    Math.sin(dLat / 2) ** 2 +
    Math.cos(toRad(lat1)) *
      Math.cos(toRad(lat2)) *
      Math.sin(dLng / 2) ** 2;

  return 2 * R * Math.asin(Math.sqrt(a));
}

@Injectable()
export class ProofsService {
  constructor(
    @InjectModel(Proof.name) private model: Model<Proof>,
    @InjectModel(Parcel.name) private parcelModel: Model<Parcel>,
    private tours: ToursService,
  ) {}

  /**
   * Création d'une preuve de livraison
   * - vérifie le colis
   * - vérifie le livreur
   * - vérifie la distance GPS (<= 200m)
   * - passe le colis en DELIVERED
   * - met la tournée IN_PROGRESS / COMPLETED automatiquement
   */
  async create(dto: {
    parcelId: string;
    photoUrl: string;
    lat: number;
    lng: number;
    courierId: string;
  }) {
    
    const parcel = await this.parcelModel
      .findById(dto.parcelId)
      .populate('tourId');

    if (!parcel) {
      throw new BadRequestException('Parcel not found');
    }

    if (!parcel.destination) {
      throw new BadRequestException('Parcel missing destination');
    }

    if (!parcel.tourId) {
      throw new BadRequestException('Parcel not assigned to a tour');
    }

    const tour = parcel.tourId as any;

    if (tour.courierId?.toString() !== dto.courierId) {
      throw new BadRequestException('Not your parcel');
    }

    const [destLng, destLat] = parcel.destination.coordinates;
    const distance = haversineMeters(
      dto.lat,
      dto.lng,
      destLat,
      destLng
    );

    if (distance > 200) {
      throw new BadRequestException(
        `Proof too far (${Math.round(distance)}m)`
      );
    }

    await this.tours.updateStatus(
      parcel.tourId._id.toString(),
      TourStatus.IN_PROGRESS
    );


    const proof = await this.model.create({
      parcelId: new Types.ObjectId(dto.parcelId),
      photoUrl: dto.photoUrl,
      location: {
        type: 'Point',
        coordinates: [dto.lng, dto.lat],
      },
      timestamp: new Date(),
      courierId: new Types.ObjectId(dto.courierId),
    });


    await this.parcelModel.findByIdAndUpdate(dto.parcelId, {
      status: ParcelStatus.DELIVERED,
    });


    await this.tours.markCompletedIfAllDelivered(
      parcel.tourId._id.toString()
    );

    return {
      proofId: proof._id,
      distanceMeters: Math.round(distance),
    };
  }

  /**
   * Suivi public par TrackingID (client)
   */
  findByTrackingId(trackingId: string) {
    return this.model.aggregate([
      {
        $lookup: {
          from: 'parcels',
          localField: 'parcelId',
          foreignField: '_id',
          as: 'parcel',
        },
      },
      { $unwind: '$parcel' },
      { $match: { 'parcel.trackingId': trackingId } },
      { $sort: { timestamp: -1 } },
    ]);
  }
}
