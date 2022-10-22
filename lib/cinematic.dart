import 'package:bgdjam/game_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCinematicPage extends StatefulWidget {
  const MyCinematicPage({
    super.key,
  });

  @override
  State<MyCinematicPage> createState() => _MyCinematicPageState();
}

class _MyCinematicPageState extends State<MyCinematicPage> {
  List<Map<String, String>> _cinematicList = [];

  int _currentLevel = 0;

  @override
  void initState() {
    initSheredPreferences();

    super.initState();
  }

  bool _isCinematicReady = false;

  late final SharedPreferences prefs;

  void initSheredPreferences() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.getInt('currentLevel') == null) {
      prefs.setInt('currentLevel', 0);
    } else {
      _currentLevel = prefs.getInt('currentLevel') ?? 0;
    }

    setState(() {
      _cinematicList = _getCinematicList(_currentLevel);
      _isCinematicReady = true;
    });
  }

  CrossFadeState _crossFadeState = CrossFadeState.showSecond;

  int _currentCinematicIndex = 0;

  _nextCinematicSlide() async {
    setState(() => _crossFadeState = CrossFadeState.showFirst);
    await Future.delayed(const Duration(milliseconds: 300));
    _currentCinematicIndex++;
    await Future.delayed(const Duration(milliseconds: 300));

    if (_currentCinematicIndex == _cinematicList.length) {
      _currentLevel++;
      prefs.setInt('currentLevel', _currentLevel);

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const MyGamePage()));
    } else {
      setState(() => _crossFadeState = CrossFadeState.showSecond);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedCrossFade(
              firstChild: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black,
              ),
              secondChild: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: _isCinematicReady
                    ? Image.asset(
                        'assets/images/arts/${_cinematicList[_currentCinematicIndex]['art']}',
                        fit: BoxFit.cover,
                      )
                    : Container(),
              ),
              crossFadeState: _crossFadeState,
              duration: const Duration(milliseconds: 300),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
              padding: const EdgeInsets.all(35),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: _isCinematicReady
                        ? Text(
                            _cinematicList[_currentCinematicIndex]['dialog']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                            ),
                          )
                        : Container(),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: Offset(0, 0),
                          spreadRadius: 5,
                        )
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => _nextCinematicSlide(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 34,
                            vertical: 12,
                          ),
                          child: Row(
                            children: const [
                              Text(
                                'Selanjutnya ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.chevron_right)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> _getCinematicList(int level) {
    List<List<Map<String, String>>> cinematicLevelList = [
      [
        {
          'art': '0_0.jpg',
          'dialog': 'alarm berbunyi...',
        },
        {
          'art': '0_1.jpg',
          'dialog': 'klik',
        },
        {
          'art': '0_2.jpg',
          'dialog': 'Lili: ...',
        },
        {
          'art': '0_3.jpg',
          'dialog': 'Lili: Aku harus berangkat ke tempat kerja...',
        },
      ],
    ];

    return cinematicLevelList[level];
  }
}
