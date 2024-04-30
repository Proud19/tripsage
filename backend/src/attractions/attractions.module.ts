import { Module } from '@nestjs/common';
import { AttractionsService } from './attractions.service';
import { AttractionsController } from './attractions.controller';
import { PrismaService } from 'src/prisma.service';

@Module({
  controllers: [AttractionsController],
  providers: [PrismaService, AttractionsService],
})
export class AttractionsModule {}
