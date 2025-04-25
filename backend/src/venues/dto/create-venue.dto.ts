import { IsArray, IsBoolean, IsNumber, IsString } from 'class-validator';

export class CreateVenueDto {
  @IsString()
  name: string;

  @IsString()
  type: string;

  @IsString()
  overview: string;

  @IsString()
  openingHours: string;

  @IsNumber()
  lat: number;

  @IsNumber()
  lng: number;

  @IsString()
  address: string;

  @IsBoolean()
  familyAccess: boolean;

  @IsBoolean()
  guestAccess: boolean;

  @IsArray()
  images: string[];

  @IsArray()
  facilities: string[];
}
