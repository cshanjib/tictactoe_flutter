import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/game_internals/enums.dart';
import 'package:tictactoe/src/game_internals/level_selection_state.dart';
import 'package:tictactoe/src/level_selection/game_map.dart';
import 'package:tictactoe/src/level_selection/map_selection_card.dart';
import 'package:tictactoe/src/main_menu/animate_o.dart';
import 'package:tictactoe/src/main_menu/animate_x.dart';
import 'package:tictactoe/src/style/palette.dart';

class MapSelector extends StatelessWidget {
  const MapSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GameMap _selectedMap =
        context.select((LevelSelectionState state) => state.selectedMap);
    int selectedMatchReq =
        context.select((LevelSelectionState state) => state.matchRequired);
    final palette = context.watch<Palette>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MapSelectionCard(_selectedMap, selectedMatchReq),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(border: Border.all(color: palette.backgroundMain)),
              padding: EdgeInsets.only(left: 10),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<GameMap>(
                  value: _selectedMap,
                  isDense: true,
                  items: gameMapList.map((GameMap value) {
                    return DropdownMenuItem<GameMap>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (_) {
                    context.read<LevelSelectionState>().updateGameMap(_);
                  },
                ),
              ),
            ),
            _MatchSelector()
          ],
        ),

      ],
    );
  }
}

class _MatchSelector extends StatelessWidget {
  const _MatchSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    List<int> matchesRequiredList =
        context.select((LevelSelectionState state) => state.matchesReqList);

    int selectedMatchReq =
        context.select((LevelSelectionState state) => state.matchRequired);
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: palette.backgroundMain)),
          padding: EdgeInsets.only(left: 10),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isDense: true,
              value: selectedMatchReq,
              items: matchesRequiredList.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString(), ),
                );
              }).toList(),
              onChanged: (_) {
                context.read<LevelSelectionState>().updateMatches(_);
              },
            ),
          ),
        ),
      ],
    );
  }
}
