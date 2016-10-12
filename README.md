# DECO3000
Repo for DECO3000 Special Topics Course

##Code Explanation
-	For every frame that the sketch is running (e.g. 30 frames/second), the Kinect will send an array consisting of 512(width) x 424(height) of depth values of which each value is between 0 and 4500 (corresponding to cm).

-	Processing will take this information, as well as the threshold that has been set as just in front of the spandex, and will check each value against the threshold.

-	At this point, Processing has created a blank image of black pixels with the same dimensions as the Kinect (512 x 424).

-	For each value in the depth array, if the value is in front of the threshold, Processing will colour the corresponding pixel red. If the value is not in front of the threshold it will be left as black. So now we have an image for each frame which highlights only where the canvas is being pushed.

-	We will then take this image and apply a blurring algorithm to it to remove any stray particles the Kinect may have accidentally picked up, so that we end up with a much cleaner (albeit blurry) image.

-	Next, this image will be passed on to the Blob detection library, which will work its magic to determine where blobs are located in the image, which is why we applied a different colour to the pixels in front of the threshold.

-	Once the Blob detection library has finished its work, it will return an array of Blobs of which each has its own accessible properties (height, width, X, Y, etc.). However, this array is replaced every frame, and blobs in the array are in order of top left to bottom right, meaning that the same blob may not be in the same array index position across different frames, which is problematic.

-	In order to track these blobs across frames we are storing the array of blobs from the previous frame too, and them comparing it to the current frame to find which blobs existed in the previous frame.

-	In this comparison, there are 3 cases:
    1. There are more blobs in the current frame than there were in the previous frame (so new blobs have occurred)
    2. There are less blobs in the current frame than there were in the previous frame (so some blobs have died)
    3. There are the same number of blobs in the current frame as there were in the previous frame

-	The code that compares frames for blobs works by checking each blob in the new frame against every blob in the previous frame and comparing the distance away it is. It will find the closest blob within a specified range, and assume that it is the same blob, and will continue using its unique ID. 

-	If a new blob has occurred, a new Blob object will be created with a new ID. 

-	If a blob is no longer present in the new frame, it will be marked to be deleted and will survive for the next 5 frames before being deleted. 

-	If a similar enough blob reappears before it is deleted, then it will be marked as alive again, and will continue using its unique ID.

-	After analysing the blobs, we will have a resulting array of ‘Tracked’ blobs, which each have their own unique ID (a value incremented at every new blob), and will retain the properties of the blob it was identified as, including X, Y, width, height, etc.

-	For each of these ‘Tracked’ blobs, a number of functions are available to assist in calculating things like the speed, depth, and number of frames the blob has been alive for, all of which will be used in creating the sound and visuals.
