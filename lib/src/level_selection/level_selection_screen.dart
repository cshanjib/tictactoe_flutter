import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/game_internals/board_setting.dart';
import 'package:tictactoe/src/game_internals/level_selection_state.dart';
import 'package:tictactoe/src/level_selection/game_map.dart';
import 'package:tictactoe/src/level_selection/level_selection_card.dart';
import 'package:tictactoe/src/level_selection/map_selection_card.dart';
import 'package:tictactoe/src/level_selection/map_selector.dart';
import 'package:tictactoe/src/level_selection/option_selector.dart';
import '../player_progress/player_progress.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import 'levels.dart';

class LevelSelectionScreen extends StatelessWidget {
  final bool isVsMode;

  const LevelSelectionScreen({super.key, this.isVsMode = false});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final playerProgress = context.watch<PlayerProgress>();

    return ChangeNotifierProvider(
      create: (context) =>
          LevelSelectionState(setting: BoardSetting.defaultBoard()),
      child: Scaffold(
        backgroundColor: palette.text,
        body: ResponsiveScreen(
          squarishMainArea: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Stack(
                  children: [
                    InkResponse(
                        onTap: () => GoRouter.of(context).pop(),
                        child: Image.asset(
                          'assets/images/back.png',
                          color: palette.backgroundMain,
                        )),
                    Center(
                      child: Text(
                        isVsMode ? "Vs Mode" : "Vs AI",
                        style:
                            TextStyle(fontFamily: 'Cloudy', fontSize: 30, color: palette.backgroundMain),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              OptionSelector(isVsMode: isVsMode,),

              Expanded(
                  child: isVsMode
                      ? MapSelector()
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10),
                          itemCount: gameLevels.length,
                          itemBuilder: (context, index) =>
                              LevelSelectionCard(gameLevels[index])))
            ],
          ),

          // rectangularMenuArea: FilledButton(
          //   onPressed: () {
          //     GoRouter.of(context).go('/');
          //   },
          //   child: const Text('Back'),
          // ),
        ),
      ),
    );
  }
}
