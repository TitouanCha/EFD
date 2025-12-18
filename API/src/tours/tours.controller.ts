import { Body, Controller, Delete, Get, Param, Patch, Post, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { Roles } from '../common/decorators/roles.decorator';
import { Role } from '../common/roles';
import { RolesGuard } from '../common/guards/roles.guard';
import { AuthGuard } from '@nestjs/passport';
import { ToursService } from './tours.service';
import { Req } from '@nestjs/common';
import { TourStatus } from './tour.schema';

@ApiTags('tours')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'), RolesGuard)
@Controller('tours')
export class ToursController {
constructor(private readonly tours: ToursService) {}

  @Get('courier/:courierId')
  findByCourier(@Param('courierId') courierId: string) {
    return this.tours.findByCourier(courierId);
  }

  @Patch(':id/status')
  updateStatus(
    @Param('id') id: string,
    @Body() body: { status: TourStatus }
  ) {
    return this.tours.updateStatus(id, body.status);
  }

@Roles(Role.ADMIN)
@Post()
create(@Body() body: { date: string; parcelIds: string[]; courierId?: string }) {
return this.tours.create(body.date, body.parcelIds, body.courierId);
}


@Roles(Role.ADMIN)
@Get()
findAll() { return this.tours.findAll(); }


@Roles(Role.ADMIN)
@Get(':id')
findOne(@Param('id') id: string) { return this.tours.findOne(id); }


@Roles(Role.ADMIN)
@Patch(':id')
update(@Param('id') id: string, @Body() body: any) { return this.tours.update(id, body); }


@Roles(Role.ADMIN)
@Delete(':id')
remove(@Param('id') id: string) { return this.tours.remove(id); }


@Roles(Role.ADMIN)
@Post('assign/:id/:courierId')
assign(@Param('id') id: string, @Param('courierId') courierId: string) { return this.tours.assign(id, courierId); }


@Roles(Role.ADMIN)
@Post('auto-assign')
autoAssign(@Body() body: { date: string }) { return this.tours.autoAssign(body.date); }

}