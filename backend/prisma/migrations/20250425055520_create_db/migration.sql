-- CreateTable
CREATE TABLE "Venue" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    "rating" REAL NOT NULL,
    "price" REAL NOT NULL
);

-- CreateTable
CREATE TABLE "Image" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "url" TEXT NOT NULL,
    "venueId" TEXT NOT NULL,
    CONSTRAINT "Image_venueId_fkey" FOREIGN KEY ("venueId") REFERENCES "Venue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Facility" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "Activity" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_FacilityToVenue" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,
    CONSTRAINT "_FacilityToVenue_A_fkey" FOREIGN KEY ("A") REFERENCES "Facility" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "_FacilityToVenue_B_fkey" FOREIGN KEY ("B") REFERENCES "Venue" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "_ActivityToVenue" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,
    CONSTRAINT "_ActivityToVenue_A_fkey" FOREIGN KEY ("A") REFERENCES "Activity" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "_ActivityToVenue_B_fkey" FOREIGN KEY ("B") REFERENCES "Venue" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "Facility_name_key" ON "Facility"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Activity_name_key" ON "Activity"("name");

-- CreateIndex
CREATE UNIQUE INDEX "_FacilityToVenue_AB_unique" ON "_FacilityToVenue"("A", "B");

-- CreateIndex
CREATE INDEX "_FacilityToVenue_B_index" ON "_FacilityToVenue"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_ActivityToVenue_AB_unique" ON "_ActivityToVenue"("A", "B");

-- CreateIndex
CREATE INDEX "_ActivityToVenue_B_index" ON "_ActivityToVenue"("B");
