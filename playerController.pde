char lastDirectionKey = 0;

void keyPressed() {

  //cycle lvl select
  if (gameState == STATE_LEVEL_SELECT) {
    if (key == 'a' || keyCode == LEFT) {
      selectedLevel--;
      if (selectedLevel < 0) selectedLevel = levelPreviews.length - 1;
    }

    if (key == 'd' || keyCode == RIGHT) {
      selectedLevel++;
      if (selectedLevel >= levelPreviews.length) selectedLevel = 0;
    }
  }
  if (inBossCutscene) {
    bossLineNow++;

    wooshSound.trigger();
    if (bossLineNow >= bossCutsceneLines.length) {//same as setup
      inBossCutscene = false;
      inCutscene = false;

      currentLevel++;
      if (currentLevel > maxLevel) {
        maxLevel = currentLevel;
      }

      loadLevel(currentLevel);
      gameState = STATE_GAME;

      storyMusic.pause();
      levelTwoMusic.rewind();
      levelTwoMusic.loop();
    }
    return;
  }



//end game reset
  if (gameState == STATE_GAMEOVER && key != ESC && canRestart) {
    playedGameOverSound = false;
    gameOverSound.pause();
    gameOverSound.rewind();
    for (Fireball fb : fireballs) {
      fb.stopSound();
    }
    fireballs.clear();
    canRestart = false;
    lives= 3;
    score= 0;
    player = null;
    currentLevel = 0;
    selectedLevel = 0;
    currentLine = 0;
    currentLine2 = 0;
    inSecondCutscene = false;
    levelOneMusic.pause();
    levelTwoMusic.pause();
    levelThreeMusic.pause();

    nextState = STATE_MENU;
    fadeDirection = 1;
    fading = true;
    return;
  }//very end skip
  if (gameState == STATE_BOSS_END && key == ENTER) {
    gameState = STATE_MENU;
    levelThreeMusic.pause();
    levelThreeMusic.rewind();
    levelOneMusic.pause();
    levelOneMusic.rewind();
    levelTwoMusic.pause();
    levelTwoMusic.rewind();
    endMusic.pause();
    endMusic.rewind();
    introMusic.loop();
    lives         = 3;
    score         = 0;
    currentLevel  = 0;
    selectedLevel = 0;
    gameState = STATE_MENU;
  }
  




//back out in intro
  if (key == ESC) {
    key = 0;
    wooshSound.trigger();
    if (gameState == STATE_CONTROLS || gameState == STATE_LEVEL_SELECT || gameState == STATE_HOW_TO_PLAY || gameState == 9) {
      gameState = STATE_MENU;
      gameOverSound.pause();
      gameOverSound.rewind();

      return;
    }
  }


//?
  if (gameState == STATE_MENU) {

    return;
  }

//cycle throught lines
  if (gameState == STATE_STORY) {
    if (!inSecondCutscene) {
      if (currentLine < cutsceneLines.length - 1) {
        currentLine++;
        wooshSound.trigger();
      } else {
        storyMusic.pause();
        levelOneMusic.loop();
        inCutscene = false;
        gameState = STATE_GAME;
        loadLevel(currentLevel);
      }
    } else {
      if (currentLine2 < cutsceneLines2.length - 1) {
        currentLine2++;
        wooshSound.trigger();
      } else {
        storyMusic.pause();
        levelTwoMusic.loop();
        inCutscene = false;
        inSecondCutscene = false;
        currentLevel++;

        if (currentLevel > maxLevel) {
          maxLevel = currentLevel;
        }

        gameState = STATE_GAME;
        loadLevel(currentLevel);
      }
    }
    return;
  }

//new cutscene function (so organized & smart)
  if (gameState == STATE_BOSS_CUTSCENE) {
    if (bossLineNow < bossCutsceneLines.length - 1) {
      bossLineNow++;
      wooshSound.trigger();
    } else {
      storyMusic.pause();
      levelThreeMusic.rewind();
      levelThreeMusic.loop();
      inCutscene = false;
      gameState = STATE_GAME;
      if (2 > maxLevel) {
        maxLevel = 2;
      }

      loadLevel(2);
    }
    return;
  }





  if (gameState == STATE_GAME) {//fireball on lvl 2 only with timer
    if ((key == 'e' || key == 'E') && currentLevel == 2 && fireballTimer <= 0) {
      boolean facingRight = lastDirectionKey != 'a';
      playerFireballs.add(new PlayerFireball(player.x + player.width/2, player.y + player.height/2, facingRight));// spawn at player
      fireballTimer = fireballCooldown;
    }


//player move
    if (key == 'a' || keyCode == LEFT) {
      lastDirectionKey = 'a';
      player.velX = -player.speed;
    } else if (key == 'd' || keyCode == RIGHT) {
      lastDirectionKey = 'd';
      player.velX = player.speed;
    } else if ((key == 'w' || keyCode == UP || key == ' ')
      && player.onGround) {
      jumpSound.trigger();
      player.velY = player.jumpPower;
      player.onGround = false;
      player.jumpBufferTimer = player.jumpBufferTime;
      player.jumpHeld       = true;
      player.jumpHoldTimer  = player.jumpHoldTime;
    }

    if ((key == 'r' || key == 'R') && gameState == STATE_GAME) {
      if (currentLevel == 2) {//no lvl 2 skip
        return;
      }


      if (currentLevel == 0) {
        startSecondCutscene();
        return;
      } else if (currentLevel == 1) {
        startBossCutscene();
        return;
      }
      currentLevel++;
      selectedLevel = currentLevel;
      if (currentLevel > maxLevel) {
        maxLevel = currentLevel;
      }
      lives = 3;
      score = 0;
      loadLevel(currentLevel);
      gameState = STATE_GAME;
      return;
    }



    return;
  }
}




void keyReleased() {//fancy movement smoothness
  if (gameState == STATE_GAME && player != null) {
    if ((key == 'a' || keyCode == LEFT) && lastDirectionKey == 'a') {
      player.velX = 0;
    }
    if ((key == 'd' || keyCode == RIGHT) && lastDirectionKey == 'd') {
      player.velX = 0;
    }

    if (key == 'w' || keyCode == UP || key == ' ') {
      player.jumpHeld = false;
    }
  }
  if (gameState == STATE_GAMEOVER) {
    canRestart = true;
  }
}

void mousePressed() {
  if (gameState == STATE_MENU) {
    if (overButton(width/2 - 200, height/2, 400, 80)) {
      // start game
      clickSound.trigger();
      selectedLevel = 0;
      currentLevel = 0;
      lives = 3;
      score = 0;
      introMusic.pause();
      levelOneMusic.pause();
      levelTwoMusic.pause();
      levelThreeMusic.pause();
      storyMusic.rewind();
      storyStarted = false;
      currentLine = 0;
      currentLine2 = 0;
      inSecondCutscene = false;
      nextState = STATE_STORY;
      fadeDirection = 1;
      fading = true;
      //all buttons hitbox
    } else if (overButton(100, 750, 380, 75)) {
      // contbutton
      gameState = STATE_CONTROLS;
      clickSound.trigger();
    } else if (overButton(width/2 - 200, 750, 400, 80)) {

      gameState = STATE_HOW_TO_PLAY;
      clickSound.trigger();
    } else if (overButton(1120, 750, 380, 75)) {

      gameState = STATE_LEVEL_SELECT;
      clickSound.trigger();
    } else if (overButton(width/2 - 200, 550, 400, 80)){
      gameState=9;
      clickSound.trigger();
    }
  } else if (gameState == STATE_LEVEL_SELECT) {
    if (mouseX > width/2 - 350 && mouseX < width/2 - 300 && mouseY > height/2 - 25 && mouseY < height/2 + 25) {//overlap with triangle
      selectedLevel--;
      if (selectedLevel < 0) selectedLevel = levelPreviews.length - 1;
      clickSound.trigger();
    }

    if (mouseX > width/2 + 300 && mouseX < width/2 + 350 && mouseY > height/2 - 25 && mouseY < height/2 + 25) {//overlap with triangle
      selectedLevel++;
      if (selectedLevel >= levelPreviews.length) selectedLevel = 0;
      clickSound.trigger();
    }

    if (overButton(width/2 - 150, height - 250, 300, 60)) {//play button
      if (selectedLevel <= maxLevel) {
        clickSound.trigger();
        currentLevel = selectedLevel;//reset
        lives = 3;
        score = 0;

        introMusic.pause();
        levelOneMusic.pause();
        levelTwoMusic.pause();
        levelThreeMusic.pause();

        loadLevel(currentLevel);
        gameState = STATE_GAME;
      }
    }
  } 
}
