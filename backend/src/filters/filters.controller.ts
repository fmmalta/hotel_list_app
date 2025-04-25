import { Controller, Get } from '@nestjs/common';
import { FiltersService } from './filters.service';

@Controller('filters')
export class FiltersController {
  constructor(private readonly filtersService: FiltersService) {}

  @Get()
  async getAllFilters() {
    return this.filtersService.getAllFilters();
  }
}
