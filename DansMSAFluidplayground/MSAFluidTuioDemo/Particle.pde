/***********************************************************************
 
 Copyright (c) 2008, 2009, Memo Akten, www.memo.tv
 *** The Mega Super Awesome Visuals Company ***
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of MSA Visuals nor the names of its contributors 
 *       may be used to endorse or promote products derived from this software
 *       without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS 
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE. 
 *
 * ***********************************************************************/ 
 
class Particle {
  /*
    If you want something with the momentum make MOMENTUM none static and 
    turn it from 0.00005 to 0.1 for a low to 0.7 for some fast particles
    FLUID_FORCE sort of has a similar effect so whatever one you want to change.
    FLUID will start getting crazy past 1.5ish
  */
    final static float MOMENTUM = 0.1;
    final static float FLUID_FORCE = 0.9;

    float x, y;
    float vx, vy;
    float radius;       // particle's size
    float alpha;
    float mass;

    void init(float x, float y) {
        this.x = x;
        this.y = y;
        vx = 0;
        vy = 0;
        radius = 5;
        alpha  = random(0.3, 1);
        mass = random(0.1, 1);
    }
  
  
    void update() { 
        // only update if particle is visible
        if(alpha == 0) return;

        // read fluid info and add to velocity
        int fluidIndex = fluidSolver.getIndexForNormalizedPosition(x * invWidth, y * invHeight);
        vx = fluidSolver.u[fluidIndex] * width * mass * FLUID_FORCE + vx * MOMENTUM;
        vy = fluidSolver.v[fluidIndex] * height * mass * FLUID_FORCE + vy * MOMENTUM;
 
        // update position
        x += vx;
        y += vy;

        // bounce of edges
        if(x<0) {
            x = 0;
            vx *= -1;
        }
        else if(x > width) {
            x = width;
            vx *= -1;
        }

        if(y<0) {
            y = 0;
            vy *= -1;
        }
        else if(y > height) {
            y = height;
            vy *= -1;
        }
        // hackish way to make particles glitter when the slow down a lot
      
        /*
           Ive been trying my best to get this one working with speed or something else other than location
           I definitely got the sparkling working with the y axis, which is kinda good I guess. I tried to do 
           Speed or Acceleration with tcur.getMotionAccel and .getMotionSpeed but the results they give range from
           negative decimals all the way to positive in the 20s which is super hard to translate to something.
        */
        if(motionAccel > 0.1){
          if(vx * vx + vy * vy < 1) {
            vx = random(-1, 10);
            vy = random(-1, 10);
        }
        } else{
          if(vx * vx + vy * vy < 1) {
            vx = random(-1, 1);
            vy = random(-1, 1);
        }
        }
        
        
        // fade out a bit (and kill if alpha == 0);
        alpha *= 0.999;
        if(alpha < 0.1) alpha = 0;
    }

    void updateVertexArrays(int i, FloatBuffer posBuffer, FloatBuffer colBuffer) {
        int vi = i * 2;
        posBuffer.put(vi++, x - vx);
        posBuffer.put(vi++, y - vy);
        int ci = i * 4;
        colBuffer.put(ci++, alpha);
        colBuffer.put(ci++, alpha);
        colBuffer.put(ci++, alpha);
    }

    void drawOldSchool(GL2 gl) {
      
      //I got blob x working fine with the color, that shit is easy
//        if(tcurx < 0.33){  
//          gl.glColor3f(1, 0.5, 0.1); //left
//        } else if(txurx > 0.66){
//          gl.glColor3f(0, 0.25, 1); //right
//        } else{
//          gl.glColor3f(0.25, 0.05, 0); //middle
//        }
    //
    /*
    speedColor was just a variable where I tried to add tiny tiny increments
    to whenever the speed was above 2.0 and minus if it was below. In the gl.glColor3F
   check the rules I put at the very bottom for how color works. But my attempt was speed would 
   change the opacity on the white particles, didn't work though. Not sure if its cause I suck or 
   if the approach was wrong all together. Be careful if you are updating variables or + or - them in this 
   update function it runs a bunch of times instantly, crashed my processing like 3 times by having a single 
   println in it running for like 3 seconds. 
    */
          gl.glColor3f(speedColor, speedColor, speedColor); //left
          
        gl.glVertex2f(x-vx, y-vy);
        gl.glVertex2f(x, y);
    }
}

float speedColor = 0.5;


float tcurx;
float tcury;
float blobvxp;
float blobvyp;
float motionAccel;

void sendVariable(float tcursx, float tcursy, float vx, float vy, float motionAccel, float motionSpeed){

  motionAccel = motionAccel;
  motionSpeed = motionSpeed;
  
  blobvxp = vx;
  blobvyp = vy;
  tcurx = tcursx; 
  tcury = tcursy;
}

/*
How to control the color:
(R, G, B)
2 Color Combo,
make outside color 1,
to make inside color weak: 0.25,
middle strength: 0.5,
Strong: 0.75

and the final last color you dont wanna see, make that a 0

3 Color Combo (must be white)
Repeat process for 2 color combo but set third color to,
weak: 0.05
mid: 0.1
strong: 0.2

Mixing Colors: done all in ratio, eg
RGB 0 0 0,
To make yellow mix Red and Green,
RGB 1 1 0, = solid yellow


Opacity: anything below 1 as a whole will reduce opacity
0.5 starts to take effect,
then 0.25, good amount
0.1, near invisible

Note: Color combos work fine aslong as you adjust ratio properly
however at low visibility cant really see much of a change

*/





