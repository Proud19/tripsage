import { Controller, Get } from '@nestjs/common';
import { AttractionsService } from './attractions.service';

@Controller('attractions')
export class AttractionsController {
  constructor(private readonly attractionsService: AttractionsService) {}

  @Get('getAttractions')
  getAttractions() {
    return this.attractionsService.getAttractions();
  }
}
