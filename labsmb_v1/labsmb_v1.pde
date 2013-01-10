/**
* mcgarrybowen labs
* logo experiments v1
*
* by Anthony Tripaldi, Jan 2013
*/

import controlP5.*;
import megamu.shapetween.*;

//constants
//size modifier so we can work with normals
int SM = 75;
//triangle height
int TH = 2;

//declare COLORS used
int[] colors = {
    0xFFFACF29, // yellow
    0xFF6074B4, // blue
    0xFFED4B8F, // pink
    0xFF269D87, // aqua
    0xFF6BBB4A, // green
    0xFFEA1F3F, // red
    0xFFE75938 // orange
};

//declare shapes
PVector[] center_box = { 
  new PVector(-1,0,1), 
  new PVector(1,0,1), 
  new PVector(1,0,-1), 
  new PVector(-1,0,-1) 
  };
  
PVector[] top_front = {
  new PVector(0,-TH,0), //top
  new PVector(1,0,1), //left
  new PVector(-1,0,1) //right
}; 

PVector[] top_left = {
  new PVector(0,-TH,0),
  new PVector(-1,0,1),
  new PVector(-1,0,-1)
}; 

PVector[] top_back = {
  new PVector(0,-TH,0),
  new PVector(-1,0,-1),
  new PVector(1,0,-1)
}; 

PVector[] bottom_left = {
  new PVector(0,TH,0),
  new PVector(-1,0,-1),
  new PVector(-1,0,1)
};

PVector[] bottom_front = {
  new PVector(0,TH,0),
  new PVector(-1,0,1),
  new PVector(1,0,1)
};

PVector[] bottom_right = {
  new PVector(0,TH,0),
  new PVector(1,0,1),
  new PVector(1,0,-1)
};

Triangle[] triangles = {
  new Triangle( top_back, colors[2]),
  new Triangle( top_left, colors[1]),
  new Triangle( top_front, colors[0]),
  new Triangle( bottom_left, colors[4]),
  new Triangle( bottom_front, colors[5]),
  new Triangle( bottom_right, colors[6])
};

//starting rotation
float rotation = -40.0;

//controls
ControlP5 cp5;

//breathing animation controller
Tween breathingAnimation;

//get ready for all regular methods
void setup()
{
    size(640, 480, P3D);
    noStroke();
    smooth();
    
//    actual_logo = loadImage("labs_logo.png");
    
    gui();
    breathing();
}

void gui()
{
    cp5 = new ControlP5(this);
    
    int maxRotation = 90;
    int padding = 10;
    int sliderWidth = 150;
    int sliderHeight = 20;
    
    cp5.addSlider("rotationX")
       .setPosition(padding,padding)
       .setSize(sliderWidth,sliderHeight)
       .setRange(-maxRotation,maxRotation)
       .setValue(-24)
       ;
    cp5.addSlider("rotationY")
       .setPosition(padding,sliderHeight+padding*2)
       .setSize(sliderWidth,sliderHeight)
       .setRange(-maxRotation,maxRotation)
       .setValue(30)
       ;
    cp5.addSlider("rotationZ")
       .setPosition(padding,sliderHeight*2 + padding*3)
       .setSize(sliderWidth,sliderHeight)
       .setRange(-maxRotation,maxRotation)
       .setValue(0)
       ;
       
    cp5.addSlider("expansion")
       .setPosition(padding,sliderHeight*3 + padding*4)
       .setSize(sliderWidth,sliderHeight)
       .setRange(0,1)
       .setValue(0)
       ;
       
    cp5.addRange("rangeController")
       // disable broadcasting since setRange and setRangeValues will trigger an event
       .setBroadcast(false) 
       .setPosition(padding,sliderHeight*4 + padding*5)
       .setSize(sliderWidth,sliderHeight)
       .setHandleSize(20)
       .setRange(-1,2)
       .setRangeValues(.2,.6)
       // after the initialization we turn broadcast back on again
//       .setBroadcast(true)  
       ;
    
    //second row
    
    cp5.addSlider("size")
       .setPosition(sliderWidth + padding*2,padding)
       .setSize(sliderWidth,sliderHeight)
       .setRange(0,SM*2)
       .setValue(SM)
       ;
       
    cp5.addSlider("cAlpha")
       .setPosition(sliderWidth + padding*2,sliderHeight + padding*2)
       .setSize(sliderWidth,sliderHeight)
       .setRange(0,255)
       .setValue(200)
       ;
    
    
    //right side of screen
    
    cp5.addToggle("useMultiply")
       .setPosition(width - padding - 50, padding)
       .setSize(50,20)
       .setValue(false)
       .setMode(ControlP5.SWITCH)
       ;
       
    cp5.addToggle("drawOrigin")
       .setPosition(width - padding - 50, padding*2 + 20)
       .setSize(50,20)
       .setValue(true)
       .setMode(ControlP5.SWITCH)
       ;
       
    cp5.addToggle("isBreathing")
       .setPosition(width - padding - 50, padding*3 + 40)
       .setSize(50,20)
       .setValue(false)
       .setMode(ControlP5.SWITCH)
       ;
       
}

void breathing()
{
    breathingAnimation = new Tween(this, 2, Tween.SECONDS, Shaper.COSINE, Tween.REVERSE_REPEAT);
    breathingAnimation.start();
}

void draw()
{  
    //clear background
    background(210);
    
    println( "time: " + breathingAnimation.time() + " position: " + breathingAnimation.position() );    
    
    //draw the logo
    pushMatrix();
      translate(width/2, height/2);
      rotateX(radians(cp5.getController("rotationX").getValue()));
      rotateY(radians(cp5.getController("rotationY").getValue()));
      rotateZ(radians(cp5.getController("rotationZ").getValue()));
      
      drawOrigin();
      
      if(((Toggle)cp5.getController("useMultiply")).getState()) blendMode(MULTIPLY);
      
      drawCenter();      
      drawTriangles();
    popMatrix();
        
}

void drawOrigin()
{
    int w = 10;
    
    if(((Toggle)cp5.getController("drawOrigin")).getState())
    {
      fill(255,0,0);
      rect(-w/2,-w/2,w,w);
    }
}


boolean isBreathing = false;
PVector expVec = new PVector();

void drawTriangles()
{
    int alpha = (int)cp5.getController("cAlpha").getValue();
    float multiplier = 0.0;   
    
    if(((Toggle)cp5.getController("isBreathing")).getState())
    {
        multiplier = map(
          breathingAnimation.position(), 
          0, 
          1, 
          cp5.getController("rangeController").getArrayValue(0), 
          cp5.getController("rangeController").getArrayValue(1)
        );
    }
    else
    {
        multiplier = cp5.getController("expansion").getValue();
    }
    
    expVec = new PVector(multiplier, multiplier, multiplier);
  
    for(int i = 0; i < triangles.length; i++)
    {
        triangles[i].draw(alpha, expVec);
    }
}

void drawCenter()
{
    fill(colors[3]);
    beginShape();
    vertex( center_box[0].x*sm(), center_box[0].y*sm(), center_box[0].z*sm() );
    vertex( center_box[1].x*sm(), center_box[1].y*sm(), center_box[1].z*sm() );
    vertex( center_box[2].x*sm(), center_box[2].y*sm(), center_box[2].z*sm() );
    vertex( center_box[3].x*sm(), center_box[3].y*sm(), center_box[3].z*sm() );
    endShape(CLOSE);
}

//size modifier
float sm()
{
  return cp5.getController("size").getValue();
}

class Triangle
{
    PVector[] startingPoints, modifiedPoints, points;
    PVector crossProduct, crossProductModified = new PVector();    
    int currentColor;
        
    Triangle(PVector[] pts, int c)
    {        
        startingPoints = new PVector[] { pts[0].get(), pts[1].get(), pts[2].get() };   
        modifiedPoints = startingPoints;   
        currentColor = c;
        
        points = pts;
        
        getCrossProduct();
    }
       
    void getCrossProduct()
    {
        PVector side1 = new PVector(), side2 = new PVector();     
        PVector.sub(points[1], points[0], side1);
        PVector.sub(points[2], points[0], side2);
        crossProduct = side1.cross(side2);
        crossProduct.normalize();
    }
    
    void draw(int alpha, PVector expansionVector)
    {
        //update alpha
        currentColor &= 0x00FFFFFF;
        currentColor |= ( (alpha << 24) & 0xFF000000 ); 
        
        //update points expansion
        modifiedPoints = new PVector[] { startingPoints[0].get(), startingPoints[1].get(), startingPoints[2].get() };        
        PVector.mult(crossProduct, expansionVector, crossProductModified);
        modifiedPoints[0].add(crossProductModified);
        modifiedPoints[1].add(crossProductModified);
        modifiedPoints[2].add(crossProductModified);
        
        //draw shape
        fill(currentColor);
        beginShape();      
        vertex( modifiedPoints[0].x*sm(), modifiedPoints[0].y*sm(), modifiedPoints[0].z*sm() );
        vertex( modifiedPoints[1].x*sm(), modifiedPoints[1].y*sm(), modifiedPoints[1].z*sm() );
        vertex( modifiedPoints[2].x*sm(), modifiedPoints[2].y*sm(), modifiedPoints[2].z*sm() );        
        endShape(CLOSE);
    }
}
