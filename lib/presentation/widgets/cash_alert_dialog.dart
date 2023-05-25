import 'package:financial_literacy_game/domain/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CashAlertDialog extends StatelessWidget {
  const CashAlertDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.error.capitalize()),
      content: Text(AppLocalizations.of(context)!.cashAlert.capitalize()),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(AppLocalizations.of(context)!.confirm),
        )
      ],
    );
  }
}
