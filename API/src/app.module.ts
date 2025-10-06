import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { MongooseModule } from '@nestjs/mongoose';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { ParcelsModule } from './parcels/parcels.module';
import { ToursModule } from './tours/tours.module';
import { ProofsModule } from './proofs/proofs.module';
import { TrackingModule } from './tracking/tracking.module';
import { RealtimeModule } from './realtime/realtime.module';


@Module({
imports: [
ConfigModule.forRoot({ isGlobal: true }),
MongooseModule.forRoot(process.env.MONGO_URI as string),
AuthModule,
UsersModule,
ParcelsModule,
ToursModule,
ProofsModule,
TrackingModule,
RealtimeModule,
],
})
export class AppModule {}