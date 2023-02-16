import 'dart:math';

import 'package:flame/components.dart';

import '../dino_game.dart';


class EnemyManager extends Component with HasGameRef<DinoGame> {
  Random? random;
  Timer? timer;
  int spawnLevel = 0;
  EnemyManager() {
    random = Random();
    timer = Timer(4, repeat: true, onTick: () {
      spawnRandomEnemy();
    });
  }

  void spawnRandomEnemy() {
    final randomNumber = random!.nextInt(EnemyType.values.length);
    final randomEnemy = EnemyType.values.elementAt(randomNumber);
    final newEnemy = Enemy(screenSize: gameRef.size, enemyType: randomEnemy);
    gameRef.add(newEnemy);
  }

  @override
  void onMount() {
    timer!.start();
    // TODO: implement onMount
    super.onMount();
  }

  @override
  void update(double dt) {
    timer!.update(dt);
    var newspawnLevel = (gameRef.score.toInt() ~/ 500);
    if (spawnLevel < newspawnLevel) {
      spawnLevel = newspawnLevel;
      var newWaitTimer = (4 / (1 + (0.1 * spawnLevel)));
      timer!.stop();

      timer = Timer(newWaitTimer, repeat: true, onTick: () {
        spawnRandomEnemy();
      });

      timer!.start();
    }
    // TODO: implement update
    super.update(dt);
  }

  reset() {
    
    spawnLevel = 0;
    timer = Timer(4, repeat: true, onTick: () {
      spawnRandomEnemy();
    });
  }
}
