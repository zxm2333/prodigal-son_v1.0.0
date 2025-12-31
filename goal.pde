class Goal {
  float x, y, size = 50;
  PImage[] frames;
  int frameIndex = 0;
  int frameTimer = 0;
  int frameDelay = 3;

  Goal(float x, float y) {
    this.x = x;
    this.y = y;

    frames = new PImage[11];
    frames[0] = loadImage("data/image/goal/goal1.png");
    frames[1] = loadImage("data/image/goal/goal2.png");
    frames[2] = loadImage("data/image/goal/goal3.png");
    frames[3] = loadImage("data/image/goal/goal4.png");
    frames[4] = loadImage("data/image/goal/goal5.png");
    frames[5] = loadImage("data/image/goal/goal6.png");
    frames[6] = loadImage("data/image/goal/goal7.png");
    frames[7] = loadImage("data/image/goal/goal8.png");
    frames[8] = loadImage("data/image/goal/goal9.png");
    frames[9] = loadImage("data/image/goal/goal10.png");
    frames[10] = loadImage("data/image/goal/goal11.png");
//rainbow cycle

    for (int i = 0; i < frames.length; i++) {
      frames[i].resize(int(50), int(50));//resize all array to 50x50
    }
  }

  void display() {
    if (frames != null && frames.length > 0) {
      image(frames[frameIndex], x + 25, y +25, size, size);//align

      frameTimer++;
      if (frameTimer >= frameDelay) {
        frameTimer = 0;
        frameIndex++;
        if (frameIndex >= frames.length) {
          frameIndex = 0;
        }
      }
    }
    stroke(0);
    strokeWeight(3);
  }

  boolean checkPlayerCollision() {//fix later too much outside
    return player.x + player.width > x -5 && player.x < x + size +5 && player.y + player.height > y -5 && player.y < y + size + 5;
  }
}
