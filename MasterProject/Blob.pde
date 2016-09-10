
class Blob {
    private PApplet parent;
    //Need some contours
    public Contour contour;
    //Has the blob been matched or is it available?
    public boolean available;
    //Has the blob been marked to be deleted?
    public boolean delete;

    //Lifespan of blob after disappearing
    private int initTimer = 5;
    //Used to track the countdown
    public int timer;
    //Let's have an ID for each blob so we can track them
    int id;
    //How many frames has the blob been alive for?
    int aliveTime;
    //Co-ordinates from the previous frame
    float prevX;
    float prevY;
    //How far has the blob travelled?
    float distance;
    //How fast is the blob travelling?
    float speed;

    Blob(PApplet parent, int id, Contour c) {
        this.parent = parent;
        this.id = id;
        this.contour = new Contour(parent, c.pointMat);
        //All blobs should start as available
        available = true;
        //No blob should start already marked to be deleted
        delete = false;
        //Set the timer
        timer = initTimer;
        //Set alive time to 1, since this is the first frame
        this.aliveTime = 1;
        //Set distance and speed to 0;
        this.distance = 0;
        this.speed = 0;
        //Set the previous coordinates, since this is the first frame
        prevX = getBlobX();
        prevY = getBlobY();
    }

    void display() {
        //Set the rectangle to be the box around the contours
        Rectangle r = contour.getBoundingBox();
        //Work out the opacity based on the timer
        float opacity = map(timer, 0, initTimer, 0, 127);
        fill(0, 0, 255, opacity);
        stroke(0, 0, 255);
        //Draw the box around the blob
        rect(r.x, r.y, r.width, r.height);
        fill(255, 2 * opacity);
        textSize(18);
        //Add the ID label, offset so we can see it
        text("ID: " + id, r.x + 10, r.y - 2);
        textSize(14);
        //Add the ID label, offset so we can see it
        text("x: " + int(getBlobX()) + " y: " + int(getBlobY()), r.x + 10, r.y + 15);
        text("Speed: " + int(speed), r.x + 10, r.y + 35);
        text("Depth: " + getDepth(), r.x + 10, r.y + 55);
    }

    //Update location
    void update(Contour newC) {
        contour = new Contour(parent, newC.pointMat);
        //Reset timer
        timer = initTimer;
        
        aliveTime++;
        
        distance += dist(prevX, prevY, getBlobX(), getBlobY());
        speed = distance/aliveTime;
        
        prevX = getBlobX();
        prevY = getBlobY();
    }

    void countDown() {    
        timer--;
    }

    boolean dead() {
        if (timer < 0){
            return true;
        }
        else {
            return false;
        }
    }

    public Rectangle getBoundingBox() {
        return contour.getBoundingBox();
    }
    
    //Return the blob ID
    public int getBlobID() {
        return id;
    }
    
    //Return the blob width
    public int getBlobWidth() {
        Double bWidth = contour.getBoundingBox().getWidth();
        return bWidth.intValue();
    }
    
    //Return the blob height
    public int getBlobHeight() {
        Double bHeight = contour.getBoundingBox().getHeight();
        return bHeight.intValue();
    }
    
    //Return the X centre point of the blob
    public float getBlobX() {
        Rectangle boundBox = contour.getBoundingBox();
        return boundBox.x + 0.5*boundBox.width;
    }
    
    //Return the Y centre point of the blob
    public float getBlobY() {
        Rectangle boundBox = contour.getBoundingBox();
        return boundBox.y + 0.5*boundBox.height;
    }
    
    //Return the current life duration of the blob
    public int getAliveTime() {
        return aliveTime;   
    }
    
    //Return the speed of the blob
    public float getBlobSpeed() {
        return speed;   
    }
    
    //Return the depth of the centre point in the blob (semi-reliable)
    public int getDepth() {
        int x = int(getBlobX());
        int y = int(getBlobY());
        int rawDepth = depth[displayKinect.width - x - 1 + y * displayKinect.width];
        return rawDepth;
    }
}

