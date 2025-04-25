-- CreateTable
CREATE TABLE "Filter" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "Category" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "filterId" TEXT NOT NULL,
    CONSTRAINT "Category_filterId_fkey" FOREIGN KEY ("filterId") REFERENCES "Filter" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "VenueCategory" (
    "venueId" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,

    PRIMARY KEY ("venueId", "categoryId"),
    CONSTRAINT "VenueCategory_venueId_fkey" FOREIGN KEY ("venueId") REFERENCES "Venue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "VenueCategory_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "Category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "_VenueCategories" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,
    CONSTRAINT "_VenueCategories_A_fkey" FOREIGN KEY ("A") REFERENCES "Category" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "_VenueCategories_B_fkey" FOREIGN KEY ("B") REFERENCES "Venue" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Venue" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    "rating" REAL NOT NULL,
    "price" REAL NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "overview" TEXT NOT NULL,
    "venueType" TEXT NOT NULL,
    "coordinatesId" TEXT NOT NULL,
    "categoryId" TEXT,
    CONSTRAINT "Venue_coordinatesId_fkey" FOREIGN KEY ("coordinatesId") REFERENCES "Coordinates" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Venue_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "Category" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);
INSERT INTO "new_Venue" ("coordinatesId", "createdAt", "id", "location", "name", "overview", "price", "rating", "venueType") SELECT "coordinatesId", "createdAt", "id", "location", "name", "overview", "price", "rating", "venueType" FROM "Venue";
DROP TABLE "Venue";
ALTER TABLE "new_Venue" RENAME TO "Venue";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;

-- CreateIndex
CREATE UNIQUE INDEX "_VenueCategories_AB_unique" ON "_VenueCategories"("A", "B");

-- CreateIndex
CREATE INDEX "_VenueCategories_B_index" ON "_VenueCategories"("B");
