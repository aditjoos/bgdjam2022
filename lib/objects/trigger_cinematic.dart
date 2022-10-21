import 'package:bgdjam/game.dart';
import 'package:bgdjam/objects/lili.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class TriggerCinematic extends PositionComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  final double _x;
  final double _y;

  TriggerCinematic({
    required double x,
    required double y,
    required Vector2 size,
    required this.spesialLevel,
  })  : _x = x,
        _y = y,
        super(
          size: size,
        );

  int spesialLevel = 0;

  @override
  Future<void> onLoad() async {
    var rectangleHitbox = RectangleHitbox();
    rectangleHitbox.collisionType = CollisionType.passive;
    add(rectangleHitbox);

    x = _x;
    y = _y;

    super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Lili) {
      gameRef.startCinematic();
    }

    super.onCollision(intersectionPoints, other);
  }
}
