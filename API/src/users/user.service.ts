import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User } from './user.schema';
import * as bcrypt from 'bcryptjs';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';


@Injectable()
export class UsersService {
constructor(@InjectModel(User.name) private model: Model<User>) {}


async create(dto: CreateUserDto) {
const passwordHash = await bcrypt.hash(dto.password, 10);
const created = await this.model.create({ ...dto, passwordHash });
return this.sanitize(created);
}
async findAll(role?: string) {
const q: any = {};
if (role) q.role = role;
const users = await this.model.find(q).lean();
return users.map(this.sanitize);
}
async findOne(id: string) {
const u = await this.model.findById(id).lean();
return this.sanitize(u);
}
async update(id: string, dto: UpdateUserDto) {
if ((dto as any).password) delete (dto as any).password;
const u = await this.model.findByIdAndUpdate(id, dto, { new: true }).lean();
return this.sanitize(u);
}
async remove(id: string) {
await this.model.findByIdAndDelete(id);
return { deleted: true };
}
sanitize = (u: any) => u ? ({ ...u, passwordHash: undefined }) : u;
}