import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
//Snake Isabel Gaubatz 742048 MIT1 Praxisaufgabe
//Quellen: http://www.creativecoding.org/lesson/topics/audio/sound-in-processing
//forum.processing.org/one/topic/the-snake-game-help.html
int snake=3;//anfagslänge des Snakes
int rectWidth=15;//größe der Snake Quadrate
int rectHeight=15;
int Max = 500;//maximaler Score
int playerX []=new int[Max];//array x location der Quadrate mit dem maximalwert
int playerY []=new int[Max];// y location
int Rect;// variable zum zeichnen/Bewegung der Quadrate
//Food
int ellipseWidth=15;//food größe
int ellipseHeight=15;
int abstand=-30;//abstand zum Rand
int foodx=(round(random(20, width+abstand)));// Bewegung food auf x
int foody=(round(random(20, height+abstand)));// Bewegung food auf y
//Speed
int speedx, speedy; // Bewegung
int speedMin=0;// minimale Bewegung
int speedMax=15;// maximale Bewegung
int frame=10;// framrate
//gameOver
boolean gameOver=false;// Flag ist das Game Verloren 
//start
boolean start=true;//Flag starten des Spiels


Minim jungle=new Minim (this);//Musik
PImage img;//Hintergrund
PImage gameOverimg;//GameOver Bild
PImage startimg;// Start Bild
void setup() {
  size(500, 500);//Fenstergröße
  playerX[0]=width/2;// Begin in the mid of the window
  playerY [0]= height/2;
  rectMode(CENTER);//In der Mitte Ansteuern
  ellipseMode(CENTER);
  speedx=0;// Player begin without moving
  speedy=0;
  img=loadImage("bewegterjungle.gif");//Hintergrund
  gameOverimg=loadImage("kaputte Scheibe.jpg");//GameOver Bild
  startimg=loadImage("schlange.jpg");//Start Bild
  AudioPlayer player=jungle.loadFile("Nature Ambiance-SoundBible.com-1444637890.wav");//Musik
  player.loop();//Musik in Dauerschleife
}

void draw() {

  if (start) { // Bedingung das am anfang der startscreen angezeigt wird
    startScreen();
  }
  if (!gameOver&&!start) {// Wenn nich GameOver und Nicht start Eintritt snakeRuns 
    snakeRuns();
  }
  if (playerX[0]<0||playerX[0]>width||playerY[0]<0||playerY[0]>height) {//Wenn Snake die Wand berühr GameOver
    gameOver();
    gameOver=true;
  }
}

void snakeRuns() {
 
  frameRate(frame);//frameRate
  image(img, 0, 0, width, height);//Hintergrund
  textAlign(RIGHT);//Texteigenschaften
  textSize(width/20);
  fill(255);
  text(snake-3, width-10, height-10);
  fill(random(255), random(0), random(0));
  ellipse(foodx, foody, ellipseWidth, ellipseHeight); //location of the food

  for (int Rect =0; Rect<snake; Rect++) {//Kopf der Schlange 
    fill(random(0),random (255), random(0));
    rect(playerX[Rect], playerY[Rect], rectWidth, rectHeight);
  }

  playerX[0]=playerX[0]+speedx;//Bewegung Kopf 
  playerY[0]=playerY[0]+speedy; 

  for (int Rect = snake; Rect>0; Rect--) {//Hintere Vierecke nehmen Postition des vorherigen ein

    playerX[Rect] = playerX[Rect-1];
    playerY[Rect] = playerY[Rect-1];
  }

  for (int check=3; check<snake; check++) {//trifft die Schlage sich selber
    if (playerX[0]==playerX[check]&&playerY[0]==playerY[check]) {
      gameOver=true;
      gameOver();
    }
  }

  //Food
  if (snake<playerX.length) {
    if (playerX[0]>=foodx-rectWidth && playerX[0]<=foodx+rectWidth && playerY[0]>=foody-rectHeight && playerY[0]<foody+rectHeight) //Snake isst food
    {
      foodx=(round(random(20, width+abstand)));// Bewegung food
      foody=(round(random(20, height+abstand)));
      snake++;//snake zählt pro gegessenem food eins hoch
      frame+=0.9;//die framerate wird pro gegessenem food um 0,9 erhöht
    }
  }
}

void gameOver() {
  image(gameOverimg, 0, 0, width, height);//Bild

  fill(0);
  textAlign(CENTER);//Texteigenschaften
  textSize(width/10);
  PFont myFont;
  myFont= createFont("BREAKIT", 100);
  textFont(myFont);
  text("GameOver", width/2, height/2);
  textSize(width/15);
  fill(random(255), random(255), random(255));
  text("Press r to continue", width/2, height/2+150);
  fill(0);
  text(snake-3, width/2, height/2+100);
  fill(0);
  text("Score", width/2, height/2+50);
  //snake=3;
  //speedx=0;
  //speedy=0;
  gameOver=true;
}
void startScreen() {
  image(startimg, 0, 0, width, height);//Bild
  PFont snake;
  snake=createFont("V5ProphitCell", 100);//texteigenschaften
  textFont(snake);
  textAlign(CENTER);
  textSize(width/5);
  fill(255);
  text("SNAKE", width/2, height/2-150);
  fill(random(255), random(255), random(255));
  textSize(width/15);
  text("Press r to start", width/2, height/2+100);
}
void keyPressed() {
  if (key=='r') {//Neustart
    start=false;
    gameOver=false;
    snakeRuns();
    snake=3;
    playerX[0]=width/2;
    playerY[0]=height/2;
    speedx=0;
    speedy=0;
    frame=10;
  }

  switch (keyCode) {
  case LEFT:
    if (!(speedx==speedMax)&&gameOver==false) {//verhindert, dass man wenn man hoch drückt gleich runterdrücken kann, sodass die Schlange keinen Richtungswechsel durch sich durch machen kann und solange Gameover false ist kann man nur die Tasten drücken

      speedx=-speedMax;// verhindert, dass die rechtecke aufeinander sitzen
      speedy=speedMin;
    }
    break;
  case RIGHT:
    if (!(speedx==-speedMax)&&gameOver==false) {

      speedx=speedMax;
      speedy=speedMin;
    }
    break;
  case DOWN:
    if (!(speedy==-speedMax)&&gameOver==false) {

      speedx=speedMin;
      speedy=speedMax;
    }
    break;

  case UP:
    if (!(speedy==speedMax)&&gameOver==false) {

      speedx=speedMin;
      speedy=-speedMax;
    }
    break;
  default:
    println("wrong spell");
  }
}

