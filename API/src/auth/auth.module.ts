import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { MongooseModule } from '@nestjs/mongoose';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { User, UserSchema } from '../users/user.schema';
import { JwtStrategy } from './jwt.strategy';


@Module({
imports: [
PassportModule,
JwtModule.register({
secret: process.env.JWT_SECRET,
signOptions: { expiresIn: process.env.JWT_EXPIRES || '7d' },
}),
MongooseModule.forFeature([{ name: User.name, schema: UserSchema }]),
],
providers: [AuthService, JwtStrategy],
controllers: [AuthController],
exports: [AuthService],
})
export class AuthModule {}


# src/auth/auth.controller.ts
import { Body, Controller, Post } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { LoginDto } from './dto/login.dto';


@ApiTags('auth')
@Controller('auth')
export class AuthController {
constructor(private readonly auth: AuthService) {}


@Post('login')
login(@Body() dto: LoginDto) {
return this.auth.login(dto);
}
}