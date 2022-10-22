import 'package:bgdjam/cinematic.dart';
import 'package:bgdjam/game_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyMenu extends StatefulWidget {
  const MyMenu({super.key});

  @override
  State<MyMenu> createState() => _MyMenuState();
}

class _MyMenuState extends State<MyMenu> {
  bool checkLevel0() {
    return (prefs.getInt('currentLevel') ?? 0) == 0;
  }

  late SharedPreferences prefs;

  @override
  void initState() {
    _initSharedPreferences();

    super.initState();
  }

  void _initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/arts/menu.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 800,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.white],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(120),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MyMenuButton(
                    text: 'Mulai',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            return checkLevel0()
                                ? const MyCinematicPage()
                                : const MyGamePage();
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 34),
                  MyMenuButton(
                    text: 'Credit',
                    onTap: () {},
                  ),
                  const SizedBox(height: 34),
                  MyMenuButton(
                    text: 'Keluar',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MyMenuButton extends StatelessWidget {
  const MyMenuButton({
    Key? key,
    required String text,
    required VoidCallback onTap,
  })  : _text = text,
        _onTap = onTap,
        super(key: key);

  final String _text;
  final VoidCallback _onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          onTap: _onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 48,
              vertical: 12,
            ),
            child: Text(
              _text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
