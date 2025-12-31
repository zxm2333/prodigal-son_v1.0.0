class Bouncer {
  float x, y, width = 40, height = 30;
  float velY = 0, gravity = 0.1;
  boolean onGround = false;
  boolean alive = true;
  boolean spawned = false;
  float spawnDistance = 1000;
  PImage idleImg, jumpImg;
  int imageTimer = 0;
  boolean showAltImage = false;


  boolean facingLeft = false;
  float speed = 2;

  Bouncer(float x, float y) {
    this.x = x;
    this.y = y;
    idleImg = loadImage("data/image/lie1.png");
    jumpImg = loadImage("data/image/lie2.png");
  }

  void update() {
    if (!alive) return;

    if (!spawned) {
      float distToPlayer = dist(x, y, player.x, player.y);//calc dist betweeen both
      if (distToPlayer < spawnDistance) {
        spawned = true;
      } else {
        return;
      }
    }

    //grav
    velY += gravity;
    y += velY;

    //simple move to player
    if (player.x < x) {
      x -= speed * 0.5;
      facingLeft = true;
    } else {
      x += speed * 0.5;
      facingLeft = false;
    }

    //ground col copied
    onGround = false;
    for (Platform p : platforms) {
      boolean horizontal = x + width > p.x && x < p.x + p.width;
      boolean vertical = y + height >= p.y && y + height - velY <= p.y;

      if ((p.type.equals("solid") || p.type.equals("grass")) && horizontal && vertical) {
        if (velY > 0){
          bouncerSound.trigger();
          bouncerSound.setGain(-20);
        }
        y = p.y - height;
        velY = -5;
        onGround = true;
      }
    }

    checkCollisionWithPlayer();

    imageTimer++;//cycle image
    if (imageTimer > 30) {
      showAltImage = !showAltImage;
      imageTimer = 0;
    }
    for (Crate crate : crates) {//crate kill copied
      boolean horizontalOverlap = crate.x + crate.width > x && crate.x < x + width;
      boolean verticalOverlap = crate.y + crate.height > y && crate.y < y + height;

      if (horizontalOverlap && verticalOverlap) {
        alive = false;
        score += 15;
        boomSound.trigger();
        enemyHitSound.trigger();
        break;
      }
    }
  }

  void checkCollisionWithPlayer() {//player col copied
  if (!alive || player == null) return;

  boolean horizontalOverlap = player.x + player.width > x && player.x < x + width;
  boolean verticalOverlap = player.y + player.height > y && player.y < y + height;

  if (horizontalOverlap && verticalOverlap) {
    float playerBottom = player.y + player.height;
    float playerPrevBottom = playerBottom - player.velY;

//if player was above bounce kill
    boolean wasAbove = playerPrevBottom <= y + 5;
    boolean isStandingAbove = playerBottom <= y + 10;

    if (wasAbove || isStandingAbove) {
      player.velY = player.jumpPower * 2;
      alive = false;
      score += 25;
      enemyHitSound.trigger();
    } else {
      if (player.invincibilityFrames <= 0) {
        lives--;
        score=0;
        playerHurtSound.trigger();
        player.invincibilityFrames = 60;
        loadLevel();
      }
    }
  }
}




  void display() {
    if (!alive) return;

    PImage currentImg = showAltImage ? jumpImg : idleImg;


    pushMatrix();
    translate(x + width / 2, y + height / 2);
    scale(facingLeft ? -1 : 1, 1);  //flippy
    imageMode(CENTER);
    image(currentImg, 0, 0, width +15, height +25);
    popMatrix();
    


  }
}
