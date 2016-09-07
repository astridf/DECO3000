import oscP5.*;
import netP5.*;
import gab.opencv.*;
import java.awt.Rectangle;
import processing.video.*;
import themidibus.*;

//Create the midibus port
MidiBus midiport;
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
    
    midiport.list();
    //May need to change this for your computer, look at the outputs from the
    //line above, and change the third parameter to the port you want
    midiport = new MidiBus(this, -1, 5);
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
    sendMIDI();
    sendTUIO();
}


