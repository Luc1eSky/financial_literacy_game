import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/color_palette.dart';
import '../../domain/concepts/loan.dart';
import '../../domain/game_data_notifier.dart';

class LoanContent extends ConsumerWidget {
  const LoanContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AutoSizeGroup loanSizeGroup = AutoSizeGroup();
    List<Loan> loans = ref.watch(gameDataNotifierProvider).loans;

    List<Widget> widgetList = [];
    for (Loan loan in loans) {
      widgetList.add(
        LoanCard(
          loan: loan,
          group: loanSizeGroup,
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            children: widgetList,
          ),
        )
      ],
    );
  }
}

class LoanCard extends StatelessWidget {
  const LoanCard({
    super.key,
    required this.loan,
    required this.group,
  });
  final Loan loan;
  final AutoSizeGroup group;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: AspectRatio(
        aspectRatio: 9.0,
        child: Container(
          decoration: BoxDecoration(
            color: ColorPalette().backgroundContentCard,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(loan.asset.imagePath),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      '\$${loan.asset.price}',
                      maxLines: 1,
                      style: TextStyle(
                        color: ColorPalette().lightText,
                        fontSize: 50.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      '\$${loan.paymentPerPeriod.toStringAsFixed(2)}',
                      maxLines: 1,
                      style: TextStyle(
                        color: ColorPalette().lightText,
                        fontSize: 50.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      '${loan.age} / ${loan.termInPeriods}',
                      maxLines: 1,
                      style: TextStyle(
                        color: ColorPalette().lightText,
                        fontSize: 50.0,
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
}
