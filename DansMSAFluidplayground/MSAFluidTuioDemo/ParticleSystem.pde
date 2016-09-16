//haven't messed with ParticleSystem yet for TUIO stuff.


import java.nio.FloatBuffer;
import com.sun.opengl.util.*;

boolean renderUsingVA = true;

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
    final static int maxParticles = 5000;
    int curIndex;
    Particle[] particles;
    ParticleSystem() {
        particles = new Particle[maxParticles];
        for(int i=0; i<maxParticles; i++) particles[i] = new Particle();
        curIndex = 0;
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

        if(renderUsingVA) {
            for(int i=0; i<maxParticles; i++) {
                if(particles[i].alpha > 0) {
                    particles[i].update();
                    particles[i].updateVertexArrays(i, posArray, colArray);
                }
            }    
            gl.glEnableClientState(GL2.GL_VERTEX_ARRAY);
            gl.glVertexPointer(2, GL2.GL_FLOAT, 0, posArray);
            gl.glEnableClientState(GL2.GL_COLOR_ARRAY);
            gl.glColorPointer(3, GL2.GL_FLOAT, 0, colArray);
            gl.glDrawArrays(GL2.GL_LINES, 0, maxParticles * 2);
        } 
        else {
            gl.glBegin(gl.GL_LINES);               // start drawing points
            for(int i=0; i<maxParticles; i++) {
                if(particles[i].alpha > 0) {
                    particles[i].update();
                    particles[i].drawOldSchool(gl);    // use oldschool renderng
                }
            }
            gl.glEnd();
        }
        gl.glDisable(GL2.GL_BLEND);
        endPGL();
    }


    void addParticles(float x, float y, int count ){
        for(int i=0; i< count; i++) addParticle(x + random(-15, 15), y + random(-15, 15));
    }

    void addParticle(float x, float y) {
        particles[curIndex].init(x, y);
        curIndex++;
        if(curIndex >= maxParticles) curIndex = 0;
    }
}








