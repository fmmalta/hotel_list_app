-- CreateTable
CREATE TABLE "ThingToDo" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "title" TEXT NOT NULL,
    "badge" TEXT,
    "subtitle" TEXT,
    "content" TEXT,
    "venueId" TEXT NOT NULL,
    CONSTRAINT "ThingToDo_venueId_fkey" FOREIGN KEY ("venueId") REFERENCES "Venue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "ThingToDoItem" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "title" TEXT,
    "imageUrl" TEXT,
    "thingToDoId" TEXT NOT NULL,
    CONSTRAINT "ThingToDoItem_thingToDoId_fkey" FOREIGN KEY ("thingToDoId") REFERENCES "ThingToDo" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
