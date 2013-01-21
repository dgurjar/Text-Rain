// Text Rain
// Dev Gurjar (dgurjar)
// Project 1 Part B


//TODO:
//1. Let users select a line of text
//2. Droplets will fall based on what the line is
//3. Make rain realistic
//4. Make rain properly collide with body
//5. Add lightning
//6. Add wind
//

import processing.video.*;
Capture video;

//The threshold we are using to bound the person
int threshold = 127;
int numPixels;

//The number of droplets that are available at any given time
Droplet[] rain = new Droplet[20];

void setup(){
    size(640, 480, P2D);

    //Handles the video capture
    video = new Capture(this, width, height);
    video.start();
    numPixels = video.width * video.height;

    //Create the droplets
    for(int i = 0; i<rain.length; i++){
        int x = (int)random(video.width);
        int y = -(int)random(video.width)/2;
        int x_v = 0;
        int y_v = (int)random(10);
        int x_a = 0;
        int y_a = (int)random(3) + 9;
        int size = 16;
        rain[i] = new Droplet('d', x, y, x_v, y_v, x_a, y_a, size);

    smooth();
    }
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

/* This function draws and controls the rain effect */
void updateRain(){
    for(int i=0; i<rain.length; i++){
        //TODO: Ensure that we don't fall if the droplet is blocked
        rain[i].fall();
        rain[i].display();
    }
}

/* Droplets fall from the top of the screen and stop when they reach a certain threshold */
class Droplet{
    //The character we are drawing
    char c;
    //The size the droplet is being drawn
    int size;
    //The current position, velocity, and acceleration of the drop
    int x, y, x_v, y_v, x_a, y_a;

    Droplet(char c, int x, int y, int x_v, int y_v, int x_a, int y_a, int size){
        this.c = c;
        this.x = x;
        this.y = y;
        this.x_v = x_v;
        this.y_v = y_v;
        this.x_a = x_a;
        this.y_a = y_a;
        this.size = size;
    }

    /* Causes the droplet to fall */
    void fall(){
        if(x > video.width){

        }
        else{
          x += x_v;
          x_v += x_a;
        }
        //Mabye add a random element here
        if(y>video.height){
          y = 0;
          y_v = 0;
          x = (int)random(video.width);
          y = -(int)random(video.width)/2;
        }
        else{
          y += y_v;
          y_v += y_a;
        }
    }

    /* Displays the droplet */
    void display(){
        textSize(size);
        textAlign(CENTER);
        text(c, x, y);
    }
}