
int frameNum = 0;
float[][] sendBlobs;
OscBundle oSCBundle;

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
        
        //currentY = (((currentY * 424f) - 150f) /274f);

        oSCMessage2 = new OscMessage("/tuio/2Dcur");
        oSCMessage2.add("set");
        oSCMessage2.add(blob.getID());
        oSCMessage2.add(currentX);
        oSCMessage2.add(currentY);
        oSCMessage2.add(0f);
        oSCMessage2.add(0f);
        oSCMessage2.add(float(2));
        oSCBundle.add(oSCMessage2);
    }
    
    OscMessage oSCMessage3 = new OscMessage("/tuio/2Dcur");
    oSCMessage3.add("fseq");
    oSCMessage3.add(frameNum);
    oSCBundle.add(oSCMessage3);
    oscP5Location1.send(oSCBundle, location2);
    frameNum++;
}
