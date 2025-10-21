import { Injectable, UnauthorizedException, BadRequestException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User } from '../users/user.schema';
import * as bcrypt from 'bcrypt';
import { JwtService } from '@nestjs/jwt';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';
import { Role } from '../common/roles'; // adapte le chemin

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
    const payload = { sub: user._id.toString(), email: user.email, role: user.role };
    return {
      access_token: await this.jwt.signAsync(payload),
      user: { id: user._id, email: user.email, role: user.role, name: user.name },
    };
  }

  async register(dto: RegisterDto) {
    const exists = await this.userModel.exists({ email: dto.email });
    if (exists) throw new BadRequestException('Email already in use');

    const passwordHash = await bcrypt.hash(dto.password, 10);
    const role = dto.role ?? Role.COURIER; 

    try {
      const user = await this.userModel.create({
        name: dto.name,
        email: dto.email,
        passwordHash,
        role,
        phone: dto.phone,
        language: dto.language,
      });

      const payload = { sub: user._id.toString(), email: user.email, role: user.role };
      return {
        access_token: await this.jwt.signAsync(payload),
        user: { id: user._id, email: user.email, role: user.role, name: user.name },
      };
    } catch (e: any) {
      if (e?.code === 11000) throw new BadRequestException('Email already in use');
      throw e;
    }
  }
}
