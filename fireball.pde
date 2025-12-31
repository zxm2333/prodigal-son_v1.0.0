
class Fireball {
  float x, y;
  float size = 20;
  float speedX, speedY;
  boolean alive = true;

  AudioPlayer fireSound;

  Fireball(float x, float y, float speedX, float speedY) {
    this.x = x;
    this.y = y;
    this.speedX = speedX;
    this.speedY = speedY;
    fireBallImg = loadImage("data/image/fireball2.png");

    fireSound = minim.loadFile("sfx/fire.mp3");
    if (currentLevel != 2) {
      fireSound.loop();

    }
    
    if (currentLevel == 2) {
      fireSound.pause();
      fireSound.rewind();//annoying sound
    }
  }


  void update() {
    if (!alive) return;

    x += speedX;
    y += speedY;

    if (x < cameraX - 100 || x > cameraX + width + 100 || y < -100 || y > height + 100) {//out of bounds of cam not level
      alive = false;
      if (fireSound != null) {
        fireSound.pause();
        fireSound.rewind();
      }
    }


    // player col
    if (player.x + player.width > x && player.x < x + size &&
      player.y + player.height > y && player.y < y + size) {
      if (player.invincibilityFrames <= 0) {
        lives--;
        score=0;
        playerHurtSound.trigger();
        player.invincibilityFrames = 60;
        loadLevel(currentLevel);
      }
      alive = false;
      if (fireSound != null) {
        fireSound.pause();
        fireSound.rewind();
      }
    }
  }

  void display() {
    if (!alive) return;

    pushMatrix();
    translate(x + size/2, y + size/2);
    imageMode(CENTER);

    image(fireBallImg, 0, 0, size, size);

    popMatrix();
  }
  void stopSound() {
    if (fireSound != null) {
      fireSound.pause();
      fireSound.rewind();
      fireSound.close();
      fireSound = null;
    }
  }
}
