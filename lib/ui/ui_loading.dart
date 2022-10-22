import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
