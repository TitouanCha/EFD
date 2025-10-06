import { Body, Controller, Get, Param, Post, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { ProofsService } from './proofs.service';
import { CreateProofDto } from './dto/create-proof.dto';
import { Roles } from '../common/decorators/roles.decorator';
import { Role } from '../common/roles';
import { RolesGuard } from '../common/guards/roles.guard';
import { AuthGuard } from '@nestjs/passport';


@ApiTags('proofs')
@Controller('proofs')
export class ProofsController {
constructor(private readonly proofs: ProofsService) {}


@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'), RolesGuard)
@Roles(Role.COURIER)
@Post()
create(@Body() dto: CreateProofDto) { return this.proofs.create(dto); }


// Public – Client app
@Get('by-tracking/:trackingId')
byTracking(@Param('trackingId') trackingId: string) { return this.proofs.findByTrackingId(trackingId); }
}