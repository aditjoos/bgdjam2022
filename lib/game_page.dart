import 'package:bgdjam/game.dart';
import 'package:bgdjam/ui/ui_interaksi.dart';
import 'package:bgdjam/ui/ui_item.dart';
import 'package:bgdjam/ui/ui_loading.dart';
import 'package:bgdjam/ui/ui_poin.dart';
import 'package:bgdjam/ui/ui_transition_butuh_poin.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MyGamePage extends StatefulWidget {
  const MyGamePage({super.key});

  @override
  State<MyGamePage> createState() => _MyGamePageState();
}

class _MyGamePageState extends State<MyGamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: MyGame(context),
        overlayBuilderMap: {
          'ui_loading': (BuildContext context, MyGame gameRef) =>
              const MyUILoading(),
          'ui_poin': (BuildContext context, MyGame gameRef) => MyUIPoin(
                poinBahagia: gameRef.poinBahagia,
                poinSedih: gameRef.poinSedih,
              ),
          'ui_item': (BuildContext context, MyGame gameRef) => MyUIItem(
                itemStage: gameRef.itemStage,
                item: gameRef.item,
              ),
          'ui_interaksi': (BuildContext context, MyGame gameRef) =>
              const MyUIInteraksi(),
          'ui_transition_butuh_poin': (BuildContext context, MyGame gameRef) =>
              MyUITransitionButuhPoin(
                poinBahagia: gameRef.butuhPoinBahagia,
                poinSedih: gameRef.butuhPoinSedih,
              ),
        },
      ),
    );
  }
}
