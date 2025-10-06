import { IsArray, IsDateString, IsMongoId, IsOptional } from 'class-validator';
export class CreateTourDto {
@IsDateString() date: string;
@IsOptional() @IsMongoId() courierId?: string;
@IsArray() parcelIds: string[];
}