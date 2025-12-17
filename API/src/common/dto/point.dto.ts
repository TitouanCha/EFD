import { IsArray, ArrayMinSize, ArrayMaxSize, IsNumber, IsIn } from 'class-validator';

export class PointDto {
  @IsIn(['Point'])
  type!: 'Point';

  @IsArray()
  @ArrayMinSize(2)
  @ArrayMaxSize(2)
  @IsNumber({}, { each: true })
  coordinates!: [number, number]; // [lng, lat]
}