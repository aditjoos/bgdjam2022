import 'package:bgdjam/ui/ui_aksi_keyboard.dart';
import 'package:flutter/material.dart';

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
