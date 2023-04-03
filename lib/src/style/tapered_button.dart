import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/style/palette.dart';
import 'package:tictactoe/src/style/tapered_boarder.dart';

class TaperedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool reverse;
  const TaperedButton({Key? key, required this.label,  required this.onPressed, this.reverse=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return Material(
        child: InkWell(
          customBorder: TaperedBorder(reverse: reverse),
          onTap: onPressed,
          child: Ink(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: ShapeDecoration(
                shape: TaperedBorder(reverse: reverse, borderColor: palette.text), color: palette.backgroundMain,),
            child: SizedBox(
                width: double.infinity,
                child: Text(
                  label,
                  style: TextStyle(
                      color: palette.text,
                      // fontWeight: FontWeight.bold,
                      fontSize: 30,
                    fontFamily: 'Cloudy'
                  ),
                  textAlign: TextAlign.center,
                )),
          ),
        ));
  }
}
