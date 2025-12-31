 //<>//
class Enemy {
  PImage[] walkFrames = new PImage[2];
  int currentFrame = 0;
  int frameTimer = 0;
  int frameDelay = 10;//10 fps change


  boolean facingLeft = false;//right default
  float patrolLeftLimit;
  float patrolRightLimit;
  float x, y, width = 40, height = 25;
  float speed = 2.5;
  int direction;

  float leftBound, rightBound;
  boolean alive = true;
  int moveCooldown = 0;
  int moveCooldownMax = 90;
  boolean spawned =false;
  float spawnDistance = 1000;


  float velY = 0;
  float gravity = 0.5;
  boolean onGround = false;


  Enemy(float startX, float startY) {
    x = startX;
    y = startY;
    direction = randInt(0, 1) * 2 - 1;
    //leftBound = startX - 150;
    //rightBound = startX + 150;
    walkFrames[0] = loadImage("data/image/mouse.png");
    walkFrames[1] = loadImage("data/image/mouse2.png");

    patrolLeftLimit = startX - 100;
    patrolRightLimit = startX + 100;
  }

  void update() {
    if (!alive) return;
    if (!spawned) {
      float distanceToPlayer = dist(x, y, player.x, player.y);//calc dist between
      if (distanceToPlayer < spawnDistance) {//dont spawn close
        spawned = true;
      } else {
        return;
      }
    }




    frameTimer++;
    if (frameTimer > frameDelay) {
      currentFrame = (currentFrame + 1) % walkFrames.length;
      frameTimer = 0;
    }


    for (Platform p : platforms) {
      if (!p.type.equals("solid")) continue;//skip through if not solid
//col
      boolean verticalOverlap = y + height > p.y && y < p.y + p.height;
      boolean hitLeft = x + width > p.x && x < p.x && direction == 1;
      boolean hitRight = x < p.x + p.width && x + width > p.x + p.width && direction == -1;

      if (verticalOverlap && (hitLeft || hitRight)) {
        direction *= -1;


        if (hitLeft) {
          x = p.x - width;
        } else if (hitRight) {
          x = p.x + p.width;
        }

        break;
      }
    }


  //grav
    velY += gravity;
    y += velY;
    onGround = false;







    x += speed * direction;
    facingLeft = direction == 1;



    //copy from player
    for (Platform p : platforms) {
      boolean verticallyAligned = y + height >= p.y && y + height - velY <= p.y;
      boolean horizontallyAligned = x + width > p.x && x < p.x + p.width;

      if (verticallyAligned && horizontallyAligned) {
        y = p.y - height;
        velY = 0;
        onGround = true;
      }
    }
    //boing boing
    for (Platform p : platforms) {
      if (!p.type.equals("jumppad")) continue;

      boolean horizontallyAligned = x + width > p.x && x < p.x + p.width;
      boolean onTop = y + height >= p.y && y + height - velY <= p.y;

      if (horizontallyAligned && onTop) {
        y = p.y - height;
        boingSound.trigger();
        velY = -15;
        onGround = false;
      }
    }


    //ground
    if (y + height >= 1000) {
      alive=false;
    }
    //crate boom copied
    for (Crate crate : crates) {
      boolean horizontalOverlap = crate.x + crate.width > x && crate.x < x + width;
      boolean verticalOverlap = crate.y + crate.height > y && crate.y < y + height;

      if (horizontalOverlap && verticalOverlap) {
        println("big boom boom");
        alive = false;
        score += 15;
        boomSound.trigger();
        break; //leave after 1 kill
      }
    }

    checkCollisionWithPlayer();
  }


  void checkCollisionWithPlayer() {


    boolean horizontalOverlap = player.x + player.width > x && player.x < x + width;
    boolean verticalOverlap = player.y + player.height > y && player.y < y + height;




    if (horizontalOverlap && verticalOverlap) {


      float playerPrevBottom = player.y + player.height - player.velY;

      println("boom boom");

      //jump top
      if (playerPrevBottom <= y) {
        player.velY = player.jumpPower * 1;
        alive = false;
        score+=15;
        enemyHitSound.trigger();
      } else {
        if (player.invincibilityFrames <= 0) {
          player.invincibilityFrames = 60;//anti
          lives--;
          score=0;
          playerHurtSound.trigger();
          if (lives <= 0) {
            gameState = 2;
          } else {
            player.invincibilityFrames = 60;
            loadLevel(currentLevel);
          }
        }
      }
    }
  }

  void display() {
    if (!alive) return;
    pushMatrix();
    translate(x + walkFrames[currentFrame].width / 2 -3, y +25);

    if (facingLeft) {
      scale(-1, 1); //fluip
    }

    imageMode(CENTER);
    image(walkFrames[currentFrame], 0, 0 -15);
    imageMode(CORNER);
    popMatrix();




    if (!alive) return;
  }
}
