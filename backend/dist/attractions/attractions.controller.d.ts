import { AttractionsService } from './attractions.service';
export declare class AttractionsController {
    private readonly attractionsService;
    constructor(attractionsService: AttractionsService);
    getAttractions(): Promise<{
        id: number;
        email: string;
        name: string;
    }[]>;
}
