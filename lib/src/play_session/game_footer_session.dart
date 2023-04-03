import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/game_internals/board_state.dart';
import 'package:tictactoe/src/style/palette.dart';

class GameFooterSession extends StatelessWidget {
  const GameFooterSession({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final hasGameStarted =
        context.select((BoardState state) => state.hasGameStarted);
    return Opacity(
      opacity: hasGameStarted ? 1 : 0,
      child: InkResponse(
          onTap: () {
            context.read<BoardState>().clearBoard();
          },
          child: Column(
            children: [
              Image.asset(
                "assets/images/restart.png",
                color: palette.text,
                width: 80,
              ),
              Text(
                "Restart",
                style: TextStyle(
                    fontFamily: 'Permanent Marker',
                    fontSize: 16,
                    color: palette.redPen),
              )
            ],
          )),
    );
  }
}
