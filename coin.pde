class Coin {
  float x, y;
  float size = 30;
  boolean collected = false;
  float hoverY = 0;
  boolean goingUp = true;
  PImage coinImg;

  float collectY = 0;
  float collectAlpha = 255;

  Coin(float x, float y) {
    this.x = x;
    this.y = y;
    coinImg = loadImage("data/image/coin1.png");
  }

  void update() {
    if (!collected) {

      if (goingUp) {//up down anim
        hoverY -= 0.12;
        if (hoverY <= -5) goingUp = false;
      } else {
        hoverY += 0.12;
        if (hoverY >= 5) goingUp = true;
      }


      if (player.x + player.width > x && player.x < x + tileSize && player.y + player.height > y && player.y < y + tileSize) {//col
        collected = true;
        score++;
        coinSound.trigger();
      }
    } else {

      collectY -= 1;//cycle anim
      collectAlpha -= 10;
    }
    

  }

  void display() {
    if (collected && collectAlpha <= 0) return;//go away if <--

    float finalY = y + tileSize / 2 + hoverY + collectY;//finish pos for cycle anim
    float finalX = x + tileSize / 2;

    pushMatrix();
    translate(finalX, finalY);
    imageMode(CENTER);

    tint(255, collectAlpha);
    image(coinImg, 0, 0, size +10, size +10);//align proper

    noTint();
    popMatrix();

  }
}
