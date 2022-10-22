import 'package:flutter/material.dart';

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
