
//We need to store the IDs of the blobs so we can match them
//We also need to store the channels they were sending to so we can
//keep sending the data to the right place

//left blob 1, left blob 2, middle blob 1, middle blob 2, right blob 1, right blob 2
//{blobID, MIDI channel/track/whatever should be 1-6 }
int[][] blobIDsAndChannels = {{0,1},{0,2},{0,3},{0,4},{0,5},{0,6}};

IntList leftBlobs = new IntList();
int[] middleBlobs = new int[5];
int[] rightBlobs = new int[5];

int leftCount = 0;
int middleCount = 0;
int rightCount = 0;

void sendMIDI() {
    //First of all we want to store all the blobs in the right lists
    for (Blob blob : blobList) {
        //If blob is in left third of canvas
        if (blob.getBlobX() <= (width/3)){
            //Just check incase there are more than 5 blobs, we can ignore
            if(rightCount <= 4){
                //We want to add it's ID so we can check it in the next step
                leftBlobs.append(blob.getBlobID());
               // println("add to leftBlobs: " + blob.getBlobID());
                leftCount++;
            }
        }
        //If blob is in the middle
        else if (blob.getBlobX() > (width/3) && blob.getBlobX() <= ((width/3)*2)){
            //Just check incase there are more than 5 blobs, we can ignore
            if(middleCount <= 4){
                //We want to add it's ID so we can check it in the next step
                middleBlobs[middleCount] = blob.getBlobID();
                middleCount++;
            }
        }
        //If blob is in the right third
        else {
            //Just check incase there are more than 5 blobs, we can ignore
            if(rightCount <= 4){
                //We want to add it's ID so we can check it in the next step
                rightBlobs[rightCount] = blob.getBlobID();
                rightCount++;
            }  
        }
    }
    //Reset all the counts
    leftCount = 0;
    middleCount = 0;
    rightCount = 0;

   int[] hasSentLeft = {0, 0};
   
    //For each blob in the leftBlobs list
    for (int i = 0; i < leftBlobs.size() ; i++) {
        //Check element 0 and 1 in the blobIDsAndChannels array
        for (int j = 0; j < 2; j++) {
            //Check if the blob ID from the leftBlobs list matches the blob ID stored
            if (blobIDsAndChannels[j][0] == leftBlobs.get(i) && leftBlobs.get(i) != 0){
                println( blobIDsAndChannels[j][0] + " matches " + leftBlobs.get(i));
                hasSentLeft[j] = 1;
                leftBlobs.set(i, 0);
                
            }
        }
    }
   
    //Check element 0 and 1 in the blobIDsAndChannels array
    for (int j = 0; j < 2; j++) {
        //For each blob in the leftBlobs list
        for (int i = 0; i < leftBlobs.size() ; i++) {
            //If the track hasn't been sent, send a blob
            if(hasSentLeft[j] != 1 && leftBlobs.get(i) != 0){
                blobIDsAndChannels[j][0] = leftBlobs.get(i);
                println("Add " + leftBlobs.get(i) + " to track " + j);
                hasSentLeft[j] = 1;
                leftBlobs.set(i, 0);
            }
        }
    }
    leftBlobs.clear();
}
