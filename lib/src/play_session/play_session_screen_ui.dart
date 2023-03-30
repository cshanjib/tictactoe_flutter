import 'package:flutter/material.dart';
import 'package:tictactoe/src/play_session/game_footer_session.dart';
import 'package:tictactoe/src/play_session/game_header_session.dart';
import 'package:tictactoe/src/play_session/main_board_session.dart';

class PlaySessionScreenUI extends StatelessWidget {
  const PlaySessionScreenUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GameHeaderSession(),
        Expanded(child: Center(child: MainBoardSession())),
        GameFooterSession()
      ],
    );
  }
}
