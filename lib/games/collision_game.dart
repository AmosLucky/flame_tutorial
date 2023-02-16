import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class CollisionGame extends FlameGame with HasCollisionDetection {
  Future<void> onLoad() async {
    print("object");
    add(SpriteComponent()
      ..sprite = await loadSprite("BG.png")
      ..size = size);
    add(northComponent(await loadSprite("heli.png"))..flipHorizontally());
    add(southComponent(await loadSprite("ball.png")));
    super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}

class northComponent extends SpriteComponent with CollisionCallbacks {
  northComponent(Sprite sprite) {
    this.sprite = sprite;
    size = Vector2(100, 100);
    position = Vector2(600, 200);
    anchor = Anchor.center;
    debugMode = true;
  }
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    if (this.x > size[0]) {
      this.x -= 2;
    } else {
      this.x = 100;
    }
    // TODO: implement update
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (other == southComponent) {
      remove(other);
      print("Oooo");
    }
  }
}

class southComponent extends SpriteComponent with CollisionCallbacks {
  southComponent(Sprite sprite) {
    this.sprite = sprite;
    size = Vector2(50, 50);
    position = Vector2(100, 200);
    anchor = Anchor.center;
    debugMode = true;
  }
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    //remove()
    //
    removeFromParent();
  }
}
