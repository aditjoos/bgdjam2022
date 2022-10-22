import 'package:bgdjam/game.dart';
import 'package:bgdjam/objects/hantu.dart';
import 'package:bgdjam/objects/item.dart';
import 'package:bgdjam/objects/scene_transition.dart';
import 'package:bgdjam/objects/tembok.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';

class Lili extends PositionComponent
    with KeyboardHandler, CollisionCallbacks, HasGameRef<MyGame> {
  Lili({
    required double x,
    required double y,
    required Vector2 size,
  })  : _x = x,
        _y = y,
        super(
          size: size,
        );

  final double _x;
  final double _y;

  int _hAxisInput = 0;
  int _yAxisInput = 0;

  final double _moveSpeed = 60;
  final Vector2 _velocity = Vector2.zero();

  final LiliAnimation _animation = LiliAnimation();

  @override
  Future<void>? onLoad() async {
    add(_animation);

    anchor = Anchor.center;

    x = _x;
    y = _y;

    var hitbox = CircleHitbox();

    add(hitbox);

    // debugMode = true;

    super.onLoad();
  }

  @override
  void update(double dt) async {
    // Moving
    _velocity.x = _hAxisInput * _moveSpeed;
    _velocity.y = _yAxisInput * _moveSpeed;

    position += _velocity * dt;

    super.update(dt);
  }

  bool isKunciJalan = false;

  bool _isInteraksi = false;
  bool _isInteraksiSelesai = true;

  bool _dekatDenganInteraksi = false;

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _run(keysPressed);

    if (_dekatDenganInteraksi) {
      if (event.isKeyPressed(LogicalKeyboardKey.keyX)) {
        _isInteraksi = true;
      }
    }

    if (event.isKeyPressed(LogicalKeyboardKey.keyQ)) {
      gameRef.prefs.clear();
    }

    return super.onKeyEvent(event, keysPressed);
  }

  int _currentDirection = 4;

  int _stepSoundDelayer = 1;

  _run(Set<LogicalKeyboardKey> keysPressed) {
    if (isKunciJalan) return;

    _hAxisInput = 0;
    _yAxisInput = 0;

    if (_stepSoundDelayer == 1) {
      // FlameAudio.play('nyah-105109.mp3');
    }

    if (_stepSoundDelayer == 10) {
      _stepSoundDelayer = 0;
    }

    _stepSoundDelayer++;

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      _hAxisInput += -1;
      _currentDirection = 4;
      _animation.changeAnimation(1, _currentDirection);
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      _hAxisInput += 1;
      _currentDirection = 2;
      _animation.changeAnimation(1, _currentDirection);
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      _yAxisInput += -1;
      _currentDirection = 1;
      _animation.changeAnimation(1, _currentDirection);
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      _yAxisInput += 1;
      _currentDirection = 3;
      _animation.changeAnimation(1, _currentDirection);
    } else {
      _hAxisInput = 0;
      _yAxisInput = 0;
      _animation.changeAnimation(0, _currentDirection);

      _stepSoundDelayer = 0;
    }
  }

  @override
  void onCollision(
      Set<Vector2> intersectionPoints, PositionComponent other) async {
    if (other is Tembok) {
      if (intersectionPoints.length == 2) {
        final mid = (intersectionPoints.elementAt(0) +
                intersectionPoints.elementAt(1)) /
            2;

        final collisionNormal = absoluteCenter - mid;

        final separationDistance = (size.x / 2) - collisionNormal.length;

        position += collisionNormal.normalized().scaled(separationDistance);
      }
    }

    if (other is Hantu) {
      _dekatDenganInteraksi = true;

      if (_isInteraksi &&
          _isInteraksiSelesai &&
          (gameRef.itemStage == 0 ||
              (gameRef.itemStage == 2 && gameRef.item == other.item)) &&
          other.dialogAda) {
        isKunciJalan = true;

        _hAxisInput = 0;
        _yAxisInput = 0;
        _animation.changeAnimation(0, _currentDirection);

        List<String> dialog = other.interaksiSelesai || gameRef.itemStage == 2
            ? other.dialogKedua
            : other.dialogNormal;

        if (other.currentDialog == dialog.length) {
          other.currentDialog = 0;
          isKunciJalan = false;

          gameRef.showDialog('', Vector2.zero());

          // jika ada item dari Hantu
          if (gameRef.itemStage == 0 &&
              other.itemAda &&
              !other.interaksiSelesai) {
            gameRef.itemStage = 1;
            gameRef.item = other.item;
            gameRef.overlays.add('ui_item');
            gameRef.overlays.remove('ui_interaksi');
          }

          if (!other.itemAda) {
            other.interaksiSelesai = true;
            if (!gameRef.cekSudahInteraksi(other.namaHantu)) {
              gameRef.setSudahInteraksi(other.namaHantu);
              other.updatePoin();
            }
          }

          if (gameRef.itemStage == 2) {
            gameRef.item = '';
            gameRef.itemStage = 0;
            gameRef.overlays.remove('ui_item');
            other.interaksiSelesai = true;

            if (!gameRef.cekSudahInteraksi(other.namaHantu)) {
              gameRef.setSudahInteraksi(other.namaHantu);
              other.updatePoin();
            }
          }
        } else {
          gameRef.showDialog(
            dialog[other.currentDialog],
            Vector2(other.x + 10, other.y - 5),
          );

          other.currentDialog++;
        }

        _isInteraksiSelesai = false;

        await Future.delayed(const Duration(seconds: 1));

        _isInteraksiSelesai = true;
        _isInteraksi = false;
      }
    }

    if (other is Item) {
      _dekatDenganInteraksi = true;

      if (_isInteraksi &&
          _isInteraksiSelesai &&
          other.namaItem == gameRef.item &&
          gameRef.itemStage == 1) {
        isKunciJalan = true;

        _hAxisInput = 0;
        _yAxisInput = 0;
        _animation.changeAnimation(0, _currentDirection);

        if (other.currentDialog == other.dialog.length) {
          other.currentDialog = 0;
          isKunciJalan = false;

          gameRef.showDialog('', Vector2.zero());

          gameRef.itemStage = 2;
          gameRef.overlays.remove('ui_item');
          gameRef.overlays.add('ui_item');
          gameRef.overlays.remove('ui_interaksi');
          if (other.hilangSetelahDialog) {
            other.removeFromParent();
            gameRef.overlays.remove('ui_interaksi');
          }
        } else {
          gameRef.showDialog(
            other.dialog[other.currentDialog],
            Vector2(other.x + 10, other.y - 5),
          );

          other.currentDialog++;
        }

        _isInteraksiSelesai = false;

        await Future.delayed(const Duration(seconds: 1));

        _isInteraksiSelesai = true;
        _isInteraksi = false;
      }
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Hantu || other is Item) {
      _dekatDenganInteraksi = false;
      _isInteraksi = false;
    }
    super.onCollisionEnd(other);
  }
}

class LiliAnimation extends SpriteAnimationComponent {
  late SpriteAnimation _animIdleAtas;
  late SpriteAnimation _animIdleKanan;
  late SpriteAnimation _animIdleBawah;
  late SpriteAnimation _animIdleKiri;
  late SpriteAnimation _animLariAtas;
  late SpriteAnimation _animLariKanan;
  late SpriteAnimation _animLariBawah;
  late SpriteAnimation _animLariKiri;
  // late SpriteAnimation animAttack;

  @override
  Future<void>? onLoad() async {
    List<String> spritesCount = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
    ];

    // Animasi Idle Atas
    final idleAtasSprites =
        spritesCount.map((i) => Sprite.load('lili/idle/atas/$i.png'));

    _animIdleAtas = SpriteAnimation.spriteList(
      await Future.wait(idleAtasSprites),
      stepTime: 0.1,
    );

    // Animasi Idle Atas
    final idleKananSprites =
        spritesCount.map((i) => Sprite.load('lili/idle/kanan/$i.png'));

    _animIdleKanan = SpriteAnimation.spriteList(
      await Future.wait(idleKananSprites),
      stepTime: 0.1,
    );

    // Animasi Idle Atas
    final idleBawahSprites =
        spritesCount.map((i) => Sprite.load('lili/idle/bawah/$i.png'));

    _animIdleBawah = SpriteAnimation.spriteList(
      await Future.wait(idleBawahSprites),
      stepTime: 0.1,
    );

    // Animasi Idle Atas
    final idleKiriSprites =
        spritesCount.map((i) => Sprite.load('lili/idle/kiri/$i.png'));

    _animIdleKiri = SpriteAnimation.spriteList(
      await Future.wait(idleKiriSprites),
      stepTime: 0.1,
    );

    // Animasi Lari Atas
    final lariAtasSprites =
        spritesCount.map((i) => Sprite.load('lili/lari/atas/$i.png'));

    _animLariAtas = SpriteAnimation.spriteList(
      await Future.wait(lariAtasSprites),
      stepTime: 0.1,
    );

    // Animasi Lari Atas
    final lariKananSprites =
        spritesCount.map((i) => Sprite.load('lili/lari/kanan/$i.png'));

    _animLariKanan = SpriteAnimation.spriteList(
      await Future.wait(lariKananSprites),
      stepTime: 0.1,
    );

    // Animasi Lari Atas
    final lariBawahSprites =
        spritesCount.map((i) => Sprite.load('lili/lari/bawah/$i.png'));

    _animLariBawah = SpriteAnimation.spriteList(
      await Future.wait(lariBawahSprites),
      stepTime: 0.1,
    );

    // Animasi Lari Atas
    final lariKiriSprites =
        spritesCount.map((i) => Sprite.load('lili/lari/kiri/$i.png'));

    _animLariKiri = SpriteAnimation.spriteList(
      await Future.wait(lariKiriSprites),
      stepTime: 0.1,
    );

    anchor = Anchor.center;
    position = Vector2(8, 10);

    animation = _animIdleKiri;

    size = Vector2.all(16);

    return super.onLoad();
  }

  changeAnimation(int animationType, int direction) async {
    if (animationType == 0) {
      if (direction == 1) {
        animation = _animIdleAtas;
      } else if (direction == 2) {
        animation = _animIdleKanan;
      } else if (direction == 3) {
        animation = _animIdleBawah;
      } else if (direction == 4) {
        animation = _animIdleKiri;
      }
    } else if (animationType == 1) {
      if (direction == 1) {
        animation = _animLariAtas;
      } else if (direction == 2) {
        animation = _animLariKanan;
      } else if (direction == 3) {
        animation = _animLariBawah;
      } else if (direction == 4) {
        animation = _animLariKiri;
      }
    }
    //  else if (animationType == 2) {
    //   SpriteAnimation temp = animAttack.clone();

    //   size = Vector2(168, 32);
    //   animation = animAttack;

    //   Future.delayed(
    //     const Duration(milliseconds: 400),
    //     () => add(MyWitchAttackRange()),
    //   );

    //   await animation!.completed;

    //   animAttack = temp;
    //   size = Vector2.all(16);
    //   animation = _animIdle;
    // }
  }
}
