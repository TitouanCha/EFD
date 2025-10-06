import { Injectable, UnauthorizedException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User } from '../users/user.schema';
import * as bcrypt from 'bcrypt';
import { JwtService } from '@nestjs/jwt';
import { LoginDto } from './dto/login.dto';


@Injectable()
export class AuthService {
constructor(
@InjectModel(User.name) private userModel: Model<User>,
private jwt: JwtService,
) {}


async login(dto: LoginDto) {
const user = await this.userModel.findOne({ email: dto.email });
if (!user) throw new UnauthorizedException('Invalid credentials');
const ok = await bcrypt.compare(dto.password, user.passwordHash);
if (!ok) throw new UnauthorizedException('Invalid credentials');
const payload = { sub: user._id.toString(), role: user.role };
return {
access_token: await this.jwt.signAsync(payload),
user: { id: user._id, email: user.email, role: user.role, name: user.name },
};
}
}