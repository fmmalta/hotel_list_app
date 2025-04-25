// backend/prisma/seed.ts

import { PrismaClient } from '@prisma/client';
import hotelsData from '../base_data/hotels.json';

const prisma = new PrismaClient();

// Define which categories are facilities and which are activities
const FACILITY_CATEGORIES = [
  'Beach',
  'Adults-only pool',
  'Lap pool',
  'Kids pool',
  'Rooftop pool',
  'Swim-up bar',
  'Hotel',
];
const ACTIVITY_CATEGORIES = [
  'Free nanny access',
  'Free access for 3 kids',
  'Free access for 2 kids',
  'Free access for 17-year-olds',
  'Venue guest rates',
];

async function main() {
  // First clear existing data
  console.log('Clearing existing data...');
  await prisma.image.deleteMany();
  // These tables might not exist yet if this is the first run, so we skip them
  // await prisma.$executeRaw`DELETE FROM "_FacilityToVenue"`;
  // await prisma.$executeRaw`DELETE FROM "_ActivityToVenue"`;
  await prisma.venue.deleteMany();
  await prisma.facility.deleteMany();
  await prisma.activity.deleteMany();
  await prisma.category.deleteMany();
  await prisma.filter.deleteMany();

  console.log('Seeding database...');

  // Create venues first
  console.log(`Creating ${hotelsData.items.length} venues...`);
  for (const hotel of hotelsData.items) {
    const facilityCategories = hotel.categories.filter(
      (cat) => cat.category && FACILITY_CATEGORIES.includes(cat.category),
    );

    const activityCategories = hotel.categories.filter(
      (cat) => cat.category && ACTIVITY_CATEGORIES.includes(cat.category),
    );

    // Use placeholder values for rating and price
    const rating = 4.5; // Placeholder - adjust as needed
    const price = 500; // Placeholder - adjust as needed

    // First create the venue
    const venue = await prisma.venue.create({
      data: {
        name: hotel.name,
        location: hotel.location,
        rating,
        price,
        overview: hotel.overviewText.map((text) => text.text).join(' '),
        venueType: hotel.type,
        coordinates: {
          create: {
            latitude: hotel.coordinates.lat,
            longitude: hotel.coordinates.lng,
          },
        },
        thingsToDo: {
          create: hotel.thingsToDo.map((item) => ({
            title: item.title,
            badge: item.badge || '',
            subtitle: item.subtitle || '',
          })),
        },
      },
    });

    // Create images
    await Promise.all(
      hotel.images.map((image) =>
        prisma.image.create({
          data: {
            url: image.url,
            venueId: venue.id,
          },
        }),
      ),
    );

    // Create or connect facilities and link to venue
    for (const category of facilityCategories) {
      let facility = await prisma.facility.findUnique({
        where: { id: category.id },
      });

      if (!facility) {
        facility = await prisma.facility.create({
          data: {
            id: category.id,
            name: category.category,
          },
        });
      }

      await prisma.venue.update({
        where: { id: venue.id },
        data: {
          facilities: {
            connect: { id: facility.id },
          },
        },
      });
    }

    // Create or connect activities and link to venue
    for (const category of activityCategories) {
      let activity = await prisma.activity.findUnique({
        where: { id: category.id },
      });

      if (!activity) {
        activity = await prisma.activity.create({
          data: {
            id: category.id,
            name: category.category,
          },
        });
      }

      await prisma.venue.update({
        where: { id: venue.id },
        data: {
          activities: {
            connect: { id: activity.id },
          },
        },
      });
    }
  }
  for (const filter of hotelsData.filters) {
    await prisma.filter.create({
      data: {
        name: filter.name,
        type: filter.type,
        categories: {
          create: filter.categories.map((category) => ({
            id: category.id,
            name: category.name,
          })),
        },
      },
    });
  }

  const allFilters = await prisma.filter.findMany({
    include: { categories: true },
  });
  console.dir(allFilters, { depth: null });

  console.log('Database seeded successfully!');

  // Verify data
  const venueCount = await prisma.venue.count();
  const facilityCount = await prisma.facility.count();
  const activityCount = await prisma.activity.count();
  const imageCount = await prisma.image.count();

  console.log(
    `Verification: ${venueCount} venues, ${facilityCount} facilities, ${activityCount} activities, ${imageCount} images`,
  );
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
