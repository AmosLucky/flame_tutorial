import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'dart:math' as math;

import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class ElenaMain extends FlameGame  {
  SpriteComponent woman = new SpriteComponent();

  MuteMusicButton muteButton = new MuteMusicButton();

  @override
  Color backgroundColor() => Colors.grey;

  Future<void> onLoad() async {
    woman
      ..sprite = await loadSprite("woman.png")
      ..size = Vector2.all(100)
      ..position = Vector2(size[0] / 2, size[1] / 2 - 150);

    muteButton
      ..sprite = await loadSprite("volume-mute.png")
      ..size = Vector2.all(50);

    FlameAudio.bgm.initialize();

    add(muteButton);

    add(woman);
  }

  @override
  void update(double dt) {
    
    if (woman.angle < 2 * math.pi - .5) {
      woman.angle += .01;
    }
    if (woman.height < size[1] - 40) {
      woman.height += 1;
      woman.width += 1;
    } else {
      print("object");
      ///FlameAudio.bgm.play("wrong.mp3");
    }
    if(muteButton.isPlaying){
      FlameAudio.bgm.play("wrong.mp3");
    }else{
      FlameAudio.bgm.pause();
    }

    super.update(dt);
  }
}

class MuteMusicButton extends SpriteComponent  {
  bool isPlaying = true;
  @override
  bool onTapUp( info) {
   if(isPlaying){
     isPlaying = false;
   }else{
     isPlaying = true;
   }
    print("Mute Audio");

    // TODO: implement onTapUp
    return true;
  }
}
