import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/game_internals/board_state.dart';
import 'package:tictactoe/src/helpers/helper_functions.dart';
import 'package:tictactoe/src/style/palette.dart';

class SimulatorIndicator extends StatelessWidget {
  const SimulatorIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final opponent1 =
        context.select((BoardState state) => state.simulateOpponent1);
    final opponent2 =
        context.select((BoardState state) => state.simulateOpponent2);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Text(
            HelperFunctions.getSimulationOpponentName(opponent1),
            style: TextStyle(color: palette.backgroundMain, fontSize: 6),
          ),
          color: palette.colorOption1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text("vs",
              style: TextStyle(
                  color: palette.text,
                  fontSize: 8,
                  fontWeight: FontWeight.bold)),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Text(HelperFunctions.getSimulationOpponentName(opponent2),
              style: TextStyle(
                  color: palette.backgroundMain,
                  fontSize: 6,
                  fontWeight: FontWeight.bold)),
          color: palette.colorOption2,
        ),
      ],
    );
  }
}
