import 'package:bgdjam/game.dart';
import 'package:bgdjam/objects/lili.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Item extends PositionComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  final double _x;
  final double _y;

  Item({
    required double x,
    required double y,
    required Vector2 size,
    required this.dialog,
    required this.hilangSetelahDialog,
    required this.namaItem,
    required this.itemOrigin,
    required this.assets,
  })  : _x = x,
        _y = y,
        super(
          size: size,
        );

  int currentDialog = 0;

  List<String> dialog = [];
  bool hilangSetelahDialog = false;
  String namaItem = '';
  String itemOrigin = '';
  List<String> assets = [];

  @override
  Future<void> onLoad() async {
    // debugMode = true;
    add(ItemAnimation(assets));

    var rectangleHitbox = RectangleHitbox();
    rectangleHitbox.collisionType = CollisionType.passive;
    add(rectangleHitbox);

    x = _x;
    y = _y;

    super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Lili && gameRef.itemStage == 1 && gameRef.item == namaItem) {
      gameRef.overlays.add('ui_interaksi');
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Lili && isMounted) {
      gameRef.overlays.remove('ui_interaksi');
    }

    super.onCollisionEnd(other);
  }
}

class ItemAnimation extends SpriteAnimationComponent {
  ItemAnimation(this._assets);

  final List<String> _assets;

  @override
  Future<void> onLoad() async {
    final sprites = _assets.map((i) => Sprite.load('items/$i.png'));

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
