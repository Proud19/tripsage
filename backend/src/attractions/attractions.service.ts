import { Injectable } from '@nestjs/common';
import { User } from '@prisma/client';
import { PrismaService } from 'src/prisma.service';

@Injectable()
export class AttractionsService {
  constructor(private prisma: PrismaService) {}

  async getAttractions(): Promise<User[]> {
    const users = await this.prisma.user.findMany();
    return users;
  }
}
