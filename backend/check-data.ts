// backend/check-data.ts

import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  const facilities = await prisma.facility.findMany();
  const activities = await prisma.activity.findMany();
  const venues = await prisma.venue.findMany({
    include: {
      facilities: true,
      activities: true,
      images: true,
    },
  });

  console.log(`Total venues: ${venues.length}`);
  console.log(`Total facilities: ${facilities.length}`);
  console.log(`Total activities: ${activities.length}`);
  console.log(
    `Total images: ${venues.reduce((sum, venue) => sum + venue.images.length, 0)}`,
  );

  console.log('\nAll Facilities:');
  facilities.forEach((f) => console.log(` - ${f.name}`));

  console.log('\nAll Activities:');
  activities.forEach((a) => console.log(` - ${a.name}`));

  console.log('\nFirst venue details:');
  const firstVenue = venues[0];
  console.log(`Name: ${firstVenue.name}`);
  console.log(`Location: ${firstVenue.location}`);
  console.log(`Rating: ${firstVenue.rating}`);
  console.log(`Price: ${firstVenue.price}`);

  console.log('Facilities:');
  firstVenue.facilities.forEach((f) => console.log(` - ${f.name}`));

  console.log('Activities:');
  firstVenue.activities.forEach((a) => console.log(` - ${a.name}`));

  console.log(`Images: ${firstVenue.images.length}`);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
