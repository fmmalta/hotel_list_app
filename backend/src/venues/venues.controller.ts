import { Controller, Get, Param, Query } from '@nestjs/common';
import { VenuesService } from './venues.service';

@Controller('venues')
export class VenuesController {
  constructor(private readonly venuesService: VenuesService) {}

  @Get()
  async findAll(
    @Query('page') page: number = 1,
    @Query('limit') limit: string = '10',
    @Query('sort') sort: string = 'createdAt',
    @Query('order') order: string = 'desc',
    @Query('category') categoryName: string = '',
    @Query('search') search: string = '',
    @Query('facilities') facilities: string = '',
  ) {
    // Parse comma-separated facilities into array
    const facilityNames = facilities ? facilities.split(',') : [];

    return this.venuesService.findAll(
      page,
      limit,
      sort,
      order,
      categoryName,
      search,
      facilityNames,
    );
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    return this.venuesService.findOne(id);
  }
}
