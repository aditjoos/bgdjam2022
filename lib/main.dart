import 'package:bgdjam/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1366, 768),
    center: true,
    skipTaskbar: false,
    // fullScreen: true,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buana Puaka & Kuncup Bunga Lili',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

class MyUITransitionButuhPoin extends StatelessWidget {
  const MyUITransitionButuhPoin({
    Key? key,
    required int poinBahagia,
    required int poinSedih,
  })  : _poinBahagia = poinBahagia,
        _poinSedih = poinSedih,
        super(key: key);

  final int _poinBahagia;
  final int _poinSedih;

  final TextStyle textStyle = const TextStyle(
    fontSize: 22,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Poin dibutuhkan untuk membuka lokasi baru:',
                    style: textStyle,
                  ),
                  Row(
                    children: [
                      const FlutterLogo(),
                      const SizedBox(width: 12),
                      Text(
                        'x$_poinBahagia',
                        style: textStyle,
                      ),
                      const SizedBox(width: 20),
                      const FlutterLogo(),
                      const SizedBox(width: 12),
                      Text(
                        'x$_poinSedih',
                        style: textStyle,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}

class MyUIInteraksi extends StatelessWidget {
  const MyUIInteraksi({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            MyUIAksiKeyboard(keyboard: 'X', kalimat: 'Interaksi'),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class MyUIItem extends StatelessWidget {
  const MyUIItem({
    Key? key,
    required int itemStage,
    required String item,
  })  : _itemStage = itemStage,
        _item = item,
        super(key: key);

  final int _itemStage;
  final String _item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_itemStage == 1 ? 'Item dicari' : 'Item dibawa'}: $_item',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class MyUIPoin extends StatelessWidget {
  const MyUIPoin({
    Key? key,
    required int poinBahagia,
    required int poinSedih,
  })  : _poinBahagia = poinBahagia,
        _poinSedih = poinSedih,
        super(key: key);

  final int _poinBahagia;
  final int _poinSedih;

  final TextStyle textStyle = const TextStyle(
    fontSize: 22,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Image.asset(
                    //   'assets/images/object/poin_bahagia.png',
                    //   width: 32,
                    //   height: 32,
                    //   fit: BoxFit.cover,
                    // ),
                    Text(
                      'Poin Bahagia',
                      style: textStyle,
                    ),
                    const SizedBox(width: 12),
                    const FlutterLogo(),
                    const SizedBox(width: 12),
                    Text(
                      'x$_poinBahagia',
                      style: textStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Image.asset(
                    //   'assets/images/object/poin_bahagia.png',
                    //   width: 32,
                    //   height: 32,
                    //   fit: BoxFit.cover,
                    // ),
                    Text(
                      'Poin Sedih',
                      style: textStyle,
                    ),
                    const SizedBox(width: 12),
                    const FlutterLogo(),
                    const SizedBox(width: 12),
                    Text(
                      'x$_poinSedih',
                      style: textStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const MyUIAksiKeyboard(
            keyboard: 'Esc',
            kalimat: 'Istirahat',
          ),
        ],
      ),
    );
  }
}

class MyUILoading extends StatelessWidget {
  const MyUILoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Center(
        child: LoadingAnimationWidget.waveDots(
          color: Colors.white,
          size: 80,
        ),
      ),
    );
  }
}

class MyUIAksiKeyboard extends StatelessWidget {
  const MyUIAksiKeyboard({
    Key? key,
    required String keyboard,
    required String kalimat,
  })  : _keyboard = keyboard,
        _kalimat = kalimat,
        super(key: key);

  final String _keyboard;
  final String _kalimat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: FittedBox(
              child: Text(
                _keyboard,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            _kalimat,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
