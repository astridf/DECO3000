//haven't messed with ParticleSystem yet for TUIO stuff.


import java.nio.FloatBuffer;
import com.sun.opengl.util.*;

boolean renderUsingVA = false;

void fadeToColor(GL2 gl, float r, float g, float b, float speed) {
    gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_SRC_ALPHA);
    gl.glColor4f(r, g, b, speed);
    gl.glBegin(gl.GL_QUADS);
    gl.glVertex2f(0, 0);
    gl.glVertex2f(width, 0);
    gl.glVertex2f(width, height);
    gl.glVertex2f(0, height);
    gl.glEnd();
}

class ParticleSystem {
    FloatBuffer posArray;
    FloatBuffer colArray;
    final static int maxParticles = 1000;
    int curIndex;
    Particle[] particles;
    
    //make the maxParticlesLeft, because there are technically 2 particle systems they should be half 5000 so 2500 each but I just have them at 1000 cause whatever. 
    final static int maxParticlesleft = 1000;
    //create another Index counter
    int curIndexleft;
    //create another aprticle array
    Particle[] particlesleft;
    
    ParticleSystem() {
        particles = new Particle[maxParticles];
        for(int i=0; i<maxParticles; i++) particles[i] = new Particle();
        curIndex = 0;
        
        //instantiate the array you just made 
        particlesleft = new Particle[maxParticles];
         //add another checker to see if the new array has reached max particle count
        for(int i=0; i<maxParticles; i++) particlesleft[i] = new Particle();
        //make newIndex to 0
        curIndexleft = 0;
        
        
        posArray = BufferUtil.newFloatBuffer(maxParticles * 2 * 2);// 2 coordinates per point, 2 points per particle (current and previous)
        colArray = BufferUtil.newFloatBuffer(maxParticles * 3 * 2);
    }


    void updateAndDraw(){
        //OPENGL Processing 2.1
        PGL pgl;                                  // JOGL's GL object
        pgl = beginPGL();
        GL2 gl = ((PJOGL)pgl).gl.getGL2();       // processings opengl graphics object               
        
        gl.glEnable( GL2.GL_BLEND );             // enable blending
        if(!drawFluid) fadeToColor(gl, 0, 0, 0, 0.05);

        gl.glBlendFunc(GL2.GL_ONE, GL2.GL_ONE);  // additive blending (ignore alpha)
        gl.glEnable(GL2.GL_LINE_SMOOTH);        // make points round
        gl.glLineWidth(1);
  
      //  I REMOVED A BUNCH OF CODE HERE. I GOT RID OF THE WHOLE RENDER USING VA PART, ITS JUST THE ELSE PART LEFT BUT OUT OF THE IF/ELSE STATEMENT
      
        gl.glBegin(gl.GL_LINES);               // start drawing points
        for(int i=0; i<maxParticles; i++) {
            if(particles[i].alpha > 0) {
                particles[i].update();
                particles[i].drawOldSchool(gl);
            }
        }
        
        //Add this whole method, basically just adding/updating/drawing for the new, second particle array
        for(int i=0; i<maxParticlesleft; i++) {
            if(particlesleft[i].alpha > 0) {
                particlesleft[i].update();
                particlesleft[i].drawOldSchoolleft(gl); //dont forget to make this new method in Particle
            }
        }
        
        gl.glEnd();
        gl.glDisable(GL2.GL_BLEND);
        endPGL();
    } 
    


    void addParticles(float x, float y, int count ){
        for(int i=0; i< count; i++) {
         if(mouseX<width/2){     
          addParticleleft(x + random(-15, 15), y + random(-15, 15));
         } else {
          addParticle(x + random(-15, 15), y + random(-15, 15)); 
         }
         
    }
    }

    void addParticle(float x, float y) {
        particles[curIndex].init(x, y);
        curIndex++;
        if(curIndex >= maxParticles) curIndex = 0;
    }
     void addParticleleft(float x, float y) {
        particlesleft[curIndexleft].init(x, y);
        curIndexleft++;
        if(curIndexleft >= maxParticlesleft) curIndexleft = 0;
    }
}

/*
  My Changes Made:
  added a second addParticle called addParticleleft located below the original addParticle in this sketch.
  in addParticles that is called from MSAFLuidTuioDemo I added a if statement that checked where the mouseX was,
  this can be changed to be blobs easy. Then depending on the location will decide which addParticle/left is chosen.
 
  You have to make a few variables at the top, some arrays and stuff they have comments directly above them if I added them. Basically anything with left in it copy. 
  
  I removed a bunch of code that was for the sticks/regular visuals just cause it annoyed me.  You can keep it in if you want. 
  
  Add another for loop for updating/drawing/rendering the new array of particles
  
  Added another oldschooldrawleft in particle, go see that page for it. 
*/






