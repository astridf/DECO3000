import org.openkinect.processing.*;
import gab.opencv.*;
import java.awt.Rectangle;
import processing.video.*;
import oscP5.*;
import netP5.*;

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
    size(515, 430, P2D);
    kinect = new KinectData(this);
    opencv = new OpenCV(this, 515, 430);
    contours = new ArrayList<Contour>();
    blobList = new ArrayList<Blob>();
    oscP5Location1 = new OscP5(this, 3334);
    location2 = new NetAddress("127.0.0.1", 3333);
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
    sendTUIO();
}

