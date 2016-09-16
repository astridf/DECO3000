import oscP5.*;
import netP5.*;
import gab.opencv.*;
import java.awt.Rectangle;
import processing.video.*;
import themidibus.*;

//Create the midibus port
MidiBus midi1;
MidiBus midi2;
MidiBus midi3;
MidiBus midi4;
MidiBus midi5;
MidiBus midi6;

//Create the OpenCV instance
OpenCV opencv;
//Simulated video
Movie video;
//Image that holds each frame of the video
PImage currentFrame;
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
int currentBlobID = 1;
//Minimum size of blob
int minBlobSize = 20;

void setup() {
    frameRate(30);
    size(512, 428, P2D);

    //Kinect simulated video
    video = new Movie(this, "c.mp4");
    video.loop();
    video.play(); 

    opencv = new OpenCV(this, 512, 428);
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
    //Grab the last frame
    if (video.available()) {
        video.read();
    }
    
    //Load the frame into OpenCV
    opencv.loadImage(video);
    
    //Take a snapshot so we can display it later
    currentFrame = opencv.getSnapshot();
    
    //Clean it up a little bit to improve blob tracking
    opencv.threshold(75);
    opencv.dilate();
    opencv.erode();

    // Display image
    image(currentFrame, 0, 0);

    //Detect all blobs
    detectBlobs();
    
    //Display the blobs ontop of image
    for (Blob blob : blobList) {
        strokeWeight(2);
        blob.display();
    }
    blobsToMidi();
    sendTUIO();
}


