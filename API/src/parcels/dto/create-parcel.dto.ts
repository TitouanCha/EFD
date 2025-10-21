import { IsNumber, IsOptional, IsString } from 'class-validator';
export class CreateParcelDto {
@IsString() trackingId: string;
@IsNumber() weightKg: number;
@IsString() recipientName: string;
@IsString() address: string;
@IsOptional() destination?: { type: 'Point'; coordinates: [number, number] };
}