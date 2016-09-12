import org.openkinect.processing.*;
import blobDetection.*;
import processing.video.*;
import oscP5.*;
import netP5.*;
import themidibus.*;
//START KINECT FROM BOTTOM OF FRAME

//Create the midibus port
MidiBus midi1;
MidiBus midi2;
MidiBus midi3;
MidiBus midi4;
MidiBus midi5;
MidiBus midi6;

KinectData kinect;
//Image that holds each frame from the kinect
PImage displayKinect;

//Create instance of blobdetection
BlobDetection newBlobList;

//Set up osc location
OscP5 oscP5Location1;
//Set up osc net address
NetAddress location2;

//Total number of blobs so far, we use this as an identifier
int currentBlobID = 1;

//Arraylist of persisting blobs
ArrayList<TrackedBlob> blobList;

// Depth data
int[] depth;

void setup() {
    frameRate(30);
    size(512, 424, P2D);
    kinect = new KinectData(this);

    newBlobList = new BlobDetection(512, 424);
    newBlobList.setPosDiscrimination(true);
    newBlobList.setThreshold(0.1f);
    blobList = new ArrayList<TrackedBlob>();
    
    oscP5Location1 = new OscP5(this, 3334);
    location2 = new NetAddress("127.0.0.1", 3333);
    
    //May need to change this for your computer, look at the outputs from the
    //line above, and change the third parameter to the port you want
    midi1 = new MidiBus(this, 3, "midi1");
    midi2 = new MidiBus(this, 4, "midi2");
    midi3 = new MidiBus(this, 5, "midi3");
    midi4 = new MidiBus(this, 6, "midi4");
    midi5 = new MidiBus(this, 7, "midi5");
    midi6 = new MidiBus(this, 8, "midi6");
    midi1.list();
}

void draw() {
    background(0);
    
    //Display the Kinect image
    kinect.display();
    
    //Appy the blur algorithm to the video so that tiny blobs don't cause problems
    blurAlgorithm(displayKinect, 10);
    
    //Compute the blobs for the current frame after the blur has been applied
    newBlobList.computeBlobs(displayKinect.pixels);
    
    detectBlobs(newBlobList);
    drawBlobsAndEdges(true, true, newBlobList);

    // Display image
    image(displayKinect, 0, 0);
    
    //Display Blob Info
    for (TrackedBlob blob : blobList) {
        blob.display();
    }
    
    blobsToMidi();
    sendTUIO();

    int threshold = kinect.getThreshold();
    fill(235);
    text("threshold: " + threshold, 30, 400);
}

// Adjust the threshold with key presses
void keyPressed() {
  int t = kinect.getThreshold();
  if (key == CODED) {
    if (keyCode == UP) {
      t +=5;
      kinect.setThreshold(t);
    } else if (keyCode == DOWN) {
      t -=5;
      kinect.setThreshold(t);
    }
  }
}
