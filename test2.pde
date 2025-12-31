final int STATE_MENU         = 0;
final int STATE_STORY        = 1;
final int STATE_GAME         = 2;
final int STATE_GAMEOVER     = 3;
final int STATE_CONTROLS     = 4;
final int STATE_LEVEL_SELECT = 5;
final int STATE_HOW_TO_PLAY = 6;
final int STATE_BOSS_CUTSCENE = 7;
final int STATE_BOSS_END = 8;
final int STATE_CREDITS = 9;
//states



int gameState = STATE_MENU;

int maxLevel = 0;
int selectedLevel = 0;
PFont buttonFont;

PImage[] levelPreviews;


//vars all over the place
Player player;
ArrayList<Platform> platforms;
ArrayList<Enemy> enemies;
ArrayList<Crate> crates;
ArrayList<Bouncer> bouncers;
ArrayList<Greed> greeds;
ArrayList<FireShooter> fireShooters;
ArrayList<Fireball> fireballs;
ArrayList<Boss> bosss;
ArrayList<PlayerFireball> playerFireballs = new ArrayList<PlayerFireball>();
PImage backgroundImage;
PImage[] backgroundImages;
float glowAlpha = 200;
boolean fadeIn = false;
PFont font;
int lives = 3;
int levelWidth = 0;
PImage grassImg;
PImage platImg;
PImage solidImg;
PImage bounceImg;
PImage storyImage2;
PImage deathImage;
boolean playedGameOverSound = false;
float fireballTimer = 0;
float fireballCooldown = 0.28;
boolean bossCutsceneTriggered = false;
boolean inBossCutscene = false;
int currentBossLine = 0;
PImage fireBallImg;
float bossEndHoldStart = -1;
PImage loveBall;
PImage level3bg;
float shakeTimer     = 0;
float shakeDuration  = 0.3;
float shakeMagnitude = 10;
PImage[] bossCutsceneImgs = new PImage[3];




//more random vars
float cameraX = 0;
ArrayList<Coin> coins;
int score = 0;

int currentLevel = 0;
Goal goal;

PImage storyImage;
AudioPlayer storyMusic;
boolean storyStarted = false;
PImage bossGrass;



//music lib
import ddf.minim.*;
Minim minim;
AudioPlayer introMusic, levelOneMusic, levelTwoMusic, levelThreeMusic;
float fadeAlpha = 255;
boolean fading = false;
int fadeDirection = -1;
int nextState = -1;
//cutscene lines
String[] cutsceneLines = {
  "In my Father's house, there was peace.",
  "But my heart longed for the world beyond.",
  "So I left, chasing something I could not name."
};
String[] cutsceneLines2 = {
  "I thought I had found my freedom...",
  "But the world outside was harsher than I imagined.",
  "I must keep moving forward."
};
String[] bossCutsceneLines = {
  "I chased freedom, but found only emptiness.",
  "The world gave me nothing but pain and silence.",
  "I was wrong to leave my Father's house.",
  "But He still loves me.",
  "He has given me a new purpose.",
  "Now, I carry His love. I will fight with it.",
  "Press 'E' to share love with a fireball of hope."
};


boolean bossCutStar = false;
int bossLineNow = 0;


boolean inSecondCutscene = false;
int currentLine2 = 0;
int currentLine = 0;
boolean inCutscene = false;

//sfx
AudioSample jumpSound;
AudioSample coinSound;
AudioSample enemyHitSound;
AudioSample playerHurtSound;
AudioSample boomSound;
AudioSample boingSound;
AudioSample bouncerSound;
AudioSample fireShootSound;
AudioSample upSound;
AudioSample clickSound;
AudioSample wooshSound;
AudioPlayer gameOverSound;
AudioSample swordAttack;
AudioSample roarSound;
AudioSample laughSound;
AudioSample bossJump;
AudioSample pewSound;
AudioSample riseSound;
AudioSample stompSound;
AudioPlayer endMusic;
AudioSample tntSound;
AudioSample hitMark;

boolean canRestart = false;



void setup() {
  size(1600, 900);
  storyImage = loadImage("data/image/1stscene.png");
  storyImage.resize(1600, 900);
  minim = new Minim(this);
  storyMusic = minim.loadFile("data/sound/001_Synthwave_4k.mp3");


  //backgrouind images array with resize for stretchy
  backgroundImages = new PImage[4];
  backgroundImages[0] = loadImage("data/image/background.png");
  backgroundImages[0].resize(1600, 900);
  backgroundImages[1] = loadImage("data/image/background2.png");
  backgroundImages[1].resize(1600, 900);
  backgroundImages[2] = loadImage("data/image/city.jpg");
  backgroundImages[2].resize(1600, 900);
  backgroundImages[3] = loadImage("data/image/wasteland.png");
  backgroundImages[3].resize(1600, 900);
  storyImage2 = loadImage("data/image/level1.png");
  storyImage2.resize(1600, 900);
  deathImage = loadImage("data/image/deathscreen.png");
  level3bg = loadImage("data/image/preview_level4.png");
  level3bg.resize(1600, 900);
  bossCutsceneImgs[0] = loadImage("data/image/cutscene4.png");
  bossCutsceneImgs[1] = loadImage("data/image/cutscene5.png");
  bossCutsceneImgs[2] = loadImage("data/image/cutscene3.png");





  levelPreviews = new PImage[3];
  //level selector images
  levelPreviews[0] = loadImage("data/image/preview_level1.png");
  levelPreviews[1] = loadImage("data/image/preview_level2.png");
  levelPreviews[2] = loadImage("data/image/preview_level3.png");

  //load all the previews in a for loop
  for (int i = 0; i < levelPreviews.length; i++) {
    levelPreviews[i].resize(400, 300);
  }




  //sfx loaded
  jumpSound = minim.loadSample("sfx/jump.mp3");
  coinSound = minim.loadSample("sfx/coin.mp3");
  enemyHitSound = minim.loadSample("sfx/hit.wav");
  playerHurtSound = minim.loadSample("sfx/damage.wav");
  boomSound = minim.loadSample("sfx/boom.wav");
  boingSound = minim.loadSample("sfx/boing.wav");
  bouncerSound = minim.loadSample("sfx/bouncer.wav");
  fireShootSound=minim.loadSample("sfx/fireShoot.mp3");
  upSound = minim.loadSample("sfx/1up.mp3");
  clickSound = minim.loadSample("sfx/click.mp3");
  wooshSound = minim.loadSample("sfx/woosh.mp3");
  gameOverSound =minim.loadFile("sfx/15-game-over.mp3");
  swordAttack = minim.loadSample("data/boss/sword.mp3");
  roarSound = minim.loadSample("data/boss/roar.mp3");
  laughSound=minim.loadSample("data/sound/laugh.mp3");
  bossJump = minim.loadSample("data/boss/jump.wav");
  pewSound = minim.loadSample("data/boss/pew.wav");
  riseSound = minim.loadSample("data/boss/rise.mp3");
  stompSound = minim.loadSample("data/boss/boomboom.wav");
  tntSound = minim.loadSample ("data/sound/tnt.mp3");
  hitMark = minim.loadSample("sfx/hitmark.mp3");





  //pixel font
  font = createFont("PressStart2P-Regular.ttf", 128);
  textFont(font);


  //all main music
  introMusic = minim.loadFile("data/sound/025_A_New_Town.mp3");
  levelOneMusic = minim.loadFile("data/sound/020_one_through_five_tinySoundTrack_1-5.mp3");
  levelTwoMusic = minim.loadFile("data/sound/015_November_Snow.mp3");
  levelThreeMusic = minim.loadFile("sfx/battlemusic.mp3");
  endMusic = minim.loadFile("sfx/finish.mp3");

  introMusic.loop();

  buttonFont = createFont("data/PressStart2P-Regular.ttf", 32);
  textFont(buttonFont);
  bossGrass = loadImage("data/boss/boss_grass.png");
  gameState = STATE_MENU;
}
//what is this?!?!! (note: if i delete everything breaks)
int randInt(int min, int max) {
  return int(random(min, max));
}
void draw() {
  background(0);
  //draw all the states
  if (gameState == STATE_MENU) {
    drawMainMenu();
  } else if (gameState == STATE_CONTROLS) {
    drawControlsScreen();
  } else if (gameState == STATE_LEVEL_SELECT) {
    drawLevelSelectScreen();
  } else if (gameState == STATE_STORY) {
    drawStoryScreen();
  } else if (gameState == STATE_GAME) {
    updateGame();
    drawGame();
  } else if (gameState == STATE_GAMEOVER) {
    drawGameOver();
  } else if (gameState == STATE_HOW_TO_PLAY) {
    drawHowToPlayScreen();
  } else if (gameState == STATE_BOSS_CUTSCENE) {
    drawBossCutscene();
  } else if (gameState == STATE_BOSS_END) {

    drawBossEndScreen();
  } else if (gameState == 9) {
    drawCredits();
  }



  //fancy fade between scenes
  if (fading) {
    if (fading && fadeDirection == 1 && nextState != STATE_BOSS_END) {
      bossEndHoldStart = -1;//reverse fadde for the boss at end
    }

    fadeAlpha += fadeDirection * 4;//speed of fade
    fadeAlpha = constrain(fadeAlpha, 0, 255);//min 0 max 255

    fill(0, fadeAlpha);
    noStroke();
    rect(0, 0, width, height);//fill whole screen

    if ((fadeDirection == -1 && fadeAlpha <= 0) || (fadeDirection == 1 && fadeAlpha >= 255)) {
      fading = false;//this makes sure fade is over 0 or 255 based on start

      if (fadeDirection == 1 && nextState != -1) {
        gameState = nextState;//move to level
        if (gameState == STATE_GAMEOVER) {
          canRestart = true;
        }


        if (nextState == STATE_MENU) {//reset all when menu
          lives = 3;
          score = 0;
          player = null;
          currentLevel = 0;
          selectedLevel = 0;

          levelOneMusic.pause();
          levelTwoMusic.pause();
          levelThreeMusic.pause();
          introMusic.rewind();
          introMusic.loop();
        }

        nextState = -1;
        fadeDirection = -1;
        fading = true;
      }
    }
  }
}
float bouncyOff = 0;//fun bouncy effect for end
int   pulseDir    =  1;


void drawBossEndScreen() {

  bouncyOff += pulseDir * 0.2;
  if (bouncyOff > 5 || bouncyOff < -5) {//between 5 and -5 bouncy
    pulseDir *= -1;//goes oposite way
  }


  background(backgroundImage);
  for (Platform p : platforms) p.display();//show the map at the end
  //TODO: add movemen with player in end

  noStroke();
  for (int i = 0; i < 10; i++) {
    float fx = random(width);
    float fy = random(height * 0.4);
    float fr = random(5, 25);
    fill(random(255), random(255), random(255), 120);
    ellipse(fx, fy, fr, fr);
  }//the worst fireworks ever

  // bounce text
  fill(255);
  textAlign(CENTER, CENTER);

  textSize(48 + bouncyOff);
  text("Redeemed by Love", width/2, 200);

  textSize(24 + bouncyOff * 0.5);
  text("Press ENTER to return to the Menu", width/2, height - 100);
}

void drawCredits() {
  background(0);
  fill(255);
  textAlign(CENTER);
  textSize(48);
  text("Credits", width/2, 80);
  textSize(25);
  text("Music: Pixelsphere_Soundtrack_2.0 ", width/2, 180);
  text("library : Minim", width/2, 280);
  text("sfx: SFX-The Ultimate 2017 16 bit Mini pack", width/2, 380);
  textSize(20);
  fill(150);
  text("Press ESC to return", width/2, height - 40);
}






void drawBossCutscene() {
  int imgIndex = constrain(bossLineNow / 2, 0, 2);//change img every 2 lines
  background(bossCutsceneImgs[imgIndex]);


  if (!bossCutStar) {
    storyMusic.rewind();
    storyMusic.loop();
    bossCutStar = true;
  }

  fill(255);
  textSize(32);
  textAlign(CENTER);


  if (bossLineNow < bossCutsceneLines.length) {
    text(bossCutsceneLines[bossLineNow], width / 2, height / 2 - 100);//move the lines forward
  }

  text("Press any key to continue...", width / 2, height - 100);
}


void startFadeToMenu() {//fade effect for mauin menu
  fadeDirection = 1;
  nextState = STATE_MENU;
  fading = true;
}

void drawMainMenu() {
  background(backgroundImages[0]);
  textAlign(CENTER);
  fill(255);
  textSize(50);
  strokeWeight(1);
  stroke(255);

  drawButton("Start Game", width/2 -200, height/2, 400, 80);
  drawButton("Controls", 100, 750, 380, 75);
  drawButton("Choose Level", 1120, 750, 380, 75);
  drawButton("How to Play", width/2 - 200, 750, 400, 80);
  drawButton("Credits", width/2 - 200, 550, 400, 80);
  gameOverSound.pause();
  gameOverSound.rewind();
}

void drawHowToPlayScreen() {
  background(0);
  fill(255);
  textAlign(CENTER);
  textSize(48);
  text("How to Play", width/2, 80);

  textSize(28);
  text("Enemies:", width/2, 180);
  textSize(24);
  text("- Rats: Walks in random direction", width/2, 220);
  text("- Lie: Jumps up and down", width/2, 260);
  text("- Greed: slow but follows the player", width/2, 300);
  text("- Envy: Shoots fireballs!", width/2, 340);

  textSize(28);
  text("Boxes:", width/2, 420);
  textSize(24);

  text("- Use them to jump over obstacles", width/2, 500);
  text("- Push them through enemies to crush them!", width/2, 540);

  textSize(20);
  fill(150);
  text("Press ESC to return", width/2, height - 40);
}


void drawControlsScreen() {
  background(0);
  fill(255);
  strokeWeight(1);
  stroke(0);

  textAlign(CENTER);

  textSize(48);
  text("Controls", width/2, 120); // Big title at top

  textSize(28);
  text("Move Left: A  /  Left Arrow", width/2, 250);
  text("Move Right: D  /  Right Arrow", width/2, 300);
  text("Jump: W  /  Up Arrow  /  Space", width/2, 350);
  text("Skip Level: R  (Cheater)", width/2, 400);
  text("Share Love(final level only): E ", width/2, 450);

  textSize(20);
  fill(150);
  text("Press ESC to return to the menu", width/2, height - 50);
}


void drawLevelSelectScreen() {
  background(0);
  strokeWeight(1);
  stroke(0);
  fill(255);
  textSize(40);
  textAlign(CENTER);
  text("Select Level", width/2, 80);

  int arrowSize = 50;//for the sides of the level select

  fill(150);
  triangle(width/2 - 300, height/2 - 25, width/2 - 300, height/2 + 25, width/2 - 350, height/2);


  fill(150);
  triangle(width/2 + 300, height/2 - 25, width/2 + 300, height/2 + 25, width/2 + 350, height/2);


  if (selectedLevel <= maxLevel) {
    imageMode(CENTER);
    image(levelPreviews[selectedLevel], width/2, height/2);//fix when fall off map lvl 1
  } else {
    fill(100);
    rect(width/2 - 200, height/2 - 150, 400, 300);
    fill(200);
    textSize(32);
    text("Locked", width/2, height/2);
  }

  drawButton("Play Level", width/2 -150, height - 250, 300, 60);

  textSize(20);
  fill(150);
  text("Use ← → to cycle levels", width/2, height - 150);//fancy non-emoji arrows
  fill(255);
  textSize(20);
  textAlign(CENTER);
  text("Press ESC to return", width/2, height - 20);
}

boolean overButton(int x, int y, int w, int h) {//mouse overlap button
  return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
}
void drawButton(String label, int x, int y, int w, int h) {
  // hover?
  if (overButton(x, y, w, h)) {
    fill(100);
  } else {
    fill(50);
  }
  rect(x, y, w, h, 10);

  fill(255);
  textSize(24);
  textAlign(CENTER, CENTER);
  text(label, x + w/2, y + h/2);
}






void drawStoryScreen() {
  pushMatrix();
  resetMatrix();

  imageMode(CORNER);

  if (!inSecondCutscene) {
    image(storyImage, 0, 0);
  } else {
    image(storyImage2, 0, 0);
  }

  if (!storyStarted) {
    storyMusic.loop();
    storyStarted = true;
    inCutscene = true;
  }

  fill(255);
  textSize(32);
  textAlign(CENTER);

  if (!inSecondCutscene) {
    text(cutsceneLines[currentLine], width / 2, height / 2 - 100);
  } else {
    text(cutsceneLines2[currentLine2], width / 2, height / 2 - 100);
  }

  text("Press any key to continue...", width / 2, height - 100);
  popMatrix();
}






void drawIntro() {
  background(backgroundImages[0]);

  glowAlpha += fadeIn ? 2 : -2;//glowing effect
  if (glowAlpha > 255 || glowAlpha < 175) fadeIn = !fadeIn;

  textSize(50);
  textAlign(CENTER);

  fill(0);
  text("Press to Start", width / 2 - 2, height / 1.5 - 2);
  text("Press to Start", width / 2 + 2, height / 1.5 + 2);//we dont use any of this anymore?
  text("Press to Start", width / 2 - 2, height / 1.5 + 2);
  text("Press to Start", width / 2 + 2, height / 1.5 - 2);

  fill(255, 255, 255, glowAlpha);
  text("Press to Start", width / 2, height / 1.5);
}

void drawGameOver() {
  levelOneMusic.pause();
  levelThreeMusic.pause();
  levelTwoMusic.pause();

  imageMode(CORNER);
  image(deathImage, 0, 0);

  fill(255);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("You Died! Press any key to restart.", width/2, height/2 + 200);
}




int tileSize = 50; // each tile is 50x50pix

void loadLevel() {
  loadLevel(currentLevel);
  cameraX=0;//no more zoom camera
}

void loadLevel(int levelNum) {
  platforms = new ArrayList<Platform>();
  enemies = new ArrayList<Enemy>();
  coins = new ArrayList<Coin>();
  crates = new ArrayList<Crate>();
  bouncers = new ArrayList<Bouncer>();
  greeds = new ArrayList<Greed>();
  fireShooters = new ArrayList<FireShooter>();
  fireballs = new ArrayList<Fireball>();
  bosss = new ArrayList<Boss>();
  //enemies

  goal = null;

  String[] levelMap;

  if (levelNum == 0) {
    levelMap = new String[] {
      "...........................................C........................................................................................................................................................",
      "...........................................C........................................................................................................................................................",
      "...........................................C........................................................................................................................................................",
      "...........................................C...#....................................................................................................................................................",
      "...........................................C..........................C.............................................................................................................................",
      "...........................................C.........................C.C............................................................................................................................",
      ".........................................#.C........................................................................................................................................................",
      "...........................................C....#..................C................................................................................................................................",
      "...........................................C.......................#................................................................................................................................",
      "...........................................C........................................................................................................................................................",
      "...........................................#........................................................................................................................................................",
      "..................................................................#.#........................................................................................CC.....CCCCC...........................",
      "...................................####...............................................C....................................##S......CC........S..............###.....#####....B............CC......S",
      ".....................................................................................###..................E.....B............S.......E........S..........................S........................CS",
      "......CC...................####...............................S....SS....S..............................####........C..#.....S....####........S.........................SSSSSSS...................CS",
      ".............S........S......................................SS..........S..S..................C....................C........S................S........................SSSSSSSSSS.................CS",
      "P...........SS.....E..SS...............E.S.....S.....E......SSS..EC...C..S..S.S...........E....S.............E......C........S......E....C....S....E..................SSSSSSSSSSSSSSS.............CS",
      "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG.....GGGGGGGGGGGGGGGGGGGGGGGGGGG..G.GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGJGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGJGGGGGGGGGGGGGGGGGGGGGGGGGGGSSSS.......SFSS"
    };
    backgroundImage = backgroundImages[1];

    introMusic.pause();
    levelTwoMusic.pause();
    levelThreeMusic.pause();
    levelOneMusic.rewind();
    levelOneMusic.loop();

    grassImg = loadImage("data/image/grass2.png");
    platImg = loadImage("data/image/platform.png");
    solidImg = loadImage("data/image/box.png");
    bounceImg = loadImage("data/image/bounce.png");
  } else if (levelNum == 1) {
    levelMap = new String[] {
      "........................................................................S............................S.....CCC....S.......CCC........",
      ".....................................................................................................S.....3......S.......#####SSSSSF",
      ".....................................................................................................S.....###....S...2C.............",
      ".......................................................................................SS.....E......S......C.....S...###....C.......",
      "........................................................................S...###.........S....CCC.....SCC....S...C.S.........###......",
      "........................................................................S...........3...S...#####....SSS........SSS...............C..",
      "........................................................................S...1......###..s.........................SS.............###.",
      "........................................................................S.CCCC..........S..................##.....S.........C........",
      "........................................................................SSSSSSS.........S..C........2C...........#S........###.......",
      "........................................................................................S#####...SSSSS.......C....S1.CC..............",
      "......................................................................................2.S............S......###...SSSSSSSS......ECC..",
      "............................................C3C.....................................SSSSS.....##.....S.........................#####.",
      ".................C.........................#####........................S.......E.......S##........##SSSS.........S.......CC........3",
      ".................C....................CCC.......................B.......S.....CCCCC.....S.....CC.....S.....CC.....S.....######......S",
      "................###..................#####...............E..............S.....SSSSS.....S.....##.....S....##...2..S...E....E.........",
      ".................2...........C.........................#####............S......CCC...................C............S..................",
      "P......CCC............1......C.................1.......C...C..1.........S......E.2............1e.....C.....1......SCCCCCCCCCCCCCCCCCC",
      "GGGGGGGGGGGGGGGGGGGGGGGGG....G....GGGGGGGGGGGGGGGGGGGGG.....GGGGGGGJGGGGGGGGGGGGGGGGGGGGGGGGGJGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"
    };
    backgroundImage = backgroundImages[2];
    grassImg = loadImage("data/image/road.png");
    platImg = loadImage("data/image/platform2.png");
    bounceImg = loadImage("data/image/bounce.png");
    solidImg = loadImage("data/image/grass4.png");


    for (int i = 0; i < 100; i++) {//cool rain effect
      float rainX = random(cameraX, cameraX + width);
      float rainY = random(0, height);
      stroke(180);
      line(rainX, rainY, rainX + 2, rainY + 10);//more x for sideways falling look
    }
    levelTwoMusic.rewind();
    levelTwoMusic.loop();
    levelOneMusic.pause();

    introMusic.pause();
    levelThreeMusic.pause();
  } else if (levelNum == 2) {
    levelMap = new String[] {
      "................................",
      "................................",
      "................................",
      "................................",
      "................................",
      "................................",
      "................................",
      "................................",
      "................................",
      ".........##..........##.........",
      "................................",
      "......#.........4........#......",
      "..............####..............",
      "................................",
      "....#####..............#####....",
      "................................",
      "P...............................",
      "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGS"
    };
    backgroundImage = level3bg;
    levelTwoMusic.pause();
    levelOneMusic.pause();
    introMusic.pause();
    levelThreeMusic.rewind();
    levelThreeMusic.loop();

    grassImg = loadImage("data/boss/boss_grass.png");
    platImg = loadImage("data/image/platform3.png");
    bounceImg = loadImage("data/image/bounce.png");
    solidImg = loadImage("data/image/grass4.png");
  } else {
    println("no more levels dude");
    gameState = STATE_MENU;
    return;
  }
  for (int row = 0; row < levelMap.length; row++) {
    for (int col = 0; col < levelMap[row].length(); col++) {
      char tile = levelMap[row].charAt(col);
      float x = col * tileSize;
      float y = row * tileSize;
      //map layout thanks to my cousin help

      if (tile == '#') {
        platforms.add(new Platform(x, y, tileSize +10, tileSize, "platform"));
      } else if (tile == 'S') {
        platforms.add(new Platform(x, y, tileSize, tileSize, "solid"));
      } else if (tile == 'P') {
        player = new Player(x, y);
        player.heldCrate = null;
      } else if (tile == 'E') {
        enemies.add(new Enemy(x, y));
      } else if (tile == '2') {
        greeds.add(new Greed(x, y));
      } else if (tile == 'F') {
        goal = new Goal(x, y);
      } else if (tile == 'G') {
        platforms.add(new Platform(x, y, tileSize, tileSize, "grass", false));//so boss doesnt fall out in final level(thats too hard)
      } else if (tile == 'C') {
        coins.add(new Coin(x, y));
      } else if (tile == 'B') {
        crates.add(new Crate(x, y));
      } else if (tile == 'J') {
        platforms.add(new Platform(x, y, tileSize, tileSize, "jumppad"));
      } else if (tile == '1') {
        bouncers.add(new Bouncer(x, y));
      } else if (tile == '3') {
        fireShooters.add(new FireShooter(x, y));
      } else if (tile == '4') {
        bosss.add(new Boss(x, y));
      }
    }
  }
  levelWidth = levelMap[0].length() * tileSize;
}

void startSecondCutscene() {


  introMusic.pause();
  levelOneMusic.pause();
  levelTwoMusic.pause();
  levelThreeMusic.pause();

  storyStarted = false;
  inSecondCutscene = true;
  inCutscene = true;
  currentLine2 = 0;
  nextState = STATE_STORY;
  fadeDirection = 1;
  fading = true;
}
void startBossCutscene() {
  currentLevel++;
  selectedLevel = currentLevel;
  introMusic.pause();
  levelOneMusic.pause();
  levelTwoMusic.pause();
  levelThreeMusic.pause();
  storyMusic.rewind();

  storyStarted = false;
  inCutscene = true;
  bossLineNow = 0;
  nextState = STATE_BOSS_CUTSCENE;
  fadeDirection = 1;
  fading = true;
}



void updateGame() {
  if (fading) {
    return;
  }

  if (player != null) {
    player.update();
  }
  for (Enemy e : enemies) {
    e.update();
  }
  if (goal != null && goal.checkPlayerCollision()) {
    if (currentLevel == 0) {
      startSecondCutscene();
      return;
    } else if (currentLevel == 1) {
      startBossCutscene();
      return;
    }

    currentLevel++;

    if (currentLevel > maxLevel) {
      maxLevel = currentLevel;
    }

    loadLevel(currentLevel);
  }


  for (Coin c : coins) {
    c.update();
  }
  for (Crate c : crates) {
    c.update();
  }
  for (Bouncer b : bouncers) {
    b.update();
  }
  for (Greed g : greeds) {
    g.update();
  }
  for (FireShooter shooter : fireShooters) {
    shooter.update();
  }

  for (Fireball fireball : fireballs) {
    fireball.update();
  }
  for (int i = fireballs.size() - 1; i >= 0; i--) {//remove dead fireballs from the list backwards
    if (!fireballs.get(i).alive) {
      fireballs.remove(i);
    }
  }

  for (Boss b : bosss) {
    b.update();
  }

  for (int i = playerFireballs.size() - 1; i >= 0; i--) {//samething but with playerballs
    PlayerFireball pf = playerFireballs.get(i);
    pf.update();

    for (Boss b : bosss) {
      if (pf.x > b.x && pf.x < b.x + b.width && pf.y > b.y && pf.y < b.y + b.height) {//boss playerfire overlay
        b.takeDamage(10);
        playerFireballs.remove(i);
        break;
      }
    }

    if (pf.isOffScreen()) {//offscreen boolean
      playerFireballs.remove(i);
    }
  }





  ArrayList<Crate> toAdd = new ArrayList<Crate>();
  ArrayList<Crate> toRemove = new ArrayList<Crate>();//removes classes

  for (Crate crate : crates) {
    crate.update();

    if (crate.y > 1000) {
      if (!crate.hasRespawned) {
        toAdd.add(new Crate(player.x +30, player.y -30));
        crate.hasRespawned = true;
      }
      toRemove.add(crate); // kill fallen one
    }
  }

  crates.addAll(toAdd);
  crates.removeAll(toRemove);


  if (score>=300) {//1up
    lives++;
    score=0;
    upSound.trigger();
  }

  if (lives <= 0 && !fading) {//set fade for death
    fadeDirection = 1;
    nextState = STATE_GAMEOVER;
    fading = true;
    playedGameOverSound = false;
    gameOverSound.rewind();
    gameOverSound.loop();
    return;
  }





  for (int i = playerFireballs.size() - 1; i >= 0; i--) {//same fireball code but for update in list
    playerFireballs.get(i).update();
    if (playerFireballs.get(i).isOffScreen()) {
      playerFireballs.remove(i);
    }
  }

  if (fireballTimer > 0) {
    fireballTimer -= 1.0 / frameRate;
  }
}



void drawGame() {

  background(backgroundImage);

  if (backgroundImage == backgroundImages[2]) {//bg array
    tint(150, 170, 200);
    noTint();

    fill(0, 0, 30, 120);
    noStroke();
    rect(0, 0, width, height);

    stroke(180);
    for (int i = 0; i < 40; i++) {
      float rainX = random(0, width);
      float rainY = random(0, height);
      line(rainX, rainY, rainX +2, rainY + 10);//rain code again?
    }
  }


  if (player == null) return;


  pushMatrix();

  float targetCamX = player.x - width / 2 + player.width / 2;//camera follow
  float cameraDelay  = 20;//smoothness
  cameraX += (targetCamX - cameraX) / cameraDelay;

  cameraX = constrain(cameraX, 0, max(0, levelWidth - width));//camera max and min

  if (shakeTimer > 0) {//shake for bossfight
    float shakeOffset = random(-shakeMagnitude, shakeMagnitude);
    translate(-(cameraX + shakeOffset), 0);


    shakeTimer -= 1.0/frameRate;
    if (shakeTimer < 0) shakeTimer = 0;
  } else {
    translate(-cameraX, 0);//normal camera loc
  }






  //draw
  if (goal != null) {
    goal.display();
  }

  for (Platform p : platforms) {
    p.display();
  }

  for (Enemy e : enemies) {
    e.display();
  }

  if (player != null) {
    player.display();
  } else {
  }
  for (Coin c : coins) {
    c.display();
  }
  for (Crate c : crates) {
    c.display();
  }
  for (Bouncer b : bouncers) {
    b.display();
  }
  for (Greed g : greeds) {
    g.display();
  }
  for (FireShooter shooter : fireShooters) {
    shooter.display();
  }

  for (Fireball fireball : fireballs) {
    fireball.display();
  }

  for (Boss b : bosss) {
    b.display();
  }
  for (Boss b : bosss) {
    if (b.alive) {
      textSize(30);
      text("The False Father", width/2 - 230, 100);
      float hpPercent = b.health / 300.0;
      fill(0);
      rect(400, 40, 800 *1.1, 30*1.1);
      fill(255, 0, 0);
      rect(400, 40, 800 * hpPercent*1.1, 30*1.1);
      fill(255);
      rect(690, 40, 5*1.1, 30*1.1);
      rect(990.333, 40, 5*1.1, 30*1.1);
    }
  }


  for (PlayerFireball pf : playerFireballs) {
    pf.display();
  }

  if (inBossCutscene) {
    fill(0, 150);
    rect(0, 0, width, height);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(32);
    text(bossCutsceneLines[currentBossLine], width/2, height/2);
  }






  popMatrix();

  fill(255);
  textSize(24);
  text("Lives: " + lives, 200, 40);
  fill(100);

  fill(255);
  textSize(24);
  textAlign(RIGHT, TOP);
  text("Score: " + score, width - 40, 40);

  fill(255);
  textSize(18);
  textAlign(LEFT, TOP);
  text("FPS: " + int(frameRate), 10, 10);
}
