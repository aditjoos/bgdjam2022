import 'package:bgdjam/cinematic.dart';
import 'package:bgdjam/scene.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  final BuildContext _context;

  MyGame(this._context);

  Scene? _sceneSekarang;

  TextComponent? _dialogText;

  int poinBahagia = 0;
  int poinSedih = 0;

  // 0 normal, tidak ada apa-apa
  // 1 mencari item
  // 2 membawa item
  int itemStage = 0;
  String item = '';

  int currentLevel = 0;

  int butuhPoinBahagia = 0;
  int butuhPoinSedih = 0;

  late final SharedPreferences prefs;

  @override
  Future<void>? onLoad() async {
    prefs = await SharedPreferences.getInstance();

    camera.viewport = FixedResolutionViewport(Vector2(854, 480));
    camera.zoom = 3;

    poinBahagia = getPoinBahagia;
    poinSedih = getPoinSedih;
    overlays.add('ui_poin');

    loadScene('kamar.tmx');

    if (prefs.getInt('currentLevel') == null) {
      prefs.setInt('currentLevel', 0);
    } else {
      currentLevel = prefs.getInt('currentLevel') ?? 0;
    }

    return super.onLoad();
  }

  void startCinematic() {
    overlays.add('ui_loading');

    Future.delayed(const Duration(seconds: 2)).then((value) {
      Navigator.pushReplacement(
        _context,
        MaterialPageRoute(
          builder: (_) => const MyCinematicPage(),
        ),
      );
    });
  }

  void showDialog(String kalimat, Vector2 position) {
    if (_dialogText != null) {
      remove(_dialogText!);
    }

    _dialogText = TextComponent(
      text: kalimat,
      position: position,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 8,
          color: Colors.white,
          shadows: [
            Shadow(
              offset: Offset(0, 0),
              color: Colors.black,
              blurRadius: 6,
            ),
          ],
        ),
      ),
      anchor: Anchor.bottomCenter,
    );

    add(_dialogText!);
  }

  void loadScene(String namaScene) {
    _sceneSekarang?.removeFromParent();
    _sceneSekarang = Scene(namaScene);
    add(_sceneSekarang!);

    if (namaScene == 'kamar.tmx') {
      camera.zoom = 6;
    } else {
      camera.zoom = 3;
    }
  }

  void updateLevel() {
    currentLevel++;
    prefs.setInt('currentLevel', currentLevel);
  }

  int get getPoinBahagia => prefs.getInt('poinBahagia') ?? 0;
  int get getPoinSedih => prefs.getInt('poinSedih') ?? 0;

  void setPoinBahagia(int poin) {
    prefs.setInt('poinBahagia', poin);
  }

  void setPoinSedih(int poin) {
    prefs.setInt('poinSedih', poin);
  }

  void setSudahInteraksi(String namaHantu) {
    prefs.setBool(namaHantu, true);
  }

  bool cekSudahInteraksi(String namaHantu) {
    return prefs.getBool(namaHantu) ?? false;
  }
}
