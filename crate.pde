class Crate {
  float x, y, width = 60, height = 60;
  float velX = 0, velY = 0;
  float gravity = 0.1;
  boolean onGround = false;
  boolean hasRespawned = false;
  boolean launched = false;
  PImage idleImg;


  Crate(float x, float y) {
    this.x = x;
    this.y = y;
    idleImg = loadImage("data/image/box2.png");
  }

  void update() {


    velY += gravity;
    onGround = false;

    //grav
    y += velY;

    if (launched) {
      x += velX;
    }

   
    x += velX;


    for (Platform p : platforms) {//platform col
      if (!p.type.equals("solid") && !p.type.equals("grass")) continue;// skips rest of loop moves to next

      boolean horizontallyAligned = x + width > p.x && x < p.x + p.width;
      boolean fallingOnTop = y + height >= p.y && y + height - velY <= p.y;

      if (horizontallyAligned && fallingOnTop) {// p not solid or grass
        y = p.y - height;
        velY = 0;
        onGround = true;
        if (onGround) {
          launched = false;
          velX = 0;
        }
      }
      if (p.type.equals("jumppad")) {
        if (y + height >= p.y && y + height - velY <= p.y) {//col
          y = p.y - height;
          velY = -15;
          onGround = false;
        }
      }
    }

    boolean isPushingNow = false;//old

    if (player != null && player.onGround) {
      boolean pushing = player.y + player.height > y && player.y < y + height;

      if (pushing) {//push mech

        if (player.velX > 0 && player.x + player.width <= x && player.x + player.width + player.velX > x) {//col
          x += player.velX;
          isPushingNow = true;
        } else if (player.velX < 0 && player.x >= x + width && player.x + player.velX < x + width) {//col
          x += player.velX;
          isPushingNow = true;
        }
      }
    }


    for (Platform p : platforms) {
      if (!p.type.equals("solid") && !p.type.equals("grass")) continue;//copied from up top 

      boolean verticallyAligned = y + height > p.y && y < p.y + p.height;

      if (verticallyAligned) {
        if (x + width > p.x && x < p.x) {
          x = p.x - width -50;//fix wall stuck
          velX = 0;
        } else if (x < p.x + p.width && x + width > p.x + p.width) {
          x = p.x + p.width +50;
          velX = 0;
        }
      }
    }

    for (Platform p : platforms) {
      if (!p.type.equals("jumppad")) continue;

      boolean horizontallyAligned = x + width > p.x && x < p.x + p.width;
      boolean onTop = y + height >= p.y && y + height - velY <= p.y;

      if (horizontallyAligned && onTop) {
        y = p.y - height;
        velY = -12;//boing boing
        boingSound.trigger();
        velX = (player.facingLeft) ? -1.3 : 1.3;//little x boost
        launched = true;
        onGround = false;
      }
    }
  
  }

  void display() {
    PImage currentImg = idleImg;

    pushMatrix();
    translate(x + width / 2, y + height / 2);
    imageMode(CENTER);
    image(currentImg, 0, 0, width, height);
    popMatrix();
  }
}
