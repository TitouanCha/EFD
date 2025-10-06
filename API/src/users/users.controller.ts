import { Body, Controller, Delete, Get, Param, Patch, Post, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { Roles } from '../common/decorators/roles.decorator';
import { Role } from '../common/roles';
import { RolesGuard } from '../common/guards/roles.guard';
import { AuthGuard } from '@nestjs/passport';


@ApiTags('users')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'), RolesGuard)
@Roles(Role.ADMIN)
@Controller('users')
export class UsersController {
constructor(private readonly users: UsersService) {}


@Post()
create(@Body() dto: CreateUserDto) { return this.users.create(dto); }


@Get()
findAll(@Query('role') role?: string) { return this.users.findAll(role); }


@Get(':id')
findOne(@Param('id') id: string) { return this.users.findOne(id); }


@Patch(':id')
update(@Param('id') id: string, @Body() dto: UpdateUserDto) { return this.users.update(id, dto); }


@Delete(':id')
remove(@Param('id') id: string) { return this.users.remove(id); }
}