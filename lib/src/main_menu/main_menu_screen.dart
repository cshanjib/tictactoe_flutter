// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/main_menu/main_animation.dart';
import 'package:tictactoe/src/play_session/board_lines.dart';
import 'package:tictactoe/src/style/tapered_boarder.dart';
import 'package:tictactoe/src/style/tapered_button.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../games_services/games_services.dart';
import '../settings/settings.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final gamesServicesController = context.watch<GamesServicesController?>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: ResponsiveScreen(
        mainAreaProminence: 0.45,
        topMessageArea: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkResponse(
                onTap: () => GoRouter.of(context).go('/settings'),
                child: Image.asset('assets/images/settings.png',
                    color: palette.text))
          ],
        ),
        squarishMainArea: Transform.rotate(angle: 0.02, child: MainAnimation()),
        rectangularMenuArea: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TaperedButton(
                  label: 'Play',
                  onPressed: () {
                    audioController.playSfx(SfxType.buttonTap);
                    GoRouter.of(context).go('/play/single');
                  }),
              _gap,
              TaperedButton(
                  label: "Versus",
                  reverse: true,
                  onPressed: () {
                    audioController.playSfx(SfxType.buttonTap);
                    GoRouter.of(context).go('/play/vs');
                  }),
              _gap,
              if (gamesServicesController != null) ...[
                _hideUntilReady(
                  ready: gamesServicesController.signedIn,
                  child: TaperedButton(
                    onPressed: () => gamesServicesController.showAchievements(),
                    label: "Achievements",
                  ),
                ),
                _gap,
                _hideUntilReady(
                  ready: gamesServicesController.signedIn,
                  child: TaperedButton(
                    onPressed: () => gamesServicesController.showLeaderboard(),
                    label: "Leaderboard",
                  ),
                ),
                _gap,
              ],
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: ValueListenableBuilder<bool>(
                  valueListenable: settingsController.muted,
                  builder: (context, muted, child) {
                    return IconButton(
                      color: palette.text,
                      onPressed: () => settingsController.toggleMuted(),
                      icon: Icon(muted ? Icons.volume_off : Icons.volume_up),
                    );
                  },
                ),
              ),
              _gap,
              Text(
                'Music by Mr Smith',
                style: TextStyle(color: palette.text),
              ),
              _gap,
            ],
          ),
        ),
      ),
    );
  }

  /// Prevents the game from showing game-services-related menu items
  /// until we're sure the player is signed in.
  ///
  /// This normally happens immediately after game start, so players will not
  /// see any flash. The exception is folks who decline to use Game Center
  /// or Google Play Game Services, or who haven't yet set it up.
  Widget _hideUntilReady({required Widget child, required Future<bool> ready}) {
    return FutureBuilder<bool>(
      future: ready,
      builder: (context, snapshot) {
        // Use Visibility here so that we have the space for the buttons
        // ready.
        return Visibility(
          visible: snapshot.data ?? false,
          maintainState: true,
          maintainSize: true,
          maintainAnimation: true,
          child: child,
        );
      },
    );
  }

  static const _gap = SizedBox(height: 20);
}
