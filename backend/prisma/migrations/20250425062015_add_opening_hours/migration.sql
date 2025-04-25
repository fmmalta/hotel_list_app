/*
  Warnings:

  - Added the required column `openingHours` to the `Venue` table without a default value. This is not possible if the table is not empty.

*/
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
    "openingHours" TEXT NOT NULL
);
INSERT INTO "new_Venue" ("createdAt", "id", "location", "name", "overview", "price", "rating") SELECT "createdAt", "id", "location", "name", "overview", "price", "rating" FROM "Venue";
DROP TABLE "Venue";
ALTER TABLE "new_Venue" RENAME TO "Venue";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
