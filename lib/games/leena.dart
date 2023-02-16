import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Leena extends FlameGame {
  SpriteComponent leena = SpriteComponent();
  SpriteComponent bg = SpriteComponent();
  var velocity = Vector2(0, 0);
  var gravity = 1.8;
  TiledComponent? homeMap;
  @override
  Future<void> onLoad() async {
    homeMap = await TiledComponent.load("map1.tmx", Vector2.all(32));
    leena
      ..sprite = await loadSprite("leena.png")
      ..size = Vector2(100, 100)
      ..position = Vector2(100, 100);

    bg
      ..sprite = await loadSprite("BG.png")
      ..size = size;

    add(homeMap!);
    //add(bg);

    add(leena);
  }

  @override
  void update(double dt) {
    if (leena.position.y < size[1] - leena.height) {
      velocity.y += gravity;
      leena.y += velocity.y * dt;
    } else {
      leena.y = 0;
      velocity.y = 0;
    }
    // TODO: implement update
    super.update(dt);
  }
}
