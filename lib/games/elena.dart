import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'dart:math' as math;

import 'package:flame/input.dart';

class Elena extends FlameGame  {
  SpriteComponent woman = new SpriteComponent();
  SpriteComponent startButton = new SpriteComponent();
  SpriteComponent volumeMute = new SpriteComponent();
  RightButton? rightImage;
  LeftButton? leftImage;
  TopButton? topImage;
  BottomButton? bottomImage;
  SpriteComponent heli = new SpriteComponent();
  ResetBtn? resetBtn;
  SpriteComponent bg = new SpriteComponent();
  SpriteComponent ball = new SpriteComponent();

  // RightButton? rightBtn;
  // LeftButton? leftBtn;
  // TopButton? topBtn;
  // BottomButton? bottomBtn;

  Future<void> onLoad() async {
    rightImage = new RightButton(component: heli);
    leftImage = new LeftButton(component: heli);
    topImage = new TopButton(component: heli);
    bottomImage = new BottomButton(component: heli);

    bg
      ..sprite = await loadSprite("BG.png")
      ..size = size;

    woman
      ..sprite = await loadSprite("woman.png")
      ..size = Vector2.all(100)
      ..position = Vector2(size[0] / 2, size[1] / 2 - 150);

    // resetBtn!
    //   ..sprite = await loadSprite("start-button.png")
    //   ..size = Vector2.all(50);

    heli
      ..sprite = await loadSprite("heli.png")
      ..size = Vector2.all(50)
      ..position = Vector2(50, size[1] / 2.4);
    //heli.flipVerticallyAroundCenter();

    resetBtn = new ResetBtn(component: heli);
    resetBtn!
      ..sprite = await loadSprite("start-button.png")
      ..size = Vector2.all(50);

    rightImage!
      ..sprite = await loadSprite("button.png")
      ..size = Vector2.all(50)
      ..position = Vector2(50, size[1] / 1.4);

    leftImage!
      ..sprite = await loadSprite("button.png")
      ..size = Vector2.all(50)
      ..position = Vector2(250, size[1] / 1.4);
    leftImage!.flipHorizontally();

    bottomImage!
      ..sprite = await loadSprite("button.png")
      ..size = Vector2.all(50)
      ..position = Vector2(120, size[1] / 1.2);
    //..transform.angleDegrees = 90 ;
    topImage!
      ..sprite = await loadSprite("button.png")
      ..size = Vector2.all(50)
      ..position = Vector2(120, size[1] / 1.7);

    add(bg);

    add(rightImage!);
    add(leftImage!);
    add(bottomImage!);
    add(topImage!);

     add(woman);
    add(heli);
    add(resetBtn!);
    createBall();
    //add(ball);
  }

  @override
  void update(double dt) {
    //rotateScale(woman);
    if (heli.x < size[0]) {
      heli.x += 1;
    } else {
      heli.x = 0;
    }

    if ( heli.y == ball.y) {
      if (ball.parent != null) {
        remove(ball);
        heli.size.x += 20;
         heli.size.y += 20;

        createBall();
      }
    }

    // TODO: implement update
    super.update(dt);
  }

  createBall() async {
    Random random = Random();
    int x = random.nextInt(size[0].toInt());
    int y = random.nextInt(size[1].toInt());
    ball = SpriteComponent()
      ..sprite = await loadSprite("ball.png")
      ..size = Vector2.all(30)
      ..position = Vector2(x.toDouble(), y.toDouble());
    ;

    add(ball);
  }

  void rotateScale(SpriteComponent spriteComponent) async {
    if (spriteComponent.angle < 2 * math.pi - 0.5) {
      spriteComponent.angle += 0.01;
      spriteComponent.size.y += 1;
      spriteComponent.size.x += 0.5;
    } else {
      resetWoman(spriteComponent);
    }
  }

  void resetWoman(SpriteComponent component) async {
    component
      ..sprite = await loadSprite("woman.png")
      ..size = Vector2.all(100)
      ..position = Vector2(size[0] / 2, size[1] / 2 - 150)
      ..angle = 0;
  }
}

class ResetBtn extends SpriteComponent  {
  SpriteComponent component;
  ResetBtn({required this.component});
  @override
  bool onTapDown( info) {
    component.angle = 0;
    component.x = 0;
    // TODO: implement onTapCancel
    return  true;
  }
}

class RightButton extends SpriteComponent  {
  SpriteComponent component;
  RightButton({required this.component});
  @override
  bool onTapDown( info) {
    component.angle = 0;
    component.x -= 40;
    // TODO: implement onTapCancel
    return true;
  }
}

class LeftButton extends SpriteComponent  {
  SpriteComponent component;
  LeftButton({required this.component});
  @override
  bool onTapDown( info) {
    component.angle = 0;
    component.x += 10;
    // TODO: implement onTapCancel
    return true;
  }
}

class TopButton extends SpriteComponent  {
  SpriteComponent component;
  TopButton({required this.component});
  @override
  bool onTapDown( info) {
    component.angle = 0;
    component.y -= 10;
    // TODO: implement onTapCancel
   return true;
  }
}

class BottomButton extends SpriteComponent  {
  SpriteComponent component;
  BottomButton({required this.component});
  @override
  bool onTapDown( info) {
    component.angle = 0;
    component.y += 10;
    // TODO: implement onTapCancel
    return true;
  }
}
