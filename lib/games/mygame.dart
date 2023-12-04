import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyGame extends FlameGame  {
  SpriteComponent girl = new SpriteComponent();
  SpriteComponent boy = new SpriteComponent();
  SpriteComponent background = new SpriteComponent();
  SpriteComponent background2 = new SpriteComponent();
  final double characterSize = 150;
  bool turnAway = false;
  var dialogLevel = 0;
  int seneLevel = 1;
  DialogButton dialogButton = DialogButton();
  TextPaint textPaint = TextPaint(
    style: TextStyle(
        color: Colors.white,
        fontSize: 35,
        backgroundColor: Colors.black,
        fontWeight: FontWeight.bold),
  );

  @override
  Future onLoad() async {
    super.onLoad();

    final screenWidth = size[0];
    final screenHeight = size[1];
    var textBoxHeight = 20;

    girl
      ..sprite = await loadSprite("female.png")
      ..size = Vector2(characterSize, characterSize)
      ..y = screenHeight - characterSize - textBoxHeight
      ..anchor = Anchor.topCenter;

    boy
      ..sprite = await loadSprite("male.png")
      ..size = Vector2(characterSize, characterSize)
      ..y = screenHeight - characterSize - textBoxHeight
      ..x = screenWidth - characterSize
      ..anchor = Anchor.topCenter;

    background
      ..sprite = await loadSprite("BG.png")
      ..size = size;

    background2
      ..sprite = await loadSprite("bg.jpeg")
      ..size = size;

    dialogButton
      ..sprite = await loadSprite("heli.png")
      ..size = Vector2(50, 50)
      ..position = Vector2(200, 200)
      ..x = 600
      ..y = 300;

    add(background);
    add(background2);

    add(girl);
    add(boy);
    add(dialogButton);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (girl.x < size[0] / 2 - 100) {
      girl.x += 30 * dt;
      if (girl.x > 50 && dialogLevel == 0) {
        dialogLevel = 1;
      }
      if (girl.x > 150 && dialogLevel == 1) {
        dialogLevel = 2;
      }
      if (girl.x > 200 && dialogLevel == 2) {
        dialogLevel = 3;
      }
    } else if (!turnAway && seneLevel == 1) {
      boy.flipHorizontally();
      turnAway = true;
    }

    if (boy.x > size[0] / 2 + 50 && seneLevel == 1) {
      boy.x -= 30 * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    int sceneLevel = 0;
    super.render(canvas);
    switch (dialogLevel) {
      case 1:
        textPaint.render(canvas, "kenro: Please don\'t go, you will die",
            Vector2(10, size[1] - 50));
        break;
      case 2:
        textPaint.render(canvas, "ken: i will go nd fight for the village",
            Vector2(10, size[1] - 50));
        break;
      case 3:
        textPaint.render(
            canvas, "kenro: what about the baby", Vector2(10, size[1] - 50));
        break;
    }

    switch (dialogButton.scene2Leve) {
      case 1:
        seneLevel = 2;
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 50, size[0] - 150, 100),
            Paint()..color = Colors.black);
        textPaint.render(
            canvas, "ken: baby? i did not knw", Vector2(10, size[1] - 50));
        if (turnAway) {
          boy.flipHorizontally();
          turnAway = false;
          // remove(boy);
          //remove(girl);
          remove(background2);
          //remove(background);
          // add(boy);
          //  add(girl);
          //  add(background);
        }

        break;
      case 2:
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 50, size[0] - 150, 100),
            Paint()..color = Colors.black);
        textPaint.render(canvas, "kenro: we have a child on the way",
            Vector2(10, size[1] - 100));

        break;
    }
  }
}

class DialogButton extends SpriteComponent  {
  int scene2Leve = 0;
  @override
  bool onTapDown(TapDownInfo info) {
    print("We moe to the next screen");
    scene2Leve++;
    // TODO: implement onTapCancel
    try {
      return true;
    } catch (e) {
      return false;
    }
///return super.onTapCancel();
  }
}
