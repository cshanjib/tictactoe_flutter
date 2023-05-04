import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/audio/audio_controller.dart';
import 'package:tictactoe/src/audio/sounds.dart';
import 'package:tictactoe/src/game_internals/enums.dart';
import 'package:tictactoe/src/game_internals/level_selection_state.dart';
import 'package:tictactoe/src/main_menu/animate_o.dart';
import 'package:tictactoe/src/main_menu/animate_x.dart';
import 'package:tictactoe/src/style/palette.dart';

class OptionSelector extends StatelessWidget {
  final bool isVsMode;
  const OptionSelector({Key? key, this.isVsMode = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerSide =
        context.select((LevelSelectionState state) => state.setting.playerSide);
    final palette = context.watch<Palette>();
    final audioController = context.read<AudioController>();

    return GestureDetector(
      onTap: () {
        audioController.playSfx(SfxType.swishSwish);
        context.read<LevelSelectionState>().togglePlayerOptions();
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Player1",
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'cloudy',
                color: palette.colorOption1),
          ),
          AnimatedRotation(
              duration: Duration(milliseconds: 400),
              turns: playerSide == Side.X ? 0 : 0.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: AnimateX(
                      color: palette.backgroundMain,
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: AnimateO(
                      color: palette.backgroundMain,
                    ),
                  ),
                ],
              )),
          Text(
            isVsMode ?  "Player2" : "Ai",
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'cloudy',
                color: palette.colorOption2),
          ),
        ],
      ),
    );
  }
}
