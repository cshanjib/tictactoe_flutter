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

    return Scaffold(
      backgroundColor: palette.text,
      body: ResponsiveScreen(
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
                style: TextStyle(fontFamily: 'Permanent Marker', fontSize: 50),
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
        rectangularMenuArea: InkResponse(
          onTap: () {
            GoRouter.of(context).go(
                '/play/${setting.isAiPlaying ? 'single' : 'vs'}/session/${setting.gameId}',
                extra: setting);
          },
          child: Image.asset(
            'assets/images/restart.png',
          ),
        ),
      ),
    );
  }
}
