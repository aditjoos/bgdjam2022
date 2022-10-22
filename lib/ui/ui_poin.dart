import 'package:bgdjam/ui/ui_aksi_keyboard.dart';
import 'package:flutter/material.dart';

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
