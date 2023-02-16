import 'package:flame/game.dart';
import 'package:flame_tutorial/games/dino_game.dart';
import 'package:flame_tutorial/games/elenamain.dart';
import 'package:flame_tutorial/games/leena.dart';
import 'package:flame_tutorial/games/mygame.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'games/collision_game.dart';
import 'games/elena.dart';
import 'package:flame/flame.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  runApp(GameWidget(game: DinoGame()));
  //runApp(GameWidget(game: MyGame()));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}
