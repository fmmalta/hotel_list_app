/*
  Warnings:

  - Added the required column `coordinatesId` to the `Venue` table without a default value. This is not possible if the table is not empty.
  - Added the required column `venueType` to the `Venue` table without a default value. This is not possible if the table is not empty.

*/
-- CreateTable
CREATE TABLE "Coordinates" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "latitude" REAL NOT NULL,
    "longitude" REAL NOT NULL
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
    CONSTRAINT "Venue_coordinatesId_fkey" FOREIGN KEY ("coordinatesId") REFERENCES "Coordinates" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Venue" ("createdAt", "id", "location", "name", "overview", "price", "rating") SELECT "createdAt", "id", "location", "name", "overview", "price", "rating" FROM "Venue";
DROP TABLE "Venue";
ALTER TABLE "new_Venue" RENAME TO "Venue";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
