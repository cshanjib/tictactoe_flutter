// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';
import 'package:tictactoe/src/game_internals/board_setting.dart';
import 'package:tictactoe/src/game_internals/board_state.dart';
import 'package:tictactoe/src/game_internals/enums.dart';
import 'package:tictactoe/src/play_session/play_session_screen_ui.dart';
import 'package:tictactoe/src/settings/settings.dart';

import '../ads/ads_controller.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../in_app_purchase/in_app_purchase.dart';
import '../style/confetti.dart';
import '../style/palette.dart';

class PlaySessionScreen extends StatefulWidget {
  final BoardSetting setting;

  const PlaySessionScreen(this.setting, {super.key});

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  static final _log = Logger('PlaySessionScreen');

  static const _celebrationDuration = Duration(milliseconds: 2000);

  static const _preCelebrationDuration = Duration(milliseconds: 500);

  bool _duringCelebration = false;

  late DateTime _startOfPlay;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          final state = BoardState.new(widget.setting)..initializeBoard();
          state.gameResult.addListener(() => _onGameComplete(state));
          return state;
        }),
      ],
      child: IgnorePointer(
        ignoring: _duringCelebration,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: palette.backgroundPlaySession,
            body: Stack(
              children: [
                PlaySessionScreenUI(),
                SizedBox.expand(
                  child: Visibility(
                    visible: _duringCelebration,
                    child: IgnorePointer(
                      child: Confetti(
                        isStopped: !_duringCelebration,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _startOfPlay = DateTime.now();

    // Preload ad for the win screen.
    final adsRemoved =
        context.read<InAppPurchaseController?>()?.adRemoval.active ?? false;
    if (!adsRemoved) {
      final adsController = context.read<AdsController?>();
      adsController?.preloadAd();
    }
  }

  Future<void> _onGameComplete(BoardState state) async {
    await Future<void>.delayed(_preCelebrationDuration);

    final isGameDraw = state.gameResult.value == Side.NONE;
    if (isGameDraw) {
      GoRouter.of(context).go("/play/vs/won", extra: {
        "message": "Game Finished. It's a draw",
        "setting": widget.setting
      });
    } else {
      if (!mounted) return;

      setState(() {
        _duringCelebration = true;
      });

      final audioController = context.read<AudioController>();
      audioController.playSfx(SfxType.congrats);

      /// Give the player some time to see the celebration animation.
      await Future<void>.delayed(_celebrationDuration);
      if (!mounted) return;

      final _settings = context.read<SettingsController>();
      GoRouter.of(context).go('/play/${widget.setting.isAiPlaying ? 'single':'vs'}/won', extra: {
        "message":
            "${state.isPlayer1Winner ? _settings.playerName.value : widget.setting.isAiPlaying ? "Ai":"player2"} wins",
        "setting": widget.setting
      });
    }
  }
}
