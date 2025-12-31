class Boss {
  float x, y;
  float width = 80, height = 80;//change this
  float velX = 0, velY = 0;
  float speed = 3;
  float dashSpeed = 7;
  float gravity = 0.05;//for slow fall
  float jumpPower = -5;



  int health = 300;
  boolean alive = true;
  int phase = 1;

  PImage fire1, fire2;
  boolean showFire2 = false;
  int lastPhase;



  //phase1
  boolean canDash = true;
  boolean isDashing = false;
  float dashTimer = 0;
  float dashCooldown = 1;

  //phase2
  float fireTimer = 0;
  float fireCooldown = 1;
  PImage fireTexture1, fireTexture2;
  boolean showingFire2 = false;
  float fire2Timer = 0;
  float fire2Duration = 0.5;

  //phase3
  float jumpTimer = 0;
  float jumpCooldown = 3;
  boolean onGround = false;
  //falling stuff
  PImage fallingImg, landingImg;
  int hitboxOff = 20;//for smaller hitbox
  boolean isFalling = false;
  boolean showLanding = false;
  boolean playLanding = false;
  float landingTimer = 0;
  float landingDuration = 0.5;
  PImage jumpingImg;

  PImage[] idleFrames = new PImage[2];
  PImage[] attackFrames = new PImage[4];
  int idleFrame = 0;
  int attackFrame = 0;
  float frameTimer = 0;
  float idleFrameDuration = 0.5;
  float attackFrameDuration = 0.2;
  int nextAllowedJump = 0;//broken
  int jumpDelay = 500;//broken
  Boss(float startX, float startY) {
    x = startX;
    y = startY;
    // load phase1 textures
    for (int i = 0; i < idleFrames.length; i++) {
      idleFrames[i] = loadImage("data/boss/boss_idle" + (i+1) + ".png");
    }
    for (int i = 0; i < attackFrames.length; i++) {
      attackFrames[i] = loadImage("data/boss/boss_attack" + (i+1) + ".png");
    }
    // load phase2 textures
    fireTexture1 = loadImage("data/boss/boss_attack_phase1.png");
    fireTexture2 = loadImage("data/boss/boss_attack_phase2.png");
    // load phase3 fall
    fallingImg = loadImage("data/boss/boss_falling.png");
    landingImg = loadImage("data/boss/boss_landing.png");
    jumpingImg = loadImage("data/boss/boss_jumping.png");
    roarSound.trigger();
    lastPhase = 1;
  }

  void update() {
    if (!alive) return;
    int oldPhase = phase;//for yelling sfx
    if (health > 200) phase = 1;
    else if (health > 100) phase = 2;
    else phase = 3;//change phase based on health



    if (phase > oldPhase) {
      laughSound.trigger();
    }
    if (phase == 1) updatePhase1();
    else if (phase == 2) updatePhase2();
    else updatePhase3();

    if (phase == 3) {
      width = 140 - hitboxOff;//for textures
      height = 140;
      gravity = 0.15;
    } else {
      width = 110 - hitboxOff;
      height = 110;
      gravity = 0.05;
    }



    if (phase == 3 && velY > 0) {
      isFalling = true;//for col with plat
    }
    boolean justLanded = false;
    onGround = false;
    ArrayList<Platform> toRemove = new ArrayList<Platform>();//to be able to remove

    velY += gravity;//grav
    y+= velY;


    for (int i = 0; i < platforms.size(); i++) {//new arraylist for the platfroms to remove
      Platform p = platforms.get(i);
      boolean overlapX= x + width > p.x && x < p.x + p.width;
      boolean wasAbove= (y + height - velY) < p.y;//copied from enemy
      boolean nowAtOrBelow = (y + height) >= p.y;
      if (overlapX && wasAbove && nowAtOrBelow) {
        onGround   = true;
        justLanded = true;
        y= p.y - height;
        velY = 0;
        velX=0;


        if (phase == 3 && p.breakable) {
          platforms.remove(i);//plats crushed
          velY=0;
        }
        break;
      }
    }

    platforms.removeAll(toRemove);

    if (!onGround && y + height > 850) {
      onGround   = true;
      justLanded = true;
      y= 850 - height;
      velY= 0;
    }
    if (justLanded && isFalling) {//for anim
      stompSound.trigger();
      shakeTimer= shakeDuration;
      isFalling= false;
      showLanding = true;
      landingTimer = landingDuration;
    }
    if (velY > 0 && !onGround) {//fall logic
      isFalling = true;
    }
    if (phase == 3 && onGround && isFalling) {//falling anim
      showLanding = true;
      landingTimer = landingDuration;
      isFalling = false;
    }
    if (showLanding) {
      landingTimer -= 1.0/frameRate;//anim dur
      if (landingTimer <= 0) showLanding = false;
    }

    x += velX;//x grav

    if (player.invincibilityFrames <= 0 && player.x + player.width > x && player.x < x + width && player.y + player.height > y && player.y < y + height) {//player overlap
      lives--;
      player.invincibilityFrames = 60;//bug fix
      playerHurtSound.trigger();
      loadLevel(currentLevel);
    }

    if (phase == 3 && onGround && isFalling) {
      stompSound.trigger();
      showLanding = true;
      landingTimer = landingDuration;
      isFalling = false;
    }
  }

  void updatePhase1() {//attack phase1
    for (Platform p : platforms) {
      boolean playerOnPlatform = player.y + player.height == p.y && player.x + player.width > p.x && player.x < p.x + p.width;//col from enemy
      boolean bossUnderPlatform = x + width/2 > p.x && x + width/2 < p.x + p.width;//col
      if (playerOnPlatform && bossUnderPlatform && onGround) {//jump if ontop boss
        velY = jumpPower;
        bossJump.trigger();
        return;
      }
    }

    if (canDash) {
      if (abs((y + height) - (player.y + player.height)) < 10) {//make height positive
        if (abs(player.x - x) > 255) {//dist to dash | absolute value |
          velX = (player.x > x) ? speed + 1 : -speed - 1;//boss sped
        } else {
          velX = 0;
          dashTimer += 2.2/frameRate;//time 2 dash
          if (dashTimer >= 1) {
            velX = (player.x > x) ? dashSpeed : -dashSpeed;
            canDash = false;
            isDashing = true;
            dashTimer = 0;

            swordAttack.trigger();
          }
        }
      } else {
        velX = (player.x > x) ? speed : -speed;//dont use
      }
    } else {
      dashTimer += 1.0/frameRate;//how long dash
      if (dashTimer >= dashCooldown) {
        canDash = true;//reset dash cool
        isDashing = false;
        dashTimer = 0;
      }
    }
  }

  void updatePhase2() {//atc phase 2
    if (showingFire2) {//anim
      fire2Timer -= 1.0/frameRate;
      if (fire2Timer <= 0) showingFire2 = false;//match anim to fire cycle
    }

    // movement jump
    velX = (player.x > x)? speed-1 : -speed+1;
    jumpTimer -= 0.3/frameRate;//jump timing
    if (jumpTimer <= 0 && onGround) {
      velY = jumpPower-1;
      bossJump.trigger();
      jumpTimer = jumpCooldown;
    }
    // fireballs
    fireTimer -= 0.45/frameRate;
    if (fireTimer <= 0) {
      for (int i = 0; i < 2; i++) {//for loop
        float a = random(TWO_PI);//random direction youtub tut
        fireballs.add(new Fireball(x+width/2, y+height/2, cos(a)*3, sin(a)*3));//super fancy youtube tut
      }
      float dx = player.x-x, dy = player.y-y;
      float m = sqrt(dx*dx+dy*dy);//math class helped
      fireballs.add(new Fireball(x+width/2, y+height/2, dx/m*5, dy/m*5));//speed and player dist x,y
      showingFire2 = true;//anim
      fire2Timer = fire2Duration;//match cycle
      fireTimer = fireCooldown;
      fireShootSound.trigger();
    }
  }

  void updatePhase3() {//simple jump copied from 2
    velX = (player.x > x) ? speed +0.5   : -speed -0.5;
    jumpTimer -= 0.69/frameRate;
    if (jumpTimer <= 0 && onGround) {
      velY = jumpPower - 8.25;//diff grav
      bossJump.trigger();
      jumpTimer = jumpCooldown;
    }
  }

  void display() {
    if (!alive) return;

    if (phase == 2) {
      PImage img = showingFire2 ? fireTexture2 : fireTexture1;
      imageMode(CENTER);
      image(img, x + width/2, y + height/2, width + hitboxOff, height);
    } else if (phase == 3 || phase == 1) {//jump anim for 3 and 1

      if (velY < 0 && !onGround) {
        imageMode(CENTER);
        image(jumpingImg, x + width/2, y + height/2, width + hitboxOff, height);

        //land
      } else if (showLanding) {
        imageMode(CENTER);
        image(landingImg, x + width/2, y + height/2, width+ hitboxOff, height);
        // countdown landing display
        landingTimer -= 1.0/frameRate;
        if (landingTimer <= 0) showLanding = false;

        //fall
      } else if (velY > 0 && !onGround) {
        imageMode(CENTER);
        image(fallingImg, x + width/2, y + height/2, width+ hitboxOff, height);

        //ground=true
      } else {
        PImage[] frames = isDashing ? attackFrames : idleFrames;
        int curFrame;
        float duration = (frames == idleFrames) ? idleFrameDuration : attackFrameDuration;// if else statement pretty much
        frameTimer += 1.0/frameRate;//cycle match
        if (frameTimer >= duration) {
          if (frames == idleFrames) {
            curFrame = (idleFrame = (idleFrame + 1) % idleFrames.length);// % keeps frame from out of bounds
          } else {
            curFrame = (attackFrame = (attackFrame + 1) % attackFrames.length);//same for attack
          }
          frameTimer = 0;
        } else {
          curFrame = (frames == idleFrames) ? idleFrame : attackFrame;// idle or attack 
        }
        PImage drawImg = frames[curFrame];

        boolean facingLeft = (player.x < x);
        pushMatrix();//same flipping for everything
        if (facingLeft) {
          translate(x + width/3, y + height/2);
          scale(-1, 1);
          imageMode(CENTER);
          image(drawImg, 0, 0, width + 10+ hitboxOff, height + 10);
        } else {
          imageMode(CENTER);
          image(drawImg, x + width - 20, y + height/2, width + 10+ hitboxOff, height + 10);
        }
        popMatrix();
      }
    } else {
//same as uptop
      PImage[] frames = isDashing ? attackFrames : idleFrames;
      int idx;
      float duration = (frames == idleFrames) ? idleFrameDuration : attackFrameDuration;
      frameTimer += 1.0/frameRate;
      if (frameTimer >= duration) {
        if (frames == idleFrames) {
          idx = (idleFrame = (idleFrame + 1) % idleFrames.length);
        } else {
          idx = (attackFrame = (attackFrame + 1) % attackFrames.length);
        }
        frameTimer = 0;
      } else {
        idx = (frames == idleFrames) ? idleFrame : attackFrame;
      }
      PImage drawImg = frames[idx];

      boolean facingLeft = (player.x < x);
      pushMatrix();
      if (facingLeft) {
        translate(x + width/3, y + height/2);
        scale(-1, 1);//flip based on facingLeft
        imageMode(CENTER);
        image(drawImg, 0, 0, width + 10+ hitboxOff, height + 10);
      } else {
        imageMode(CENTER);
        image(drawImg, x + width - 20, y + height/2, width + 10+ hitboxOff, height + 10);
      }
      popMatrix();
    }
  }




  void takeDamage(int dmg) {
    health -= dmg;
    hitMark.trigger();
    if (health <= 0) {
      alive = false;
      tntSound.trigger();


      grassImg       = loadImage("grass2.png");
      platImg        = loadImage("platform.png");//look like lvl 1
      solidImg       = loadImage("box.png");
      backgroundImage = backgroundImages[1];
      levelThreeMusic.pause();
      levelThreeMusic.rewind();
      endMusic.loop();



      gameState    = STATE_BOSS_END;
      fadeAlpha    = 255;//fade from backwards
      fadeDirection= -1;
      fading= true;
    }
  }
}
