class Platform {
  float x, y, width, height;
  String type;
  boolean breakable;
  Platform(float x, float y, float width, float height) {//deafault
    this(x, y, width, height, "platform", true);
  }

  Platform(float x, float y, float width, float height, String type) {
    this(x, y, width, height, type, true);//new breakable for boss
  }

  Platform(float x, float y, float width, float height, String type, boolean breakable) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.type = type;
    this.breakable = breakable;//bossfight
  }

  void display() {
    stroke(0);
    strokeWeight(1);

    if (type.equals("grass")) {//alignment
      image(grassImg, x +25, y +25, width, height);
    } else if (type.equals("solid")) {
      image(solidImg, x +25, y +25, width, height);
    } else if (type.equals("jumppad")) {
      image(bounceImg, x +25, y +23, width, height);
    } else if (type.equals("platform")) {


      image(platImg, x +30, y +2, width, height);
    }
  }
}
