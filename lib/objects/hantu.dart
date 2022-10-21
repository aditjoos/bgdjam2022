import 'package:bgdjam/game.dart';
import 'package:bgdjam/objects/lili.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Hantu extends PositionComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  final double _x;
  final double _y;

  Hantu({
    required double x,
    required double y,
    required Vector2 size,
    required this.dialogNormal,
    required this.dialogKedua,
    required this.namaHantu,
    required this.item,
    required this.itemAda,
    required this.dialogAda,
    required this.poinBahagia,
    required this.poinSedih,
    required this.spesialLevel,
    required this.interaksiSelesai,
  })  : _x = x,
        _y = y,
        super(
          size: size,
        );

  int currentDialog = 0;

  List<String> dialogNormal = [];
  List<String> dialogKedua = [];

  String namaHantu = '';
  String item = '';
  bool itemAda = false;
  bool interaksiSelesai = false;

  bool dialogAda = false;

  int poinBahagia = 0;
  int poinSedih = 0;
  int spesialLevel = 0;

  @override
  Future<void> onLoad() async {
    // debugMode = true;
    add(HantuAnimation());

    var rectangleHitbox = RectangleHitbox();
    rectangleHitbox.collisionType = CollisionType.passive;
    add(rectangleHitbox);

    x = _x;
    y = _y;

    super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Lili &&
        (gameRef.itemStage == 0 ||
            (gameRef.itemStage == 2 && gameRef.item == item))) {
      gameRef.overlays.add('ui_interaksi');
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Lili) {
      gameRef.overlays.remove('ui_interaksi');
    }

    super.onCollisionEnd(other);
  }

  void updatePoin() {
    gameRef.poinBahagia += poinBahagia;
    gameRef.poinSedih += poinSedih;
    gameRef.setPoinBahagia(gameRef.poinBahagia);
    gameRef.setPoinSedih(gameRef.poinSedih);
    gameRef.overlays.remove('ui_poin');
    gameRef.overlays.add('ui_poin');
  }
}

class HantuAnimation extends SpriteAnimationComponent {
  @override
  Future<void> onLoad() async {
    final sprites = [
      '1',
      '2',
      '3',
      '4',
    ].map((i) => Sprite.load('hantu/$i.png'));

    animation = SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: 0.1,
    );

    size = Vector2.all(16);
    x = 8;
    y = 8;

    anchor = Anchor.center;

    super.onLoad();
  }
}
