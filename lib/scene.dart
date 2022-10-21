import 'package:bgdjam/game.dart';
import 'package:bgdjam/objects/hantu.dart';
import 'package:bgdjam/objects/item.dart';
import 'package:bgdjam/objects/lili.dart';
import 'package:bgdjam/objects/scene_transition.dart';
import 'package:bgdjam/objects/tembok.dart';
import 'package:flame/components.dart';
import 'package:flame/rendering.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:tiled/tiled.dart';

class Scene extends PositionComponent with HasGameRef<MyGame> {
  late final String _namaScene;

  Scene(this._namaScene);

  @override
  Future<void>? onLoad() async {
    final TiledComponent loadedScene = await TiledComponent.load(
      _namaScene,
      Vector2.all(16),
    );

    add(loadedScene);

    _spawnActors(loadedScene.tileMap);
    _createWalls(loadedScene.tileMap);

    if (_namaScene == 'kamar.tmx') {
      decorator = PaintDecorator.tint(Colors.black26);
    }

    return super.onLoad();
  }

  void _spawnActors(RenderableTiledMap tileMap) {
    final spawnPointsLayer = tileMap.getLayer<ObjectGroup>('SpawnPoints');

    for (final object in spawnPointsLayer!.objects) {
      switch (object.name) {
        case 'hantu':
          int spesialLevel = getValueInteger(object, 'SpesialLevel');
          String namaHantu = getValueString(object, 'NamaHantu');

          if (spesialLevel == 0 || spesialLevel == gameRef.currentLevel) {
            add(Hantu(
                x: object.x,
                y: object.y,
                size: Vector2.all(16),
                dialogNormal: getValueString(object, 'DialogNormal').split('>'),
                dialogKedua: getValueString(object, 'DialogKedua').split('>'),
                namaHantu: namaHantu,
                item: getValueString(object, 'Item'),
                itemAda: getValueBool(object, 'ItemAda'),
                dialogAda: getValueBool(object, 'DialogAda'),
                poinBahagia: getValueInteger(object, 'PoinBahagia'),
                poinSedih: getValueInteger(object, 'PoinSedih'),
                spesialLevel: spesialLevel,
                interaksiSelesai: gameRef.cekSudahInteraksi(namaHantu)));
          }

          break;

        case 'transition':
          add(SceneTransition(
            position: Vector2(object.x, object.y),
            size: Vector2(object.width, object.height),
            sceneTujuan: getValueString(object, 'SceneTujuan'),
            butuhPoinBahagia: getValueInteger(object, 'ButuhPoinBahagia'),
            butuhPoinSedih: getValueInteger(object, 'ButuhPoinSedih'),
          ));

          break;

        case 'item':
          String itemOrigin = getValueString(object, 'ItemOrigin');

          if (!gameRef.cekSudahInteraksi(itemOrigin)) {
            add(Item(
              x: object.x,
              y: object.y,
              size: Vector2.all(16),
              assets: getValueString(object, 'Assets').split('>'),
              dialog: getValueString(object, 'Dialog').split('>'),
              hilangSetelahDialog: getValueBool(object, 'HilangSetelahDialog'),
              namaItem: getValueString(object, 'NamaItem'),
              itemOrigin: itemOrigin,
            ));
          }

          break;

        case 'spawn':
          var lili = Lili(
            x: object.x + 16,
            y: object.y + 16,
            size: Vector2.all(16),
          );
          gameRef.camera.followComponent(lili);
          add(lili);

          break;

        default:
      }
    }
  }

  String getValueString(TiledObject object, String name) {
    return object.properties
        .firstWhere((element) => element.name == name)
        .value;
  }

  int getValueInteger(TiledObject object, String name) {
    return int.parse(
        object.properties.firstWhere((element) => element.name == name).value);
  }

  bool getValueBool(TiledObject object, String name) {
    return object.properties
            .firstWhere((element) => element.name == name)
            .value ==
        'true';
  }

  void _createWalls(RenderableTiledMap tileMap) {
    final wallsLayer = tileMap.getLayer<ObjectGroup>('Walls');

    for (final wallObject in wallsLayer!.objects) {
      final Tembok wall = Tembok(
        vertices: wallObject.polygon.map((e) => Vector2(e.x, e.y)).toList(),
        position: Vector2(wallObject.x, wallObject.y),
        size: Vector2(wallObject.width, wallObject.height),
      );

      add(wall);
    }
  }
}
