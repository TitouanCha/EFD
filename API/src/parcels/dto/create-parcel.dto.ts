import { IsNumber, IsOptional, IsString, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { PointDto } from '../../common/dto/point.dto';

export class CreateParcelDto {
  @IsString()
  trackingId!: string;

  @IsNumber()
  weightKg!: number;

  @IsString()
  recipientName!: string;

  @IsString()
  address!: string;

  @IsOptional()
  @ValidateNested()
  @Type(() => PointDto)
  destination?: PointDto;
}