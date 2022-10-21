import 'package:bgdjam/game.dart';
import 'package:bgdjam/objects/lili.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class SceneTransition extends PositionComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  SceneTransition({
    required Vector2 position,
    required Vector2 size,
    required String sceneTujuan,
    required int butuhPoinBahagia,
    required int butuhPoinSedih,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  })  : _sceneTujuan = sceneTujuan,
        _butuhPoinBahagia = butuhPoinBahagia,
        _butuhPoinSedih = butuhPoinSedih,
        super(
          position: position,
          size: size,
          scale: scale,
          angle: angle,
          anchor: anchor,
          priority: priority,
        );

  late final String _sceneTujuan;
  late final int _butuhPoinBahagia;
  late final int _butuhPoinSedih;

  @override
  Future<void>? onLoad() async {
    // debugMode = true;

    var rectangleHitbox = RectangleHitbox();
    rectangleHitbox.collisionType = CollisionType.passive;
    add(rectangleHitbox);

    return super.onLoad();
  }

  @override
  void onCollision(
      Set<Vector2> intersectionPoints, PositionComponent other) async {
    if (other is Lili &&
        gameRef.getPoinBahagia >= _butuhPoinBahagia &&
        gameRef.getPoinSedih >= _butuhPoinSedih) {
      gameRef.loadScene(_sceneTujuan);
    } else {
      gameRef.butuhPoinBahagia = _butuhPoinBahagia;
      gameRef.butuhPoinSedih = _butuhPoinSedih;
      gameRef.overlays.add('ui_transition_butuh_poin');
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Lili && isMounted) {
      gameRef.overlays.remove('ui_transition_butuh_poin');
    }
    super.onCollisionEnd(other);
  }
}
