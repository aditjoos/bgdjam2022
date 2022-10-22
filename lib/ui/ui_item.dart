import 'package:flutter/material.dart';

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
