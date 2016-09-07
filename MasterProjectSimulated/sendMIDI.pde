
//We need to store the IDs of the blobs so we can match them
//We also need to store the channels they were sending to so we can
//keep sending the data to the right place

//left blob 1, left blob 2, middle blob 1, middle blob 2, right blob 1, right blob 2
//{blobID, MIDI channel/track/whatever should be 1-6 }
int[][] blobIDsAndChannels = {{0,1},{0,2},{0,3},{0,4},{0,5},{0,6}};

int[] leftBlobs = new int[5];
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
                leftBlobs[leftCount] = blob.getBlobID();
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
    
    //Now we want to compare the list of blobs for each section to the previous frame
    //int[][] blobIDsAndChannels = {{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}};
    if(leftBlobs[0] != 0 && blobIDsAndChannels[0][0] == 0){
        blobIDsAndChannels[0][0] = leftBlobs[0];
        
    }
    else if(leftBlobs[1] != 0){
        blobIDsAndChannels[1][0] = leftBlobs[1];
    }
    
    
    
    int[] hasSentLeft = {0, 0};
    
    for(int i = 0; i < 2; i++){
        if(blobIDsAndChannels[i][0] == 0 && leftBlobs[i] != 0){
            blobIDsAndChannels[i][0] = leftBlobs[i];
        }
        for(int j = 0; j < 2; j++){
            if(leftBlobs[i] == blobIDsAndChannels[j][0] && leftBlobs[i] != 0){
                println("yes let's send midi for blob " + leftBlobs[i] + " to track " + j);
            }
            else {
                blobIDsAndChannels[j][0] = leftBlobs[i];
            }
            
        }
    }
    


}
int calculateMIDIvalue(float x, float y){
    x = x * 480f;
    y = (y * 420f) - 150f;
    //Map the x and y values to a new value between 0 and 127
    if (x < 160){
        println(int(map(x + y, 0, 580, 0, 127)));
        return int(map(x + y, 0, 580, 0, 127));
    }
    else if (x >= 160 && x < 320) {
        println(int(map(x + y, 160, 740, 0, 127)));
        return int(map(x + y, 160,740, 0, 127));
    }
    else if (x >= 320 && x <= 480) {
        println(int(map(x + y, 320, 900, 0, 127)));
        return int(map(x + y, 320, 900, 0, 127));
    }
    else{
        return 0;
    }
//    return int(map((x * 480) + (y * 420), 0, 900, 0, 127));
}
