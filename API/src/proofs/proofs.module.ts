import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { Proof, ProofSchema } from './proof.schema';
import { ProofsService } from './proofs.service';
import { ProofsController } from './proofs.controller';
import { ParcelsModule } from '../parcels/parcels.module';
import { ToursModule } from '../tours/tours.module';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Proof.name, schema: ProofSchema }]),
    ParcelsModule,
    ToursModule,
  ],
  providers: [ProofsService],
  controllers: [ProofsController],
  exports: [ProofsService],
})
export class ProofsModule {}
