float x, y, velX;
class Greed {
  PImage[] walkFrames = new PImage[2];
  int currentFrame = 0;
  int frameTimer = 0;
  int frameDelay = 10;


  boolean facingLeft = false; //right
  float x, y, width = 25, height = 60;
  float speed = 1.5;
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


  Greed(float startX, float startY) {
    x = startX;
    y = startY;

    walkFrames[0] = loadImage("data/image/greed1.png");
    walkFrames[1] = loadImage("data/image/greed2.png");
  }

  void update() {
    if (!alive) return;
    if (!spawned) {
      float distanceToPlayer = dist(x, y, player.x, player.y);
      if (distanceToPlayer < spawnDistance) {
        spawned = true;
      } else {
        return;
      }
    }




    frameTimer++;
    if (frameTimer > frameDelay) {
      currentFrame = (currentFrame + 1) % walkFrames.length;//cycle dont go out wrap to 0
      frameTimer = 0;
    }


    for (Platform p : platforms) {//plat col
      if (!p.type.equals("solid")) continue;

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







    //x += speed * direction;

    if (player.x < x) {//follow player
      x -= speed * 0.5;
      facingLeft = true;
    } else if (player.x > x) {
      x += speed * 0.5;
      facingLeft = false;
    }





    // playerr plat col
    for (Platform p : platforms) {
      boolean verticallyAligned = y + height >= p.y && y + height - velY <= p.y;
      boolean horizontallyAligned = x + width > p.x && x < p.x + p.width;

      if (verticallyAligned && horizontallyAligned) {
        y = p.y - height;
        velY = 0;
        onGround = true;
      }
    }
    // boing
    for (Platform p : platforms) {
      if (!p.type.equals("jumppad")) continue;

      boolean horizontallyAligned = x + width > p.x && x < p.x + p.width;
      boolean onTop = y + height >= p.y && y + height - velY <= p.y;

      if (horizontallyAligned && onTop) {
        y = p.y - height;
        velY = -15;
        onGround = false;
      }
    }


    //fall off
    if (y + height >= 1000) {
      alive=false;
    }
    // crate hit
    for (Crate crate : crates) {
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

    checkCollisionWithPlayer();
  }


  void checkCollisionWithPlayer() {


    boolean horizontalOverlap = player.x + player.width > x && player.x < x + width;
    boolean verticalOverlap = player.y + player.height > y && player.y < y + height;




    if (horizontalOverlap && verticalOverlap) {


      float playerPrevBottom = player.y + player.height - player.velY;



      //jump on top
      if (playerPrevBottom <= y) {
        player.velY = player.jumpPower * 1;
        alive = false;
        score+=15;
        enemyHitSound.trigger();
      } else {
        if (player.invincibilityFrames <= 0) {
          player.invincibilityFrames = 60;
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

    PImage currentImg = walkFrames[currentFrame];

    pushMatrix();
    translate(x + width / 2, y + height / 2);
    scale(facingLeft ? 1 : -1, 1);//flip
    imageMode(CENTER);
    image(currentImg, 0, 0, width +15, height+15);
    popMatrix();

  }
}
