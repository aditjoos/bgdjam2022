import 'package:flutter/material.dart';

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
