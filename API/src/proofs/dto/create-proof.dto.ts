import { IsMongoId, IsNumber, IsString } from 'class-validator';
export class CreateProofDto {
@IsMongoId() parcelId: string;
@IsString() photoUrl: string; // stocker via S3/CDN et passer l’URL ici
@IsNumber() lat: number;
@IsNumber() lng: number;
@IsMongoId() courierId: string;
}