
int frameNum = 0;
float[][] sendBlobs;
OscBundle oSCBundle;
float countDepth = 0;

void sendTUIO() {
    oSCBundle = new OscBundle();
    OscMessage oSCMessage2 = null;
    OscMessage oSCMessage4 = null;
    OscMessage oSCMessage5 = null;
    OscMessage oSCMessage = new OscMessage("/tuio/2Dcur");
    oSCMessage.add("alive");

    //Iterate through every blob detected
    for (TrackedBlob blob : blobList) {
        oSCMessage.add(blob.getID());
    }

    oSCBundle.add(oSCMessage);

    for (TrackedBlob blob : blobList) {
        //Get the current blob
        float currentX = float(blob.getBlobX())/width;
        float currentY = float(blob.getBlobY())/height;

        float blobSpeed = 0;
        if (blob.getBlobSpeed() > 28) {
            blobSpeed = 28;
        } else {
            blobSpeed = blob.getBlobSpeed();
        }  

        float blobLifeSpan = 0f;
        if (blob.getAliveTime() > 127) {
            blobLifeSpan = 127;
        } else {
            blobLifeSpan = blob.getAliveTime();
        }     
        
        if (countDepth > 127){
            countDepth = 0;
        }

        //currentY = (((currentY * 424f) - 150f) /274f);

        oSCMessage2 = new OscMessage("/tuio/2Dcur");
        oSCMessage2.add("set");
        oSCMessage2.add(blob.getID());
        oSCMessage2.add(currentX);
        oSCMessage2.add(currentY);
        oSCMessage2.add(blobSpeed);
        oSCMessage2.add(blobLifeSpan);
        oSCMessage2.add(countDepth);
        oSCBundle.add(oSCMessage2);
        
        countDepth++;
    }

    OscMessage oSCMessage3 = new OscMessage("/tuio/2Dcur");
    oSCMessage3.add("fseq");
    oSCMessage3.add(frameNum);
    oSCBundle.add(oSCMessage3);
    oscP5Location1.send(oSCBundle, location2);
    frameNum++;
}

