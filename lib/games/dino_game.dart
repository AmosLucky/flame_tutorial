import 'dart:math';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flame/sprite.dart';

import 'package:flutter/material.dart';

import 'enemy/enemy_manager.dart';

class DinoGame extends FlameGame with TapDetector {
  dino? dinoComponent;
  EnemyManager? enemyManager;

  ParallaxComponent? parallaxComponent;
  TextComponent? scoreText;
  double score = 0;
  double velocityMultiplierDelta = 1;

  DinoGame() {}

  Future<void> onLoad() async {
    print(size);

    //final image = await images.load('dino_sprite_sheet.png');
    // final angryPigImage = await images.load('AngryPig/Walk (36x30).png');
    dinoComponent = dino(size);
    enemyManager = EnemyManager();
    parallaxComponent = await loadParallaxComponent([
      ParallaxImageData('parallax/plx-1.png'),
      ParallaxImageData('parallax/plx-2.png'),
      ParallaxImageData('parallax/plx-3.png'),
      ParallaxImageData('parallax/plx-4.png'),
      ParallaxImageData('parallax/plx-5.png'),
      ParallaxImageData('parallax/plx-6.png'),
    ],
        baseVelocity: Vector2(100, 0),
        velocityMultiplierDelta: Vector2(velocityMultiplierDelta, 0));

    //////
    scoreText = TextComponent();
    scoreText!.position = Vector2(size[0] / 2 - (scoreText!.width), 0);
    scoreText!.text = score.toString();

    ///
    //////

    add(parallaxComponent!);
    add(dinoComponent!);
    add(enemyManager!);
    add(scoreText!);
  }

  @override
  void update(double dt) {
    score += (60 * dt).toInt();
    scoreText!.text = score.toString();

    children.whereType<Enemy>().forEach((element) {
      if (dinoComponent!.distance(element) < 20) {
        dinoComponent!.hit();
      }
    });
    velocityMultiplierDelta += 0.01;
    super.update(dt);
  }

  @override
  void onTapUp(TapUpInfo info) {
    dinoComponent!.jump();
    //print("oooo");
    // TODO: implement onTapUp
    super.onTapUp(info);
  }

  @override
  void onTapDown(TapDownInfo info) {
    //print("oooo1");
    // TODO: implement onTapDown
    super.onTapDown(info);
  }
}

class dino extends SpriteAnimationComponent {
  SpriteSheet? spriteSheet;

  Vector2? screenSize;
  var idleAnimation;
  var runAnimation;
  var hitAnimation;
  double speedY = 0.0;
  double yMax = 0.0;
  double GRAVITY = 1000;

  Timer? _timer;
  bool isHit = false;

  dino(Vector2 screenSize) {
    this.screenSize = screenSize;
    _timer = Timer(2, onTick: () {
      run();
    });
  }
  onLoad() async {
    final dionImage = await Images().load('dino_sprite_sheet.png');
    spriteSheet = SpriteSheet(image: dionImage, srcSize: Vector2(24, 24));
    idleAnimation =
        spriteSheet!.createAnimation(row: 0, from: 0, to: 3, stepTime: 0.1);
    runAnimation =
        spriteSheet!.createAnimation(row: 0, from: 4, to: 10, stepTime: 0.1);
    hitAnimation =
        spriteSheet!.createAnimation(row: 0, from: 14, to: 16, stepTime: 0.1);

    size = Vector2.all(50);
    position = Vector2(120, this.screenSize![1] / 1.35);

    animation = runAnimation;
    yMax = y;
  }

  @override
  void update(double dt) {
    //final velocity = initial velocity + GRAVITY * time
    // v = u + at
    this.speedY += dt * GRAVITY;
    // distance = speed * time;
    // d = s * t;
    y += this.speedY * dt;

    if (isOnGround()) {
      y = this.yMax;
      this.speedY = 0;
    }
    _timer!.update(dt);
    super.update(dt);
  }

  void run() {
    isHit = false;
    animation = runAnimation;
  }

  void hit() {
    if (!isHit) {
      animation = hitAnimation;
      _timer!.start();
    }
  }

  void jump() {
    if (isOnGround()) {
      this.speedY = -350;
    }
  }

  bool isOnGround() {
    return (this.y >= this.yMax);
  }
}

enum EnemyType { AngryPig, Bat, Rino }

class EnemyData {
  String imageName;
  Vector2 srcSize;
  int from;
  int to;
  bool isFlying;
  double speed = 0.0;

  EnemyData(
      {required this.imageName,
      required this.srcSize,
      required this.from,
      required this.to,
      required this.isFlying,
      required this.speed});
}

class Enemy extends SpriteAnimationComponent {
  SpriteSheet? spriteSheet;

  Vector2? screenSize;

  var runAnimation;
  //double speed = 200;
  EnemyType enemyType;
  EnemyData? enemyData;

  static Map<EnemyType, EnemyData> enemyDetails = {
    EnemyType.AngryPig: EnemyData(
        from: 0,
        to: 16,
        imageName: "AngryPig/Walk (36x30).png",
        srcSize: Vector2(36, 30),
        isFlying: false,
        speed: 250),
    EnemyType.Bat: EnemyData(
        from: 0,
        to: 7,
        imageName: "Bat/Flying (46x30).png",
        srcSize: Vector2(46, 30),
        isFlying: true,
        speed: 400),
    EnemyType.Rino: EnemyData(
        from: 0,
        to: 6,
        imageName: "Rino/Run (52x34).png",
        srcSize: Vector2(52, 34),
        isFlying: false,
        speed: 300),
  };

  Enemy({required this.screenSize, required this.enemyType}) {
    enemyData = enemyDetails[enemyType];
  }

  onLoad() async {
    final emenyImage = await Images().load(enemyData!.imageName);

    spriteSheet = SpriteSheet(image: emenyImage, srcSize: enemyData!.srcSize);

    runAnimation = spriteSheet!.createAnimation(
        row: 0, from: enemyData!.from, to: enemyData!.to, stepTime: 0.1);

    size = Vector2.all(50);
    Random random = Random();

    // if (random.nextBool()) {
    //   Vector2(this.screenSize![0] - size.x, this.screenSize![1] / 1.70);
    // } else
    if (enemyData!.isFlying) {
      position =
          Vector2(this.screenSize![0] - size.x, this.screenSize![1] / 1.40);
    } else {
      position =
          Vector2(this.screenSize![0] - size.x, this.screenSize![1] / 1.35);
    }

    animation = runAnimation;
  }

  @override
  void update(double dt) {
    x -= enemyData!.speed * dt;

    if (x < 0) {
      removeFromParent();
    }

    // TODO: implement update
    super.update(dt);
  }
}
