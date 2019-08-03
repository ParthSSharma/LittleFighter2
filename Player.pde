class Player{
  PImage temp;
  PImage playerMove[][];
  PImage playerAttack[][];
  PImage playerBall[][];
  PImage playerBurned[][];
  PImage playerDead[][];
  PImage playerBeaten[][];
  PImage currentImage;
  
  float currentFrameMove = 0;
  float currentFrameAttack = 0;
  float currentFrameFire = 0;
  float currentFrameBurned = 0;
  float currentFrameBeaten = 0;
  
  float x, y;
  float xDelta, yDelta;
  float health = 100;
  float ki = 100;
  int currentDirection;
  
  boolean gettingBeaten = false;
  boolean inMotion = false;
  boolean attacking = false;
  boolean firing = false;
  boolean burned = false;
  boolean dead = false;
  
  final int RIGHT = 0, LEFT = 1;
  
  Player(float xLoc, float yLoc, int dir){
    x = xLoc;
    y = yLoc;
    currentDirection = dir;
    
    temp = loadImage("firenMove.png");
    playerMove = new PImage[2][5];
    for(int i = 0; i < 2; i++){
      playerMove[i][0] = temp.get(0, 67 * i, 37, 67);
      playerMove[i][1] = temp.get(38, 67 * i, 38, 67);
      playerMove[i][2] = temp.get(76, 67 * i, 38, 67);
      playerMove[i][3] = temp.get(114, 67 * i, 39, 67);
      playerMove[i][4] = temp.get(153, 67 * i, 42, 67);
    }
    
    temp = loadImage("firenAttack.png");
    playerAttack = new PImage[2][4];
    for(int i = 0; i < 2; i++){
      playerAttack[i][0] = temp.get(0, 66 * i, 39, 65);
      playerAttack[i][1] = temp.get(40, 66 * i, 43, 65);
      playerAttack[i][2] = temp.get(84, 66 * i, 41, 65);
      playerAttack[i][3] = temp.get(127, 66 * i, 41, 65);
    }
    
    temp = loadImage("firenFire.png");
    playerBall = new PImage[2][5];
    for(int i = 0; i < 2; i++){
      playerBall[i][0] = temp.get(1, 66 * i, 47, 65);
      playerBall[i][1] = temp.get(50, 66 * i, 53, 65);
      playerBall[i][2] = temp.get(104, 66 * i, 68, 65);
      playerBall[i][3] = temp.get(174, 66 * i, 63, 65);
      playerBall[i][4] = temp.get(239, 66 * i, 42, 65);
    }
    
    temp = loadImage("firenBurned.png");
    playerBurned = new PImage[2][4];
    for(int i = 0; i < 2; i++){
      playerBurned[i][0] = temp.get(0, 56 * i, 70, 55);
      playerBurned[i][1] = temp.get(71, 56 * i, 70, 55);
      playerBurned[i][2] = temp.get(143, 56 * i, 66, 55);
      playerBurned[i][3] = temp.get(210, 56 * i, 70, 55);
    }
    
    temp = loadImage("firenDead.png");
    playerDead = new PImage[2][1];
    for(int i = 0; i < 2; i++){
      playerDead[i][0] = temp.get(0, 28 * i, 72, 27);
    }
    
    temp = loadImage("firenBeaten.png");
    playerBeaten = new PImage[2][4];
    for(int i = 0; i < 2; i++){
      playerBeaten[i][0] = temp.get(0, 64 * i, 48, 61);
      playerBeaten[i][1] = temp.get(49, 64 * i, 57, 61);
      playerBeaten[i][2] = temp.get(107, 64 * i, 67, 61);
      playerBeaten[i][3] = temp.get(175, 64 * i, 54, 61);
    }
    
    currentImage = playerMove[0][0];
  }
  
  void showPlayer(){
    drawHealthAndKi();
    if(attacking){
      currentFrameAttack = (currentFrameAttack + 0.2) % 4;
      currentImage = playerAttack[currentDirection][(int) currentFrameAttack];
      image(currentImage, x, y + 2);
      
      if(currentFrameAttack > 3.8){
        attacking = false;
      }
      
      if(currentDirection == 1){
        x -= 0.2;
        if(isPlayerOffScreen()){
          x = 0;
        }
      }
      else{
        x += 0.2;
        if(isPlayerOffScreen()){
          x = width - playerAttack[0][0].width;
        }
      }
    }
    
    else if(gettingBeaten){
      health -= 0.2;
      currentFrameBeaten = (currentFrameBeaten + 0.1) % 4;
      
      if(currentDirection == 1){
        x += 1;
        if(isPlayerOffScreen()){
          x = width - playerBeaten[0][0].width;
        }
      }
      else{
        x -= 1;
        if(isPlayerOffScreen()){
          x = 0;
        }
      }
      
      currentImage = playerBeaten[currentDirection][(int) currentFrameBeaten];
      image(currentImage, x - 15, y + 10 * ((int) (currentFrameBeaten % 3)));
      if(currentFrameBeaten > 3.8){
        gettingBeaten = false;
        if(currentDirection == 1){
          x += 30;
          if(isPlayerOffScreen()){
            x = width - playerBeaten[0][0].width;
          }
        }
        else{
          x -= 30;
          if(isPlayerOffScreen()){
            x = 0;
          }
        }
      }
    }
    
    else if(burned){
      currentFrameBurned = (currentFrameBurned + 0.1) % 4;
      
      if(currentDirection == 1){
        x += 1;
        if(isPlayerOffScreen()){
          x = width - playerBurned[0][0].width;
        }
      }
      else{
        x -= 1;
        if(isPlayerOffScreen()){
          x = 0;
        }
      }
      
      currentImage = playerBurned[currentDirection][(int) currentFrameBurned];
      image(currentImage, x - 15, y + 10 * ((int) (currentFrameBurned % 3)));
      if(currentFrameBurned > 3.8){
        burned = false;
      }
    }
    
    else if(firing){
      currentFrameFire = (currentFrameFire + 0.2) % 5;
      currentImage = playerBall[currentDirection][(int) currentFrameFire];
      image(currentImage, x, y + 2);
      
      if(currentFrameFire > 4.8){
        firing = false;
      }
    }
    
    else{
      currentFrameMove = (currentFrameMove + 0.2) % 5;
      if(inMotion){
        currentImage = playerMove[currentDirection][(int) currentFrameMove];
      }
      else{
        currentImage = playerMove[currentDirection][0];
      }
      image(currentImage, x, y);
    }
  }
  
  void movePlayer(float xDelta, float yDelta){
    inMotion = true;
    if(xDelta == 0 && yDelta == 0){
      inMotion = false;
    }
    else if(xDelta < 0){
      currentDirection = LEFT;
    }
    else if(xDelta > 0){
      currentDirection = RIGHT;
    }
    
    x += xDelta;
    y += yDelta;
    
    if(isPlayerOffScreen()){
      x -= xDelta;
      y -= yDelta;
    }
  }
  
  boolean isPlayerOffScreen(){
    if((x < 0) || (x + 38 > width) || (y < 100) || (y + 85 > height)){
      return true;
    }
    return false;
  }
  
  void updatePlayer(){
    ki += 0.1;
    health += 0.01;
    
    if(ki > 100){
      ki = 100;
    }
    if(health > 100){
      health = 100;
    }
  }
  
  void playerDeath(){
    drawHealthAndKi();
    currentImage = playerDead[currentDirection][0];
    image(currentImage, x - 20, y + 45);
  }
  
  void drawHealthAndKi(){
    if(ki < 0){
      ki = 0;
    }
    if(health < 0){
      dead = true;
      health = 0;
    }
    
    noFill();
    stroke(0);
    strokeWeight(1);
    rect(x, y - 21, playerMove[0][0].width, 6);
    fill(255, 0, 0);
    noStroke();
    rect(x + 1, y - 20, map(health, 0, 100, 0, playerMove[0][0].width), 5);
    
    noFill();
    stroke(0);
    strokeWeight(1);
    rect(x, y - 13, playerMove[0][0].width, 6);
    fill(0, 0, 255);
    noStroke();
    rect(x + 1, y - 12, map(ki, 0, 100, 0, playerMove[0][0].width), 5);
  }
}
