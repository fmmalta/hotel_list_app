export class Venue {
  id: string;
  name: string;
  type: 'Hotel' | 'BeachClub' | 'CommunityClub';
  overview: string;
  openingHours: string;
  location: {
    lat: number;
    lng: number;
    address: string;
  };
  images: string[];
  facilities: string[];
  familyAccess: boolean;
  guestAccess: boolean;
  activities: string[];
}
