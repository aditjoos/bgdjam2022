import 'package:bgdjam/menu.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

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
  int currentState = 0;

  final TextStyle _textStyle = const TextStyle(
    fontSize: 24,
  );

  List<Widget> _openingUI = [];

  @override
  initState() {
    _openingUI = [
      Text(
        'Permainan ini dibuat untuk\nberpartisipasi dalam event BGDJam 2022.',
        style: _textStyle,
        textAlign: TextAlign.center,
      ),
      Text(
        'Sebuah kisah singkat oleh aditjoos.',
        style: _textStyle,
        textAlign: TextAlign.center,
      ),
      const Text(
        'Buana Puaka & Kuncup Bunga Lili',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    ];

    _startAnimation();

    super.initState();
  }

  CrossFadeState crossFadeState = CrossFadeState.showSecond;

  void _startAnimation() async {
    for (var i = currentState; i < _openingUI.length; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        currentState = i;
        crossFadeState = CrossFadeState.showSecond;
      });

      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        currentState = i;
        crossFadeState = CrossFadeState.showFirst;
      });
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => const MyMenu()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedCrossFade(
        firstChild: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
        ),
        secondChild: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: _openingUI[currentState],
          ),
        ),
        crossFadeState: crossFadeState,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }
}
