import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { VenuesModule } from './venues/venues.module';
import { PrismaModule } from './prisma/prisma.module';
import { FiltersModule } from './filters/filters.module';

@Module({
  imports: [VenuesModule, PrismaModule, FiltersModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
