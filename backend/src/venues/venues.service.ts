import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class VenuesService {
  constructor(private readonly prisma: PrismaService) {}
  async findAll(
    page: number,
    limit: string,
    sort: string,
    order: string,
    categoryName?: string,
    search?: string,
    facilityNames?: string[],
  ) {
    const limitNumber = parseInt(limit, 10);

    const where: any = {};

    if (categoryName) {
      where.venueType = {
        equals: categoryName.toLowerCase(),
      };
    }

    if (search) {
      where.name = {
        contains: search,
      };
    }

    // Add facility filter
    if (facilityNames && facilityNames.length > 0) {
      // Use OR condition between facilities and activities
      where.OR = [
        {
          facilities: {
            some: {
              name: {
                in: facilityNames,
              },
            },
          },
        },
        {
          activities: {
            some: {
              name: {
                in: facilityNames,
              },
            },
          },
        },
      ];
    }

    return this.prisma.venue.findMany({
      skip: (page - 1) * limitNumber,
      take: limitNumber,
      orderBy: { [sort]: order },
      where,
      include: {
        coordinates: true,
        images: true,
        activities: true,
        facilities: true,
        categories: true,
        thingsToDo: {
          include: {
            items: true,
          },
        },
      },
    });
  }

  async findOne(id: string) {
    return this.prisma.venue.findUnique({
      where: { id },
      include: {
        images: true,
        activities: true,
        facilities: true,
        coordinates: true,
        categories: true,
        thingsToDo: {
          include: {
            items: true,
          },
        },
      },
    });
  }
}
