import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class FiltersService {
  constructor(private prisma: PrismaService) {}

  async getAllFilters() {
    return this.prisma.filter.findMany({
      include: { categories: true },
    });
  }
}
