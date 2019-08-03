PImage backImage;
ArrayList<PImage> flames = new ArrayList<PImage>();
ArrayList<Ball> balls = new ArrayList<Ball>();

boolean keys[];
boolean fireKeyPress1 = false;
boolean fireKeyPress2 = false;

int flameCount = 0;
int frameForFlame = 0;
int flameSpeedInv = 2;
float firenBallSpeed = 7;

Player player1;
Player player2;

void setup(){
  size(794, 398);
  frameRate(60);
  
  player1 = new Player(150, height / 2, 0);
  player2 = new Player(width - 200, height / 2, 1);
  
  backImage = loadImage("background.png");
  String flameName;
  for(int i = 1; i < 14; i++){
    flameName = "f";
    flameName += str(i);
    flameName += ".bmp";
    flames.add(loadImage(flameName));
  }
  
  keys = new boolean[128];
}

void draw(){
  background(backImage);
  drawFlames();
  
  if((player1.dead || player2.dead) && (!player1.firing && !player2.firing) && (!player1.burned && !player2.burned) && (!player1.gettingBeaten && !player2.gettingBeaten)){
    drawShadow();
    if(player1.dead){
      player1.playerDeath();
      player2.showPlayer();
    }
    else{
      player2.playerDeath();
      player1.showPlayer();
    }
    
    textSize(32);
    fill(0);
    if(player1.dead){
      text("PLAYER 2 WINS! PLAYER 1 IS A SCRUB", 130, 200);
    }
    else{
      text("PLAYER 1 WINS! PLAYER 2 IS A SCRUB", 130, 200);
    }
    textSize(16);
    text("(Press 'r' to restart!)", 330, 230);
    if(keys['r']){
      reset();
    }
  }
  else{
    move();
    drawShadow();
    drawBalls();
    checkBallHit();
    checkBallCollision();
    checkBeating();
  }
}

void drawFlames(){
  image(flames.get(flameCount), 28, 0);
  image(flames.get(flameCount), 351, 0);
  image(flames.get(flameCount), 675, 0);
  
  if(frameForFlame == flameSpeedInv){
    flameCount++;
    frameForFlame = 0;
  }
  
  if(flameCount > flames.size() - 1){
    flameCount = 0;
  }
  
  frameForFlame++;
}

void keyPressed(){
  try{
    keys[key] = true;
  }
  catch(Exception e){
  }
}

void keyReleased(){
  try{
    keys[key] = false;
  }
  catch(Exception e){
  }
}

void move(){
  player1.xDelta = 0;
  player1.yDelta = 0;
  player2.xDelta = 0;
  player2.yDelta = 0;
  
  if(!player1.burned && !player1.gettingBeaten){
    if(keys['a']){
      player1.xDelta -= 3;
    }
    if(keys['d']){
      player1.xDelta += 3;
    }
    if(keys['w']){
      player1.yDelta -= 1.5;
    }
    if(keys['s']){
      player1.yDelta += 1.5;
    }
    if(keys[' ']){
      player1.xDelta = 0;
      player1.yDelta = 0;
      player1.attacking = true;
    }
    if(keys['f']){
      if(!fireKeyPress1 && (player1.ki > 39)){
        player1.xDelta = 0;
        player1.yDelta = 0;
        player1.attacking = false;
        player1.firing = true;
        if(player1.currentDirection == 1){
          balls.add(new Ball(player1.currentDirection, firenBallSpeed, player1.x - player1.playerMove[0][0].width, player1.y + player1.playerMove[0][0].height / 4, 1));
        }
        else{
          balls.add(new Ball(player1.currentDirection, firenBallSpeed, player1.x + player1.playerMove[0][0].width / 4, player1.y + player1.playerMove[0][0].height / 4, 1));
        }
        fireKeyPress1 = true;
        player1.ki -= 40;
      }
    }
    player1.movePlayer(player1.xDelta, player1.yDelta);
  }
  if(!keys['f']){
    fireKeyPress1 = false;
  }
  
  if(!player2.burned && !player2.gettingBeaten){
    if(keys['4']){
      player2.xDelta -= 3;
    }
    if(keys['6']){
      player2.xDelta += 3;
    }
    if(keys['8']){
      player2.yDelta -= 1.5;
    }
    if(keys['5']){
      player2.yDelta += 1.5;
    }
    if(keys['2']){
      player2.xDelta = 0;
      player2.yDelta = 0;
      player2.attacking = true;
    }
    if(keys['9']){
      if(!fireKeyPress2 && (player2.ki > 39)){
        player2.xDelta = 0;
        player2.yDelta = 0;
        player2.attacking = false;
        player2.firing = true;
        if(player2.currentDirection == 1){
          balls.add(new Ball(player2.currentDirection, firenBallSpeed, player2.x - player2.playerMove[0][0].width, player2.y + player2.playerMove[0][0].height / 4, 2));
        }
        else{
          balls.add(new Ball(player2.currentDirection, firenBallSpeed, player2.x + player1.playerMove[0][0].width / 4, player2.y + player2.playerMove[0][0].height / 4, 2));
        }
        fireKeyPress2 = true;
        player2.ki -= 40;
      }
    }
    player2.movePlayer(player2.xDelta, player2.yDelta);
  }
  if(!keys['9']){
    fireKeyPress2 = false;
  }
  
  player1.updatePlayer();
  player2.updatePlayer();
}

void drawShadow(){
  noStroke();
  fill(12);
  ellipse((player1.playerMove[0][0].width / 2 + player1.x + 2), (player1.playerMove[0][0].height + player1.y + 2), player1.currentImage.width, 5);
  ellipse((player2.playerMove[0][0].width / 2 + player2.x + 2), (player2.playerMove[0][0].height + player2.y + 2), player2.currentImage.width, 5);
}

void drawBalls(){
  if(player2.y > player1.y){
    for(int i = 0; i < balls.size(); i++){
      balls.get(i).move();
      if(player1.y + player1.playerMove[0][0].height / 4 < balls.get(i).y){
        player1.showPlayer();
        balls.get(i).show();
      }
      else{
        balls.get(i).show();
        player1.showPlayer();
      }
      if(i > 0){
        if(player1.attacking){
          if(player1.currentFrameAttack >= 0.2){
            player1.currentFrameAttack -= 0.2;
          }
        }
        else if(player1.firing){
          if(player1.currentFrameFire >= 0.2){
            player1.currentFrameFire -= 0.2;
          }
        }
        else{
          if(player1.currentFrameMove >= 0.2){
            player1.currentFrameMove -= 0.2;
          }
        }
      }
      
      if(player2.y + player2.playerMove[0][0].height / 4 < balls.get(i).y){
        player2.showPlayer();
        balls.get(i).show();
      }
      else{
        balls.get(i).show();
        player2.showPlayer();
      }
      if(i > 0){
        if(player2.attacking){
          if(player2.currentFrameAttack >= 0.2){
            player2.currentFrameAttack -= 0.2;
          }
        }
        else if(player2.firing){
          if(player2.currentFrameFire >= 0.2){
            player2.currentFrameFire -= 0.2;
          }
        }
        else{
          if(player2.currentFrameMove >= 0.2){
            player2.currentFrameMove -= 0.2;
          }
        }
      }
    }
    
    if(!(balls.size() > 0)){
      player1.showPlayer();
      player2.showPlayer();
    }
    
    for(int i = 0; i < balls.size(); i++){
      if(balls.get(i).x + balls.get(i).ballMove[0][0].width < 0 || balls.get(i).x > width){
        balls.remove(i);
      }
    }
  }
  
  else{
    for(int i = 0; i < balls.size(); i++){
      balls.get(i).move();
      if(player2.y + player2.playerMove[0][0].height / 4 < balls.get(i).y){
        player2.showPlayer();
        balls.get(i).show();
      }
      else{
        balls.get(i).show();
        player2.showPlayer();
      }
      if(i > 0){
        if(player2.attacking){
          if(player2.currentFrameAttack >= 0.2){
            player2.currentFrameAttack -= 0.2;
          }
        }
        else if(player2.firing){
          if(player2.currentFrameFire >= 0.2){
            player2.currentFrameFire -= 0.2;
          }
        }
        else{
          if(player2.currentFrameMove >= 0.2){
            player2.currentFrameMove -= 0.2;
          }
        }
      }
      
      if(player1.y + player1.playerMove[0][0].height / 4 < balls.get(i).y){
        player1.showPlayer();
        balls.get(i).show();
      }
      else{
        balls.get(i).show();
        player1.showPlayer();
      }
      if(i > 0){
        if(player1.attacking){
          if(player1.currentFrameAttack >= 0.2){
            player1.currentFrameAttack -= 0.2;
          }
        }
        else if(player1.firing){
          if(player1.currentFrameFire >= 0.2){
            player1.currentFrameFire -= 0.2;
          }
        }
        else{
          if(player1.currentFrameMove >= 0.2){
            player1.currentFrameMove -= 0.2;
          }
        }
      }
    }
    
    if(!(balls.size() > 0)){
      player2.showPlayer();
      player1.showPlayer();
    }
    
    for(int i = 0; i < balls.size(); i++){
      if(balls.get(i).x + balls.get(i).ballMove[0][0].width < 0 || balls.get(i).x > width){
        balls.remove(i);
      }
    }
  }
}

void checkBallHit(){
  for(int i = 0; i < balls.size(); i++){
    if(balls.get(i).owner == 1){
      if(player2.attacking){
        if(player2.currentDirection != balls.get(i).currentDirection){
          if(balls.get(i).hitPlayer(player2.x, player2.y, player2.playerMove[0][0].width, player2.playerMove[0][0].height)){
            balls.get(i).owner = 2;
            balls.get(i).currentDirection = (balls.get(i).currentDirection + 1) % 2;
          }
        }
      }
      else{
        if(balls.get(i).hitPlayer(player2.x, player2.y, player2.playerMove[0][0].width, player2.playerMove[0][0].height)){
          if(!balls.get(i).explosion){
            player2.currentDirection = (balls.get(i).currentDirection + 1) % 2;
            player2.currentFrameBurned = 0;
            player2.burned = true;
            balls.get(i).explosion = true;
            player2.health -= 30;
          }
        }
      }
    }
    else{
      if(player1.attacking){
        if(player1.currentDirection != balls.get(i).currentDirection){
          if(balls.get(i).hitPlayer(player1.x, player1.y, player1.playerMove[0][0].width, player1.playerMove[0][0].height)){
            balls.get(i).owner = 1;
            balls.get(i).currentDirection = (balls.get(i).currentDirection + 1) % 2;
          }
        }
      }
      else{
        if(balls.get(i).hitPlayer(player1.x, player1.y, player1.playerMove[0][0].width, player1.playerMove[0][0].height)){
          if(!balls.get(i).explosion){
            player1.currentDirection = (balls.get(i).currentDirection + 1) % 2;
            player1.currentFrameBurned = 0;
            player1.burned = true;
            balls.get(i).explosion = true;
            player1.health -= 30;
          }
        }
      }
    }
    
    if(!balls.get(i).exist){
      balls.remove(i);
      i--;
    }
  }
}

void checkBallCollision(){
  for(int i = 0; i < balls.size(); i++){
    for(int j = 0; j < balls.size(); j++){
      if(i != j){
        if(balls.get(i).currentDirection != balls.get(j).currentDirection){
          if(!balls.get(i).explosion && !balls.get(j).explosion){
            if(balls.get(i).ballsCollide(balls.get(j).x, balls.get(j).y, balls.get(j).ballMove[0][0].width, balls.get(j).ballMove[0][0].height)){
              balls.get(i).explosion = true;
              balls.get(j).explosion = true;
            }
          }
        }
      }
    }
  }
}

void checkBeating(){
  if(player1.attacking){
    if(player1.currentDirection == 0){
      if((player1.x + player1.currentImage.width > player2.x) && (player1.x + player1.currentImage.width / 2 < player2.x + player2.currentImage.width) && (player1.y + player1.currentImage.height > player2.y + 60) && (player1.y < player2.y + player2.currentImage.height - 60)){
        player2.currentDirection = (player1.currentDirection + 1) % 2;
        player2.gettingBeaten = true;
        player2.currentFrameBeaten = 0;
      }
    }
    else{
      if((player1.x + player1.currentImage.width / 2 > player2.x) && (player1.x < player2.x + player2.currentImage.width) && (player1.y + player1.currentImage.height > player2.y + 60) && (player1.y < player2.y + player2.currentImage.height - 60)){
        player2.currentDirection = (player1.currentDirection + 1) % 2;
        player2.gettingBeaten = true;
        player2.currentFrameBeaten = 0;
      }
    }
  }
  
  if(player2.attacking){
    if(player2.currentDirection == 0){
      if((player2.x + player2.currentImage.width > player1.x) && (player2.x + player2.currentImage.width / 2 < player1.x + player1.currentImage.width) && (player2.y + player2.currentImage.height > player1.y + 60) && (player2.y < player1.y + player1.currentImage.height - 60)){
        player1.currentDirection = (player2.currentDirection + 1) % 2;
        player1.gettingBeaten = true;
        player1.currentFrameBeaten = 0;
      }
    }
    else{
      if((player2.x + player2.currentImage.width / 2 > player1.x) && (player2.x < player1.x + player1.currentImage.width) && (player2.y + player2.currentImage.height > player1.y + 60) && (player2.y < player1.y + player1.currentImage.height - 60)){
        player1.currentDirection = (player2.currentDirection + 1) % 2;
        player1.gettingBeaten = true;
        player1.currentFrameBeaten = 0;
      }
    }
  }
}

void reset(){
  player1 = new Player(150, height / 2, 0);
  player2 = new Player(width - 200, height / 2, 1);
  balls = new ArrayList<Ball>();
  flameCount = 0;
  frameForFlame = 0;
}
