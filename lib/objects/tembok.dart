import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Tembok extends PositionComponent with CollisionCallbacks {
  Tembok({
    required List<Vector2> vertices,
    required Vector2 position,
    required Vector2 size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  })  : _vertices = vertices,
        super(
          position: position,
          size: size,
          scale: scale,
          angle: angle,
          anchor: anchor,
          priority: priority,
        );

  late final List<Vector2> _vertices;

  @override
  Future<void>? onLoad() async {
    // debugMode = true;

    var rectangleHitbox = PolygonHitbox(_vertices);
    rectangleHitbox.collisionType = CollisionType.passive;
    add(rectangleHitbox);

    return super.onLoad();
  }
}
