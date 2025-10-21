import { IsEmail, IsEnum, IsOptional, IsString, MinLength } from 'class-validator';
import { Role } from '../../common/roles';

export class RegisterDto {
  @IsString() name!: string;
  @IsEmail()  email!: string;
  @IsString() @MinLength(6) password!: string;
  @IsEnum(Role) @IsOptional() role?: Role;
  @IsOptional() @IsString() phone?: string;
  @IsOptional() language?: 'fr' | 'en' | 'es';
}
