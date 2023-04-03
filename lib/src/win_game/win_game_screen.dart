import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/game_internals/board_setting.dart';
import '../ads/ads_controller.dart';
import '../ads/banner_ad_widget.dart';
import '../in_app_purchase/in_app_purchase.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class WinGameScreen extends StatelessWidget {
  final String message;
  final BoardSetting setting;

  const WinGameScreen({
    super.key,
    required this.message,
    required this.setting,
  });

  @override
  Widget build(BuildContext context) {
    final adsControllerAvailable = context.watch<AdsController?>() != null;
    final adsRemoved =
        context.watch<InAppPurchaseController?>()?.adRemoval.active ?? false;
    final palette = context.watch<Palette>();

    const gap = SizedBox(height: 10);

    final _hasWon = message.contains("Win");

    return Scaffold(
      backgroundColor: palette.text,
      body: ResponsiveScreen(
        topMessageArea: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkResponse(
                onTap: () => GoRouter.of(context).pop(),
                child: Icon(
                  Icons.grid_4x4_sharp,
                  size: 40,
                  color: palette.backgroundMain,
                )),
            InkResponse(
                onTap: () => Navigator.popUntil(context, ModalRoute.withName('/')),
                child: Icon(
                  Icons.home,
                  size: 40,
                  color: palette.backgroundMain,
                )),
          ],
        ),
        squarishMainArea: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (adsControllerAvailable && !adsRemoved) ...[
              const Expanded(
                child: Center(
                  child: BannerAdWidget(),
                ),
              ),
            ],
            gap,
            Center(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Cloudy',
                    fontSize: 50,
                    color: _hasWon ? palette.successPen : palette.ink),
              ),
            ),
            // gap,
            // Center(
            //   child: Text(
            //     'Score: ${score.score}\n'
            //     'Time: ${score.formattedTime}',
            //     style: const TextStyle(
            //         fontFamily: 'Permanent Marker', fontSize: 20),
            //   ),
            // ),
          ],
        ),
        rectangularMenuArea: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkResponse(
              onTap: () {
                GoRouter.of(context).go(
                    '/play/${setting.isAiPlaying ? 'single' : 'vs'}/session/${setting.gameId}',
                    extra: setting);
              },
              child: Image.asset(
                'assets/images/restart.png',
                color: palette.backgroundMain,
              ),
            ),
            if (setting.isAiPlaying &&
                setting.gameId != null &&
                setting.gameId! < 9 &&
                _hasWon)
              InkResponse(
                onTap: () {
                  GoRouter.of(context).go(
                      '/play/single/session/${setting.gameId! + 1}',
                      extra: setting.update(gameId: setting.gameId! + 1));
                },
                child: Transform.rotate(
                  angle: pi,
                  child: Image.asset(
                    'assets/images/back.png',
                    fit: BoxFit.fill,
                    width: 100,
                    color: palette.backgroundMain,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
