class Player {
  float x, y;
  float width, height;
  float velX, velY;
  float speed;
  float gravity;
  float jumpPower;
  boolean onGround;
  boolean leftPressed = false;
  boolean rightPressed = false;



  Crate heldCrate = null;//old



  float coyoteTime = 0.5;
  float coyoteTimer = 0;

  float jumpBufferTime = 0.5;
  float jumpBufferTimer = 0;

  boolean jumpHeld = false;
  float jumpHoldTime = 0.3;
  float jumpHoldTimer = 0;


  PImage idleImg, jumpImg;
  PImage jumpUpImg, jumpDownImg;
  PImage runRight1, runRight2;
  PImage runLeft1, runLeft2;
  PImage[] runFrames = new PImage[4];

  int runFrame = 0;
  int runFrameTimer = 0;
  int runFrameDelay = 9;
  boolean facingLeft = false;

  float spawnX, spawnY;
  int invincibilityFrames = 0;



  Player(float startX, float startY) {
    x = startX;
    y = startY;
    spawnX = startX;
    spawnY = startY;
    width = 38;
    height = 45;
    velX = 0;
    velY = 0;
    speed = 5.5;
    gravity = 0.6;
    jumpPower = -13.23 ;
    onGround = false;
    

    idleImg = loadImage("data/image/idle.png");

    for (int i = 0; i < 4; i++) {
      runFrames[i] = loadImage("data/image/run" + (i+1) + ".png");
    }//get all run img
    jumpUpImg = loadImage("data/image/jump1.png");
    jumpDownImg = loadImage("data/image/jump2.png");
  }


  void update() {
    onGround = false;



//simple facing

    if (velX > 0) {
      facingLeft = false;
    } else if (velX < 0) {
      facingLeft = true;
    }




    //grav
    velY += gravity;
    y = max(0, y);
    for (Crate crate : crates) {
      boolean horizontalOverlap = x + width > crate.x && x < crate.x + crate.width;

      if (horizontalOverlap) {
        if (y + height >= crate.y && y + height - velY <= crate.y) {
          y = crate.y - height;
          velY = 0;
          onGround = true;
          coyoteTimer = coyoteTime;
        }
      }
    }

    y += velY;

    if (jumpHeld && jumpHoldTimer > 0 && velY < 0) {//extra jump for hold
      velY += -0.22;
      jumpHoldTimer -= 1 / frameRate;
    }

    //vert col
    for (Platform p : platforms) {
      boolean horizontalOverlap = x + width > p.x && x < p.x + p.width;

      if (!horizontalOverlap) continue;

      if (p.type.equals("platform")) {
        if (y + height >= p.y && y + height - velY <= p.y) {
          y = p.y - height;
          velY = 0;
          onGround = true;
          coyoteTimer = coyoteTime;
        }
      } else if (p.type.equals("solid") || p.type.equals("grass")) {
        if (y + height >= p.y && y + height - velY <= p.y) {
          //top
          y = p.y - height;
          velY = 0;
          onGround = true;
          coyoteTimer = coyoteTime;
        } else if (y <= p.y + p.height && y - velY >= p.y + p.height) {
          //bottom
          y = p.y + p.height;
          velY = 0;
        }
      }
      if (p.type.equals("jumppad")) {
        if (y + height >= p.y && y + height - velY <= p.y) {
          y = p.y - height;
          velY = -24; 
          velX = (player.facingLeft) ? -10 : 10;
          boingSound.trigger();
          onGround = false;
        }
      }
    }

//wall clip
    x += velX;
    x = max(0, x);
    x = min(x, levelWidth - width);
    //map out of bounds
    
    






    //hor col
    for (Platform p : platforms) {
      boolean verticalOverlap = y + height > p.y && y < p.y + p.height;

      if (!verticalOverlap) continue;

      if (p.type.equals("solid") || p.type.equals("grass")) {
        if (x + width > p.x && x < p.x && velX > 0) {
          //left
          x = p.x - width;
        } else if (x < p.x + p.width && x + width > p.x + p.width && velX < 0) {
          //right
          x = p.x + p.width;
        }
      }
    }
    for (Crate crate : crates) {
      boolean verticalOverlap = y + height > crate.y && y < crate.y + crate.height;
      
      if (verticalOverlap) {
        if (x + width > crate.x && x < crate.x && velX > 0) {
          x = crate.x - width;
        } else if (x < crate.x + crate.width && x + width > crate.x + crate.width && velX < 0) {
          x = crate.x + crate.width;
        }
      }
    }


    // map fall off
    if (y > 1000) {
      lives--;
      score=0;
      playerHurtSound.trigger();
      println("noob: " + lives);//haha
      loadLevel(currentLevel);

      return;
    }



    // timers
    if (coyoteTimer > 0) {
      coyoteTimer -= 1 / frameRate;
    }
    if (jumpBufferTimer > 0) {
      jumpBufferTimer -= 1 / frameRate;
    }

    if (invincibilityFrames > 0) {
      invincibilityFrames--;
    }
  }

  void checkBufferedJump() {//old
    if (jumpBufferTimer > 0 && coyoteTimer > 0) {
      velY = jumpPower;
      onGround = false;
      jumpBufferTimer = 0;
      coyoteTimer = 0;
    }
  }

  void display() {
    PImage currentImg = idleImg;


//on groundimg check
    if (!onGround) {
      if (velY < 0) {
        currentImg = jumpUpImg;
      } else {
        currentImg = jumpDownImg;
      }
    }


    // run
    else if (velX != 0) {
      runFrameTimer++;
      if (runFrameTimer > runFrameDelay) {
        runFrame = (runFrame + 1) % runFrames.length;
        runFrameTimer = 0;
      }
      currentImg = runFrames[runFrame];
    }

    pushMatrix();
    translate(x + width / 2, y + height / 2);
    scale(facingLeft ? -1 : 1, 1);//flip
    imageMode(CENTER);
    image(currentImg, -2, -2);
    popMatrix();


  }
}
