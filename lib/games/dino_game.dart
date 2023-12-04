import 'dart:async';
import 'dart:math';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';

import 'package:flutter/material.dart';

import 'enemy/enemy_manager.dart';
import 'package:flame/widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DinoGame extends FlameGame with PanDetector {
  dino? dinoComponent;
  EnemyManager? enemyManager;

  ParallaxComponent? parallaxComponent;
  TextComponent? scoreText;
  double score = 0;
  double velocityMultiplierDelta = 1;
  StartButton? startButton;
  double health = 5;
  //Dialog? dialog;

  Sprite? dialogSprite;

  Future<void> onLoad() async {
    print(size);
    dialogSprite = await loadSprite("replay.png");

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
    scoreText = TextComponent(
        textRenderer: TextPaint(style: TextStyle(fontFamily: "Audiowide")));
    scoreText!.position = Vector2(size[0] / 2 - (scoreText!.width), 0);
    scoreText!.text = score.toString();

    ///
    //////

    add(parallaxComponent!);
    add(dinoComponent!);
    add(enemyManager!);
    add(scoreText!);
    startButton = StartButton(await loadSprite("pause_play.png"));

    add(startButton!);
    //add
    displayLife();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    dinoComponent!.move(info.delta.global);
  }

  @override
  void update(double dt) {
    // print(dinoComponent!.life.value);
    score += (60 * dt).toInt();
    scoreText!.text = score.toString();

    children.whereType<Enemy>().forEach((element) {
      if (dinoComponent!.distance(element) < 20) {
        dinoComponent!.hit();
        if (health == 0) {
          endGame();
        }
      }
    });
    velocityMultiplierDelta += 0.01;
    super.update(dt);
  }

  endGame() async {
    // Timer t =  Timer(1, onTick: () {
    //   pauseEngine();
    // });
    //t.start();

    add(Dialog(dialogSprite!));
    // remove(dinoComponent!);
    pauseEngine();
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    dinoComponent!.jump();
    // TODO: implement onTapDown
    //super.onTapDown(pointerId, info);
  }

  reset() {
    health = 5;
    displayLife();
  }

  displayLife() async {
    for (var i = 1; i <= health; i++) {
      final positionX = 40 * i;
      await add(
        HeartComponent(
          await loadSprite("hearth.png"),
          heartNumber: i.toDouble(),
          hPosition: Vector2(positionX.toDouble() + size[0] - 300, 20),
        ),
      );
    }
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    // TODO: implement lifecycleStateChange
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.paused:
        this.pauseEngine();
        break;
      case AppLifecycleState.detached:
        this.pauseEngine();
        break;
      case AppLifecycleState.inactive:
        this.pauseEngine();
        break;
    }
    super.lifecycleStateChange(state);
  }
}

class HeartComponent extends SpriteComponent with HasGameRef<DinoGame> {
  Vector2 hPosition;
  double heartNumber;

  HeartComponent(Sprite sprite,
      {required this.hPosition, required this.heartNumber}) {
    // gameRef.pauseEngine();
    this.sprite = sprite;
    size = Vector2.all(35);
    position = hPosition;
  }
  onLoad() {
    print(heartNumber);
  }

  @override
  void update(double dt) {
    if (gameRef.health < heartNumber) {
      removeFromParent();
    }
    // TODO: implement update
    super.update(dt);
  }
}

class Dialog extends SpriteComponent with HasGameRef<DinoGame> {
  Dialog(Sprite sprite) {
    // gameRef.pauseEngine();
    this.sprite = sprite;
    size = Vector2(200, 200);
    position = Vector2(200, 100);

    // gameRef.pauseEngine();
  }

  @override
  bool ronTapDown(TapDownInfo info) {
    gameRef.score = 0;
    gameRef.health = 5;
    gameRef.resumeEngine();
    gameRef.reset();
    gameRef.enemyManager!.reset();
    gameRef.dinoComponent!.reset();
    gameRef.children.whereType<Enemy>().forEach((element) {
      //remove(element);
      this.makeTransparent();
    });
    removeFromParent();

    //print("pppp");
    // TODO: implement onTapDown
    //return super.onTapDown(info);
    return true;
  }
}

class StartButton extends SpriteComponent with HasGameRef<DinoGame> {
  bool gamePlaying = false;
  StartButton(Sprite sprite) {
    // gameRef.pauseEngine();
    this.sprite = sprite;
  }
  onLoad() async {
    size = Vector2(50, 50);
    position = Vector2(20, 20);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    if (!gamePlaying) {
      AudioManager.instance.pauseBGM();
      gameRef.resumeEngine();
      gamePlaying = true;
    } else {
      AudioManager.instance.resumeBGM();
      gameRef.pauseEngine();
      gamePlaying = false;
    }

    //print("pppp");
    // TODO: implement onTapDown
    return true;
  }
}

class dino extends SpriteAnimationComponent with HasGameRef<DinoGame> {
  SpriteSheet? spriteSheet;
  int health = 3;
  ValueNotifier<int> life = ValueNotifier(5);

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

  reset() {
    animation = runAnimation;
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

  void move(Vector2 delta) {
    position.add(delta);
  }

  void hit() {
    if (!isHit) {
      animation = hitAnimation;
      _timer!.start();
      isHit = true;
      // health -= 1;
      gameRef.health -= 1;
      life.value -= 1;
      AudioManager.instance.playSFX("hurt7.wav");
    }
  }

  void jump() {
    if (isOnGround()) {
      this.speedY = -350;
      AudioManager.instance.playSFX("jump14.wav");
    }
  }
  //0699020431

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

class AudioManager {
  AudioManager._interal();
  static AudioManager _instance = AudioManager._interal();
  static AudioManager get instance => _instance;
  void init(List<String> fileNames) async {
    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll(fileNames);
    pref = await Hive.openBox("preference");

    if (pref!.get("bgm") == null) {
      pref!.put("bgm", true);
    }

    if (pref!.get("sfx") == null) {
      pref!.put("sfx", true);
    }
    _sfx = ValueNotifier(pref!.get("sfx"));
    _bgm = ValueNotifier(pref!.get("bgm"));
  }

  ValueNotifier<bool>? _sfx;
  ValueNotifier<bool>? _bgm;
  Box? pref;

  ValueNotifier<bool>? get lisenablesfx => _sfx;
  ValueNotifier<bool>? get lisenablebgm => _bgm;

  void setSFX(bool flag) {
    pref!.put("sfx", true);
    _sfx!.value = flag;
  }

  void setBGN(bool flag) {
    pref!.put("bgm", true);
    _bgm!.value = flag;
  }

  void startBGM(String filename) {
    FlameAudio.bgm.play(filename, volume: 0.4);
  }

  void pauseBGM() {
    FlameAudio.bgm.pause();
  }

  void playBGM() {}
  void stopBGM() {}
  void resumeBGM() {
    FlameAudio.bgm.resume();
  }

  void playSFX(String filename) {
    FlameAudio.play(filename);
  }
}
