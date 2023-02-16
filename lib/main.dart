import 'package:flame/game.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'games/collision_game.dart';
import 'games/dino_game.dart';
import 'games/elena.dart';
import 'package:flame/flame.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//TestWidgetsFlutterBinding.ensureInitialized();
  //final dir = await getApplicationDocumentsDirectory();
 // Hive.init(dir.path);
  AudioManager.instance
      .init(["8BitPlatformerLoop.wav", "hurt7.wav", "jump14.wav"]);

  await Flame.device.fullScreen();
  runApp(MaterialApp(title: "Dino Game", home: GameWidget(game: DinoGame())));
  AudioManager.instance.startBGM("8BitPlatformerLoop.wav");
  //runApp(GameWidget(game: MyGame()));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}
