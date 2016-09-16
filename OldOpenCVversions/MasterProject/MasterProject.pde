import org.openkinect.processing.*;
import gab.opencv.*;
import java.awt.Rectangle;
import processing.video.*;
import oscP5.*;
import netP5.*;
import themidibus.*;

//Create the midibus port
MidiBus midi1;
MidiBus midi2;
MidiBus midi3;
MidiBus midi4;
MidiBus midi5;
MidiBus midi6;

KinectData kinect;
//OpenCV for blob detection
OpenCV opencv;
//Image that holds each frame from the kinect
PImage displayKinect;
//Set up osc location
OscP5 oscP5Location1;
//Set up osc net address
NetAddress location2;
//ArrayList of contours
ArrayList<Contour> contours;
//Arraylist of new blob contours refreshed every frame
ArrayList<Contour> newFrameBlobs;
//Arraylist of persisting blobs
ArrayList<Blob> blobList;

//Total number of blobs so far, we use this as an identifier
int currentBlobID = 0;
//Minimum size of blob
int minBlobSize = 20;

// Depth data
int[] depth;

void setup() {
    frameRate(30);
    size(512, 424, P2D);
    kinect = new KinectData(this);
    opencv = new OpenCV(this, 512, 424);
    contours = new ArrayList<Contour>();
    blobList = new ArrayList<Blob>();
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
  
    //Load the frame into OpenCV
    opencv.loadImage(displayKinect);
    
    //Take a snapshot so we can display it later
    displayKinect = opencv.getSnapshot();
    
    //Clean it up a little bit to improve blob tracking
    opencv.threshold(75);
    opencv.dilate();
    opencv.erode();

    // Display image
    image(displayKinect, 0, 0);

    //Detect all blobs
    detectBlobs();
    
    //Display the blobs ontop of image
    for (Blob blob : blobList) {
        strokeWeight(2);
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

