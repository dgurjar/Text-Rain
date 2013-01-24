// Text Rain
// Dev Gurjar (dgurjar)
// Project 1 Part B


//TODO:
//- Make rain properly collide with body
//- Make rain realistic
//- Add lightning
//- Add wind
//- Is there a better way to generate random ints in processing?

import processing.video.*;
Capture video;

///////////////////////////////////////////////////////////////////////////////

//The threshold we are using to bound the person
int threshold = 127;
int numPixels;

//The max number of letters allowed in the text
int maxLetters = 20;

//The max number of droplets a bucket can emit
//Catch too much water, it will stop raining!
int maxDropletsPerBucket = 20;

//TODO: Right now this is static, would be cool if it could be changed dynamically
//The text we are displaying
String text = "Hello World!";

//The number of droplets that are available at any given time
Droplet[][] rain = new Droplet[maxLetters][maxDropletsPerBucket];

//Base droplet properties, position and its derivatives
int base_x, base_y;
int base_x_v = 0;
int base_y_v = (int)random(2);
int base_x_a = 0;
int base_y_a = (int)random(2) + 1;
int base_size = 20;


///////////////////////////////////////////////////////////////////////////////

void setup(){
    size(640, 480, P2D);

    //Handles the video capture
    video = new Capture(this, width, height);
    video.start();
    numPixels = video.width * video.height;

    //Set globals dependant on video size
    base_x = (int)random(video.width);
    base_y = (int)random(video.height)/2;

    //The number of pixels allocated for each droplet's starting point
    int bucketInterval = video.width/maxLetters;

    //The number of the leftmost interval where rain starts to fall
    //This is used to center the rain
    //TODO: Think about this when awake, make sure no edge cases
    int leftmostBucket = (text.length() >= maxLetters) ? 0 : (maxLetters/2) - (text.length()/2);

    //Create the droplets
    for(int i = 0; i<text.length(); i++){
        int x = (leftmostBucket+i) * bucketInterval;
        for(int j = 0; j<maxDropletsPerBucket; j++){
            int y = -j*30;
            rain[i][j] = new Droplet(text.charAt(i), x, y, base_x_v, base_y_v, base_x_a, base_y_a, base_size);
        }
    }

    smooth();
}

void draw(){
    if(video.available()) {
        video.read();
        video.loadPixels();
        loadPixels();
        for(int i = 0; i<numPixels; i++){
            pixels[i] = video.pixels[i];
        }
        updatePixels();
        updateRain();
    }
}


void keyPressed(){
    if(key == CODED){
        if(keyCode == UP){
            threshold = min(255, threshold+1);
        }
        else if(keyCode == DOWN){
            threshold = max(0, threshold-1);
        }
    }

}

/* This function draws and controls the rain effect */
void updateRain(){
    for(int i=0; i<rain.length; i++){
        for(int j=0; j<rain[i].length; j++){
            //TODO: Ensure that we don't fall if the droplet is blocked
            if(rain[i][j] != null){
                rain[i][j].fall(video);
                rain[i][j].display();
            }
        }
    }
}

/* Droplets fall from the top of the screen and stop when they reach a certain threshold */
class Droplet{
    //The character we are drawing
    char c;
    //The font size the droplet is being drawn
    int size;
    //The current position, velocity, and acceleration of the drop
    int x, y, x_v, y_v, x_a, y_a;
    //The starting position, velocity, and acceleration of the drop
    int init_x, init_y, init_x_v, init_y_v, init_x_a, init_y_a;
    //The width and height of the
    int width, height;

    //TODO: IF this works well document it
    float collisionThresh = 0.5;

    Droplet(char c, int x, int y, int x_v, int y_v, int x_a, int y_a, int size){
        this.init_x = x;
        this.init_y = y;
        this.init_x_v = x_v;
        this.init_y_v = y_v;
        this.init_x_a = x_a;
        this.init_y_a = y_a;
        this.c = c;
        this.x = x;
        this.y = y;
        this.x_v = x_v;
        this.y_v = y_v;
        this.x_a = x_a;
        this.y_a = y_a;
        this.size = size;
        textSize(size);
        this.width = (int)textWidth(c);
        this.height = size;
    }

    /* Causes the droplet to fall */
    void fall(Capture video){

        //If droplets go offscreen, bring them back to the top
        if(x > video.width || x < 0 || y > video.height || y < 0){
            y = 0;
            y_v = 0;
            x = init_x;
            x_v = init_x_v;
        }

        //If the droplet collides, we want to move it up
        else if(isCollision()){
            while(isCollision()){
                y -= size/4;
                y_v = 0;
                return;
            }
        }

        //Droplet falls normally
        else{
            x += x_v;
            x_v += x_a;
            y += y_v;
            y_v += y_a;
        }
    }

    /* Displays the droplet */
    void display(){
        textSize(size);
        fill(0, 102, 153, 90);
        text(c, x, y);
    }


    /* Simple collision detection using brightness thresholding */
    boolean isCollision(){
        println(video.width);
        if(brightness(video.pixels[video.width*y+x]) <= threshold)
            return true;

        return false;
    }
}
