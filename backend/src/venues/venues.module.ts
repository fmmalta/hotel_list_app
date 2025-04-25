import { Module } from '@nestjs/common';
import { VenuesController } from './venues.controller';
import { VenuesService } from './venues.service';
import { PrismaModule } from 'src/prisma/prisma.module';
@Module({
  controllers: [VenuesController],
  providers: [VenuesService],
  imports: [PrismaModule],
})
export class VenuesModule {}
