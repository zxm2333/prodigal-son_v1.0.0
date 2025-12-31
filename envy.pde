class FireShooter {
  float x, y;
  float width = 40, height = 60;
  boolean facingLeft = true;
  int shootCooldown = 180;
  int shootTimer = 0;
  boolean alive = true;
  int stateTimer = 0;
  String state = "idle";

  PImage idleImg, shootImg, afterShootImg;
  float attackRadius = 800;//atc zone

  FireShooter(float x, float y) {
    this.x = x;
    this.y = y;
    idleImg = loadImage("data/image/envy1.png");
    shootImg = loadImage("data/image/envy2.png");
    afterShootImg = loadImage("data/image/envy3.png");
  }

  void update() {
    if (!alive) return;


    if (player.x < x) {
      facingLeft = true;
    } else {
      facingLeft = false;
    }

    float distanceToPlayer = dist(x, y, player.x, player.y);

    if (distanceToPlayer < attackRadius) {
      shootTimer++;
      if (shootTimer >= shootCooldown) {
        shoot();
        shootTimer = 0;
        state = "shoot";
        stateTimer = 15;
      }
    } else {
      state = "idle";
      shootTimer = 0;
    }

    if (stateTimer > 0) {
      stateTimer--;
      if (stateTimer == 0) {
        state = "after";
      }
    }

    checkCollisionWithPlayer();
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
  }

  void shoot() {
    fireShootSound.trigger();
    float fireballX = x + width / 2;
    float fireballY = y + height / 2;

    float dx = (player.x + player.width/2) - fireballX;
    float dy = (player.y + player.height/2) - fireballY;

    float distance = sqrt(dx * dx + dy * dy); // fancy pythagorean theorem math

    float speed = 5;//fireball speed
    float speedX = (dx / distance) * speed;
    float speedY = (dy / distance) * speed;

    fireballs.add(new Fireball(fireballX, fireballY, speedX, speedY));
  }



  void checkCollisionWithPlayer() {
    if (!alive || player == null) return;

    boolean horizontalOverlap = player.x + player.width > x && player.x < x + width;
    boolean verticalOverlap = player.y + player.height > y && player.y < y + height;

    if (horizontalOverlap && verticalOverlap) {
      float playerPrevBottom = player.y + player.height - player.velY;

      if (playerPrevBottom <= y + 10) {

        player.velY = player.jumpPower * 1;
        alive = false;
        score += 30;
        enemyHitSound.trigger();
      } else {

        if (player.invincibilityFrames <= 0) {
          lives--;
          score=0;
          playerHurtSound.trigger();
          player.invincibilityFrames = 60;

          loadLevel(currentLevel);
        }
      }
    }
  }

  void display() {
    if (!alive) return;

    PImage currentImg = idleImg;
    if (state.equals("shoot")) {
      currentImg = shootImg;
    } else if (state.equals("after")) {
      currentImg = afterShootImg;
    }

    pushMatrix();
    translate(x + width / 2, y + height / 2);
    scale(facingLeft ? -1 : 1, 1);
    imageMode(CENTER);
    image(currentImg, 0, -5, width +10, height);
    popMatrix();
  }
}
