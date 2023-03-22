import 'package:auto_size_text/auto_size_text.dart';
import 'package:financial_literacy_game/domain/concepts/asset.dart';
import 'package:financial_literacy_game/domain/game_data_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/constants.dart';
import '../../domain/concepts/loan.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //Colors.grey[800],
      //appBar: AppBar(title: const Text(appTitle)),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          bool isPortrait = constraints.maxHeight > constraints.maxWidth;
          return SingleChildScrollView(
            child: constraints.maxWidth > 1000
                ? const LargeLayout()
                : isPortrait
                    ? const SmallPortraitLayout()
                    : const SmallLandscapeLayout(),
          );
        }),
      ),
    );
  }
}

class SmallLandscapeLayout extends StatelessWidget {
  const SmallLandscapeLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: const Center(
        child: Text('SMALL LANDSCAPE SCREEN'),
      ),
    );
  }
}

class SmallPortraitLayout extends ConsumerWidget {
  const SmallPortraitLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int period = ref.watch(gameDataNotifierProvider).period;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SectionCard(
                  title: 'GAME PROGRESS',
                  content: PeriodIndicator(period: period),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Investment Option'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Image.asset(''),

                                Text(cow1.type.name),
                                Image.asset('images/cow.png',
                                    height: 60.0, fit: BoxFit.cover),
                                //imagePath: 'assets/images/cow.png',
                                Text('Price: ${cow1.price}'),
                                Text('Expected Income: ${cow1.income}'),
                                Text('Life Expectancy: ${cow1.lifeSpan}'),
                                //Text('Risk: ${cow1.riskLevel}'),
                                SizedBox(height: 10),
                                Text('Borrow at 25%'),
                                Text('Interest on cash is 5%'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    ref
                                        .read(gameDataNotifierProvider.notifier)
                                        .advance();
                                    Navigator.pop(context);
                                  },
                                  child: Text("don't buy")),
                              TextButton(
                                  onPressed: () {
                                    if (ref
                                            .read(gameDataNotifierProvider
                                                .notifier)
                                            .buyAsset(cow1) ==
                                        false) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Error'),
                                              content: const Text(
                                                  'Not enough cash!'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('okay'),
                                                )
                                              ],
                                            );
                                          });
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text('pay cash')),
                              TextButton(
                                  onPressed: () {
                                    ref
                                        .read(gameDataNotifierProvider.notifier)
                                        .loanAsset(loan1, cow1);
                                    Navigator.pop(context);
                                  },
                                  child: Text('borrow')),
                            ],
                          );
                        });
                  },
                  child: Text('NEXT PERIOD'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SectionCard(title: 'OVERVIEW', content: OverviewContent()),
          const SizedBox(height: 10),
          SectionCard(title: 'PERSONAL', content: PersonalContent()),
          const SizedBox(height: 10),
          SectionCard(title: 'ASSETS', content: AssetContent()),
          const SizedBox(height: 10),
          SectionCard(title: 'LOANS', content: LoanContent()),
        ],
      ),
    );
  }
}

class PeriodIndicator extends StatelessWidget {
  const PeriodIndicator({
    super.key,
    required this.period,
  });

  final int period;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          Positioned(
            top: -1.0,
            child: Container(
              height: 12,
              // TODO: REPLACE 50 WITH MAX PERIODS
              width: constraints.maxWidth * ((period + 1) / maxPeriod),
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.content,
  });
  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(22.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                //fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            content,
          ],
        ),
      ),
    );
  }
}

class OverviewContent extends ConsumerWidget {
  const OverviewContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AutoSizeGroup valueSizeGroup = AutoSizeGroup();

    double cash = ref.watch(gameDataNotifierProvider).cash;
    double income =
        ref.watch(gameDataNotifierProvider.notifier).calculateTotalIncome();
    double expenses =
        ref.watch(gameDataNotifierProvider.notifier).calculateTotalExpenses();

    return Row(
      children: [
        Expanded(
          child: ContentCard(
            content: OverviewTileContent(
                title: 'Cash', value: cash, group: valueSizeGroup),
          ),
        ),
        const SizedBox(width: 7.0),
        Expanded(
          child: ContentCard(
            content: OverviewTileContent(
                title: 'Income', value: income, group: valueSizeGroup),
          ),
        ),
        const SizedBox(width: 7.0),
        Expanded(
          child: ContentCard(
            content: OverviewTileContent(
                title: 'Expenses', value: -expenses, group: valueSizeGroup),
          ),
        ),
      ],
    );
  }
}

class PersonalContent extends ConsumerWidget {
  const PersonalContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: ContentCard(
            aspectRatio: 5.0,
            content: PersonalTileContent(
              income: ref.watch(gameDataNotifierProvider).personalIncome,
              expenses: ref.watch(gameDataNotifierProvider).personalExpenses,
            ),
          ),
        ),
        //Expanded(child: LoanCard(name: '\$8.50', payment: 6.50, group: valueSizeGroup)),
        SizedBox(width: 7.0),
      ],
    );
  }
}

class PersonalTileContent extends StatelessWidget {
  const PersonalTileContent({
    super.key,
    required this.income,
    required this.expenses,
  });

  final double income;
  final double expenses;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: AutoSizeText(
                    '\$$income',
                    style: TextStyle(
                      color: Colors.grey[200],
                      fontSize: 50.0,
                    ),
                  ),
                ),
                Expanded(
                  child: AutoSizeText(
                    'income',
                    maxLines: 1,
                    minFontSize: 2,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 50.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: AutoSizeText(
                    '-\$$expenses',
                    style: TextStyle(
                      color: Colors.grey[200],
                      fontSize: 50.0,
                    ),
                  ),
                ),
                Expanded(
                  child: AutoSizeText(
                    'expenses',
                    maxLines: 1,
                    minFontSize: 2,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 50.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: AutoSizeText(
              '\$${income - expenses}',
              style: TextStyle(
                color: Colors.grey[200],
                fontSize: 50.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AssetContent extends ConsumerWidget {
  const AssetContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AutoSizeGroup valueSizeGroup = AutoSizeGroup();

    int cows = ref.watch(gameDataNotifierProvider).cows;
    int chickens = ref.watch(gameDataNotifierProvider).chickens;
    int goats = ref.watch(gameDataNotifierProvider).goats;

    double cowIncome = ref
        .watch(gameDataNotifierProvider.notifier)
        .calculateIncome(AssetType.cow);
    double chickenIncome = ref
        .watch(gameDataNotifierProvider.notifier)
        .calculateIncome(AssetType.chicken);
    double goatIncome = ref
        .watch(gameDataNotifierProvider.notifier)
        .calculateIncome(AssetType.goat);
    return Row(
      children: [
        Expanded(
            child: SmallAssetCard(
          title: 'cow',
          count: cows,
          income: cowIncome,
          group: valueSizeGroup,
          imagePath: 'assets/images/cow.png',
        )),
        const SizedBox(width: 7.0),
        Expanded(
            child: SmallAssetCard(
          title: 'chicken',
          count: chickens,
          income: chickenIncome,
          group: valueSizeGroup,
          imagePath: 'assets/images/chicken.png',
        )),
        const SizedBox(width: 7.0),
        Expanded(
            child: SmallAssetCard(
          title: 'goat',
          count: goats,
          income: goatIncome,
          group: valueSizeGroup,
          imagePath: 'assets/images/goat.png',
        )),
      ],
    );
  }
}

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
          amount: loan.loanAmount,
          payment: loan.paymentPerPeriod,
          currentTerm: loan.age,
          maxTerm: loan.termInPeriods,
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
    required this.amount,
    required this.payment,
    required this.currentTerm,
    required this.maxTerm,
    required this.group,
  });
  final double amount;
  final double payment;
  final int currentTerm;
  final int maxTerm;
  final AutoSizeGroup group;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    '\$$amount',
                    maxLines: 1,
                    style: TextStyle(color: Colors.grey[300], fontSize: 50.0),
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    '\$$payment',
                    maxLines: 1,
                    style: TextStyle(color: Colors.grey[300], fontSize: 50.0),
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    '$currentTerm / $maxTerm',
                    maxLines: 1,
                    style: TextStyle(color: Colors.grey[600], fontSize: 50.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SmallAssetCard extends StatelessWidget {
  const SmallAssetCard({
    super.key,
    required this.title,
    required this.count,
    required this.income,
    required this.group,
    required this.imagePath,
  });
  final String title;
  final int count;
  final double income;
  final AutoSizeGroup group;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.7,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(imagePath),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        '${count}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 100.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        ' assets',
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: AutoSizeText(
                          '\$$income',
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 100.0,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        ' / period',
                        minFontSize: 2,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 100.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContentCard extends StatelessWidget {
  const ContentCard({
    super.key,
    required this.content,
    this.aspectRatio = 1.0,
  });
  final Widget content;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: content,
        ),
      ),
    );
  }
}

class OverviewTileContent extends StatelessWidget {
  const OverviewTileContent({
    super.key,
    required this.title,
    required this.value,
    required this.group,
  });

  final String title;
  final double value;
  final AutoSizeGroup group;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 18.0,
            //fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          flex: 5,
          child: Align(
            alignment: Alignment.bottomRight,
            child: AutoSizeText(
              value.isNegative
                  ? '- \$${value.abs().toStringAsFixed(2)}'
                  : '\$${value.abs().toStringAsFixed(2)}',
              maxLines: 1,
              group: group,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 100.0,
                //fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // Expanded(
        //   child: Align(
        //     alignment: Alignment.bottomRight,
        //     child: AutoSizeText(
        //       '+3.20',
        //       style: TextStyle(
        //         color: Colors.grey[300],
        //         fontSize: 100.0,
        //         //fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class LargeLayout extends StatelessWidget {
  const LargeLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: const Center(
        child: Text('LARGE SCREEN'),
      ),
    );
  }
}

class PortraitScreen extends StatelessWidget {
  const PortraitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Container(color: Colors.green)),
        Expanded(child: Container(color: Colors.blue)),
        Expanded(child: Container(color: Colors.white)),
        Expanded(child: Container(color: Colors.purpleAccent)),
      ],
    );
  }
}
