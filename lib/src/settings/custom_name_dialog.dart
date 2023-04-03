import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'settings.dart';

void showCustomNameDialog(BuildContext context, {isPlayer1 = true}) {
  showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) => CustomNameDialog(
            animation: animation,
            isPlayer1: isPlayer1,
          ));
}

class CustomNameDialog extends StatefulWidget {
  final Animation<double> animation;
  final bool isPlayer1;

  const CustomNameDialog(
      {required this.animation, this.isPlayer1 = true, super.key});

  @override
  State<CustomNameDialog> createState() => _CustomNameDialogState();
}

class _CustomNameDialogState extends State<CustomNameDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: widget.animation,
        curve: Curves.easeOutCubic,
      ),
      child: SimpleDialog(
        title: const Text('Change name'),
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            maxLength: 12,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              if (widget.isPlayer1) {
                context.read<SettingsController>().setPlayerName1(value);
              } else {
                context.read<SettingsController>().setPlayerName2(value);
              }
            },
            onSubmitted: (value) {
              // Player tapped 'Submit'/'Done' on their keyboard.
              Navigator.pop(context);
            },
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    _controller.text = widget.isPlayer1
        ? context.read<SettingsController>().playerName1.value
        : context.read<SettingsController>().playerName2.value;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
