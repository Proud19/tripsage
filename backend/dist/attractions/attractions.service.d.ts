import { User } from '@prisma/client';
import { PrismaService } from 'src/prisma.service';
export declare class AttractionsService {
    private prisma;
    constructor(prisma: PrismaService);
    getAttractions(): Promise<User[]>;
}
