import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

class MyGeorge extends FlameGame{

  Future<void> onLoad()async{
    super.onLoad();

    final SpriteSheet spriteSheet =  new SpriteSheet(image: await images.load("heli.png"), srcSize: Vector2(48,48));
    

  }
}