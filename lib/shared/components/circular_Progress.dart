import 'package:flutter/material.dart';
import 'package:mal/shared/styles/colors.dart';

class CustomCircularProgress extends StatelessWidget {
  final Color ? cColor;
  const CustomCircularProgress({Key? key,this.cColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: cColor?? kYellow,
    );
  }
}
