import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';
import { Role } from '../common/roles';


export type UserDocument = HydratedDocument<User>;


@Schema({ timestamps: true })
export class User {
@Prop({ required: true }) name: string;
@Prop({ required: true, unique: true, lowercase: true }) email: string;
@Prop({ required: true }) passwordHash: string;
@Prop({ enum: Object.values(Role), required: true }) role: Role;
@Prop() phone?: string;
@Prop() language?: 'fr' | 'en' | 'es';
}


export const UserSchema = SchemaFactory.createForClass(User);