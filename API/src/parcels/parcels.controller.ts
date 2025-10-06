import { Body, Controller, Delete, Get, Param, Patch, Post, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { ParcelsService } from './parcels.service';
import { CreateParcelDto } from './dto/create-parcel.dto';
import { UpdateParcelDto } from './dto/update-parcel.dto';
import { Roles } from '../common/decorators/roles.decorator';
import { Role } from '../common/roles';
import { RolesGuard } from '../common/guards/roles.guard';
import { AuthGuard } from '@nestjs/passport';


@ApiTags('parcels')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'), RolesGuard)
@Controller('parcels')
export class ParcelsController {
constructor(private readonly parcels: ParcelsService) {}


@Roles(Role.ADMIN, Role.CLIENT)
@Post()
create(@Body() dto: CreateParcelDto) { return this.parcels.create(dto); }


@Roles(Role.ADMIN)
@Get()
findAll() { return this.parcels.findAll(); }


@Roles(Role.ADMIN, Role.CLIENT)
@Get(':id')
findOne(@Param('id') id: string) { return this.parcels.findOne(id); }


@Roles(Role.ADMIN, Role.CLIENT)
@Patch(':id')
update(@Param('id') id: string, @Body() dto: UpdateParcelDto) { return this.parcels.update(id, dto); }


@Roles(Role.ADMIN)
@Delete(':id')
remove(@Param('id') id: string) { return this.parcels.remove(id); }
}