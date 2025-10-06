import { IsEmail, IsEnum, IsOptional, IsString, MinLength } from 'class-validator';
import { Role } from '../../common/roles';
export class CreateUserDto {
@IsString() name: string;
@IsEmail() email: string;
@IsString() @MinLength(6) password: string;
@IsEnum(Role) role: Role;
@IsOptional() @IsString() phone?: string;
@IsOptional() @IsEnum(['fr','en','es'] as any) language?: 'fr'|'en'|'es';
}