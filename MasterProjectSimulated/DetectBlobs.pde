
void detectBlobs() {
    //Find the contours of the blobs
    contours = opencv.findContours(true, true);
    //Get the blobs based on the contours
    newFrameBlobs = getBlobsFromContours(contours);

    //Now for the actual tracking part...

    //Case 1: The list of blobs is empty, so we either just started or there have been no recent blobs
    //Solution: Draw up every blob
    if (blobList.isEmpty()) {
        for (int i = 0; i < newFrameBlobs.size (); i++) {
            //Add blob to the list
            blobList.add(new Blob(this, currentBlobID, newFrameBlobs.get(i)));
            //Increment total blobs
            currentBlobID++;
        }
    } 
    
    //Case 2: There are more blobs in the new frame than there were in the last frame, so we have new blobs!
    //Solution: Find the closest ones to the previous blobs and update their locations, then add the rest
    else if (blobList.size() <= newFrameBlobs.size()) {
        //Let's record used blobs so they don't get matched twice
        boolean[] used = new boolean[newFrameBlobs.size()];
        //For each blob in the old list...
        for (Blob b : blobList) {
            float record = 50000;
            int index = -1;
            //For each blob in the new list....
            for (int i = 0; i < newFrameBlobs.size (); i++) {
                //Find the distance between the blobs
                float d = dist(newFrameBlobs.get(i).getBoundingBox().x, 
                                newFrameBlobs.get(i).getBoundingBox().y, 
                                b.getBoundingBox().x, 
                                b.getBoundingBox().y);
                //If the distance is closer than previous distances and the blob isn't already used
                if (d < record && !used[i]) {
                    //Record the new closest distance
                    record = d;
                    //Record the index of the current closest
                    index = i;
                }
            }
            //Mark the blob as being used
            used[index] = true;
            //Update the blob location
            b.update(newFrameBlobs.get(index));
        }
        //Draw in any blobs that are new and were not matched
        for (int i = 0; i < newFrameBlobs.size (); i++) {
            if (!used[i]) {
                //Add blob to the list
                blobList.add(new Blob(this, currentBlobID, newFrameBlobs.get(i)));
               //Increment total blobs
                currentBlobID++;
            }
        }
    } 
    
    //Case 3: There are less blobs in the new frame than there were in the last frame, so some have gone
    //Solution: Find the closest ones to the previous blobs and update their locations, delete the rest
    else {
        for (Blob b : blobList) {
            b.available = true;
        } 
        //For each blob in the new list...
        for (int i = 0; i < newFrameBlobs.size (); i++) {
            float record = 50000;
            int index = -1;
            //For each blob in the old list...
            for (int j = 0; j < blobList.size (); j++) {
                Blob b = blobList.get(j);
                //Find the distance between the blobs
                float d = dist(newFrameBlobs.get(i).getBoundingBox().x, 
                                newFrameBlobs.get(i).getBoundingBox().y, 
                                b.getBoundingBox().x, 
                                b.getBoundingBox().y);
                //If the distance is closer than previous distances and the blob is available
                if (d < record && b.available) {
                    //Record the new closest distance
                    record = d;
                    //Record the index of the current closest
                    index = j;
                }
            }
            //Get the closest blob
            Blob b = blobList.get(index);
            //Mark the blob as unavailable
            b.available = false;
            //Update the blob location
            b.update(newFrameBlobs.get(i));
        } 
        //Begin countdown to kill any left over blobs
        for (Blob b : blobList) {
            if (b.available) {
                b.countDown();
                if (b.dead()) {
                    b.delete = true;
                }
            }
        }
    }

    //Delete blobs that aren't used
    for (int i = blobList.size()-1; i >= 0; i--) {
        Blob b = blobList.get(i);
        if (b.delete) {
            blobList.remove(i);
        }
    }
}

ArrayList<Contour> getBlobsFromContours(ArrayList<Contour> newContours) {
    ArrayList<Contour> newBlobs = new ArrayList<Contour>();
    for (int i=0; i<newContours.size (); i++) {
        Contour contour = newContours.get(i);
        Rectangle r = contour.getBoundingBox();
        if ((r.width < minBlobSize || r.height < minBlobSize))
            continue;
        newBlobs.add(contour);
    }
    return newBlobs;
}

