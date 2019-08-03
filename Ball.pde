class Ball{
  float x, y;
  float speed;
  int currentDirection;
  int owner;
  
  float currentFrame = 0;
  float currentExplosionFrame = 0;
  
  PImage temp;
  PImage ballMove[][];
  PImage ballExplode[][];
  
  boolean exist = true;
  boolean explosion = false;
  
  final int RIGHT = 0, LEFT = 1;
  
  Ball(int dir, float s, float posX, float posY, int o){
    temp = loadImage("firenBall.png");
    ballMove = new PImage[2][6];
    for(int i = 0; i < 2; i++){
      ballMove[i][0] = temp.get(0, 36 * i, 76, 35);
      ballMove[i][1] = temp.get(78, 36 * i, 73, 35);
      ballMove[i][2] = temp.get(158, 36 * i, 73, 35);
      ballMove[i][3] = temp.get(236, 36 * i, 74, 35);
      ballMove[i][4] = temp.get(313, 36 * i, 77, 35);
      ballMove[i][5] = temp.get(394, 36 * i, 71, 35);
    }
    
    temp = loadImage("fireBallExplosion.png");
    ballExplode = new PImage[2][4];
    for(int i = 0; i < 2; i++){
      ballExplode[i][0] = temp.get(0, 57 * i, 47, 54);
      ballExplode[i][1] = temp.get(49, 57 * i, 53, 54);
      ballExplode[i][2] = temp.get(104, 57 * i, 43, 54);
      ballExplode[i][3] = temp.get(151, 57 * i, 74, 31);
    }
    
    currentDirection = dir;
    speed = s;
    x = posX;
    y = posY;
    owner = o;
  }
  
  void show(){
    if(explosion){
      currentExplosionFrame = (currentExplosionFrame + 0.1) % 4;
      image(ballExplode[currentDirection][(int) currentExplosionFrame], x + 15, y);
    }
    else{
      currentFrame = (currentFrame + 0.2) % 6;
      image(ballMove[currentDirection][(int) currentFrame], x, y);
    }
    
    if(currentExplosionFrame > 3.8){
      exist = false;
    }
  }
  
  void move(){
    if(explosion){
      speed = 0;
    }
    
    if(currentDirection == 0){
      x += speed;
    }
    else{
      x -= speed;
    }
  }
  
  boolean hitPlayer(float pX, float pY, float pW, float pH){
    if((x + ballMove[0][0].width > pX) && (x < pX + pW) && (y + ballMove[0][0].height > pY + 45) && (y < pY + pH - 45)){
      return true;
    }
    return false;
  }
  
  boolean ballsCollide(float pX, float pY, float pW, float pH){
    if((x + ballMove[0][0].width > pX) && (x < pX + pW) && (y + ballMove[0][0].height > pY + 30) && (y < pY + pH - 30)){
      return true;
    }
    return false;
  }
}
