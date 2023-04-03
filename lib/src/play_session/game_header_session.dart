import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/game_internals/board_state.dart';
import 'package:tictactoe/src/style/palette.dart';

class GameHeaderSession extends StatelessWidget {
  const GameHeaderSession({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final setting = context.select((BoardState state) => state.setting);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          InkResponse(
              onTap: () => GoRouter.of(context).pop(),
              child: Image.asset(
                'assets/images/back.png',
                color: palette.text,
              )),
          Expanded(
              child: Text(
            setting.isAiPlaying ? "Level ${setting.gameId}" : "Versus Mode",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Permanent Marker',
              fontSize: 26,
              color: palette.redPen,
            ),
          )),
          InkResponse(
              onTap: () => GoRouter.of(context).go('/settings'),
              child: Image.asset(
                'assets/images/settings.png',
                color: palette.text,
              )),
        ],
      ),
    );
  }
}
