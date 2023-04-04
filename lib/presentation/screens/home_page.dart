import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:financial_literacy_game/domain/concepts/asset.dart';
import 'package:financial_literacy_game/domain/game_data_notifier.dart';
import 'package:financial_literacy_game/domain/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/constants.dart';
import '../../domain/concepts/level.dart';
import '../../domain/concepts/loan.dart';
import '../../domain/entities/assets.dart';
import '../../domain/entities/levels.dart';

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
    int levelId = ref.watch(gameDataNotifierProvider).levelId;
    String nextLevelCash;
    if (levelId + 1 < levels.length) {
      nextLevelCash = '(next @ \$${levels[levelId + 1].requiredCash})';
    } else {
      nextLevelCash = '';
    }
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SectionCard(
                  title:
                      'LEVEL ${levelId + 1} / ${levels.length}    $nextLevelCash',
                  content: LevelIndicator(levelId: levelId),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: NextPeriodButton(),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const SectionCard(title: 'OVERVIEW', content: OverviewContent()),
          const SizedBox(height: 10),
          const SectionCard(title: 'PERSONAL', content: PersonalContent()),
          const SizedBox(height: 10),
          const SectionCard(title: 'ASSETS', content: AssetContent()),
          const SizedBox(height: 10),
          const SectionCard(title: 'LOANS', content: LoanContent()),
        ],
      ),
    );
  }
}

class AssetCarousel extends StatelessWidget {
  final List<Asset> assets;
  final AutoSizeGroup textGroup;
  final Function changingIndex;
  const AssetCarousel({
    Key? key,
    required this.assets,
    required this.textGroup,
    required this.changingIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // build widget to display from asset
    List<Widget> widgetList = [];
    for (Asset asset in assets) {
      widgetList.add(
        LayoutBuilder(builder: (context, constraints) {
          return Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        '${asset.numberOfAnimals} x ${asset.type.name}',
                        style: TextStyle(
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                      flex: 8,
                      child: Align(
                          alignment: Alignment.center,
                          child:
                              Image.asset(asset.imagePath, fit: BoxFit.cover))),
                  const Spacer(),
                  Expanded(
                    flex: 2,
                    child: AutoSizeText(
                      'Price: ${asset.price}',
                      style: TextStyle(
                        fontSize: 100,
                        color: Colors.grey[200],
                      ),
                      group: textGroup,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: AutoSizeText(
                      'Expected Income: ${asset.income}',
                      style: TextStyle(
                        fontSize: 100,
                        color: Colors.grey[200],
                      ),
                      group: textGroup,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: AutoSizeText(
                      'Life Expectancy: ${asset.lifeSpan}',
                      style: TextStyle(
                        fontSize: 100,
                        color: Colors.grey[200],
                      ),
                      group: textGroup,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: AutoSizeText(
                      'Risk Level: ${(asset.riskLevel * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 100,
                        color: Colors.grey[200],
                      ),
                      group: textGroup,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
          aspectRatio: 1.0,
          //viewportFraction: 0.8,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          onPageChanged: (index, reason) {
            changingIndex(index);
          }),
      items: widgetList,
    );
  }
}

class NextPeriodButton extends ConsumerWidget {
  const NextPeriodButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return InvestmentDialog(ref: ref);
            });
      },
      child: const Text('NEXT PERIOD'),
    );
  }
}

class InvestmentDialog extends StatefulWidget {
  final WidgetRef ref;
  const InvestmentDialog({Key? key, required this.ref}) : super(key: key);

  @override
  State<InvestmentDialog> createState() => _InvestmentDialogState();
}

void checkBankruptcy(WidgetRef ref, BuildContext context) {
  if (ref.read(gameDataNotifierProvider).isBankrupt) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 100,
              width: 100,
              color: Colors.red,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  ref.read(gameDataNotifierProvider.notifier).resetGame();
                  Navigator.pop(context);
                },
                child: const Text('RESTART'),
              ),
            ],
          );
        });
  }
}

void checkGameHasEnded(WidgetRef ref, BuildContext context) {
  if (ref.read(gameDataNotifierProvider).gameIsFinished) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 100,
              width: 100,
              color: Colors.green,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  ref.read(gameDataNotifierProvider.notifier).resetGame();
                  Navigator.pop(context);
                },
                child: const Text('RESTART'),
              ),
            ],
          );
        });
  }
}

class _InvestmentDialogState extends State<InvestmentDialog> {
  final AutoSizeGroup textGroup = AutoSizeGroup();
  late List<Asset> levelAssets;
  late Loan levelLoan;
  late Level currentLevel;

  int _selectedIndex = 0;

  @override
  void initState() {
    // get default level data
    Level defaultLevel =
        levels[widget.ref.read(gameDataNotifierProvider).levelId];
    // get a copy with random loan and savings data
    Level randomLevel = defaultLevel.copyWith(
      loan: getRandomLoan(),
      savingsRate: getRandomDouble(
        start: minimumSavingsRate,
        end: maximumSavingsRate,
        steps: stepsSavingsRate,
      ),
    );
    // choose between default and random based on global setting
    currentLevel =
        levelInterestAndSavingsRandomized ? randomLevel : defaultLevel;
    // randomize assets based on level setting
    if (currentLevel.assetsAreRandomized) {
      List<Asset> randomizedAssets = [];
      for (int i = 0; i < currentLevel.assets.length; i++) {
        randomizedAssets.add(getRandomAsset());
      }
      currentLevel = currentLevel.copyWith(assets: randomizedAssets);
    }
    // randomize risk level of default assets
    else {
      List<Asset> assetsWithRandomRisks = [];
      for (Asset asset in currentLevel.assets) {
        assetsWithRandomRisks.add(
          asset.copyWith(
            riskLevel: getRandomDouble(
                start: minimumRiskLevel,
                end: maximumRiskLevel,
                steps: stepsRiskLevel),
          ),
        );
      }
      currentLevel = currentLevel.copyWith(assets: assetsWithRandomRisks);
    }

    levelAssets = currentLevel.assets;
    levelLoan = currentLevel.loan;

    //widget.ref.read(gameDataNotifierProvider.notifier).setCashInterest(currentLevel.savingsRate);
    super.initState();
  }

  void setIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Asset _selectedAsset = levelAssets[_selectedIndex];

    Future<bool> showNotEnoughCash() async {
      return await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Not enough cash!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('okay'),
                )
              ],
            );
          });
    }

    Future<bool> showAnimalDiedWarning(Asset asset) async {
      return await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text('Warning'),
              content: asset.numberOfAnimals > 1
                  ? Text('${asset.type.name}s have died!')
                  : Text('${asset.type.name} has died!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('okay'),
                )
              ],
            );
          });
    }

    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          //insetPadding: EdgeInsets.zero,
          title: const Text(
            'Investment Option',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: min(MediaQuery.of(context).size.width, 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.0,
                  child: AssetCarousel(
                    assets: levelAssets,
                    textGroup: textGroup,
                    changingIndex: setIndex,
                  ),
                ),
                const SizedBox(height: 20),
                AutoSizeText(
                  '• Borrow at ${(levelLoan.interestRate * 100).toStringAsFixed(decimalValuesToDisplay)}% interest / '
                  'year',
                  maxLines: 1,
                  style: const TextStyle(fontSize: 100),
                  group: textGroup,
                ),
                AutoSizeText(
                  '• Interest rate on cash is ${(currentLevel.savingsRate * 100).toStringAsFixed(decimalValuesToDisplay)}% / year',
                  maxLines: 1,
                  style: const TextStyle(fontSize: 100),
                  group: textGroup,
                ),
                Row(
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        'S: \$${(widget.ref.read(gameDataNotifierProvider.notifier).calculateSavingsROI(cashInterest: currentLevel.savingsRate, lifeExpectancy: _selectedAsset.lifeSpan)).toStringAsFixed(2)}',
                        maxLines: 1,
                        style: const TextStyle(fontSize: 100),
                        group: textGroup,
                      ),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        'C: \$${(widget.ref.read(gameDataNotifierProvider.notifier).calculateBuyCashROI(riskLevel: _selectedAsset.riskLevel, expectedIncome: _selectedAsset.income, assetPrice: _selectedAsset.price)).toStringAsFixed(2)}',
                        maxLines: 1,
                        style: const TextStyle(fontSize: 100),
                        group: textGroup,
                      ),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        'B: \$${(widget.ref.read(gameDataNotifierProvider.notifier).calculateBorrowROI(riskLevel: _selectedAsset.riskLevel, expectedIncome: _selectedAsset.income, assetPrice: _selectedAsset.price, interestRate: currentLevel.loan.interestRate)).toStringAsFixed(2)}',
                        maxLines: 1,
                        style: const TextStyle(fontSize: 100),
                        group: textGroup,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  widget.ref
                      .read(gameDataNotifierProvider.notifier)
                      .advance(currentLevel.savingsRate);
                  Navigator.pop(context);
                  checkBankruptcy(widget.ref, context);
                  checkGameHasEnded(widget.ref, context);
                },
                child: const Text("don't buy")),
            TextButton(
                onPressed: () async {
                  if (await widget.ref
                          .read(gameDataNotifierProvider.notifier)
                          .buyAsset(
                              _selectedAsset,
                              showNotEnoughCash,
                              showAnimalDiedWarning,
                              currentLevel.savingsRate) ==
                      true) {
                    if (context.mounted) {
                      Navigator.pop(context);
                      checkGameHasEnded(widget.ref, context);
                    }
                  }
                },
                child: const Text('pay cash')),
            TextButton(
                onPressed: () async {
                  await widget.ref
                      .read(gameDataNotifierProvider.notifier)
                      .loanAsset(levelLoan, _selectedAsset,
                          showAnimalDiedWarning, currentLevel.savingsRate);
                  if (context.mounted) {
                    Navigator.pop(context);
                    checkBankruptcy(widget.ref, context);
                    checkGameHasEnded(widget.ref, context);
                  }
                },
                child: const Text('borrow')),
          ],
        ),
      ),
    );
  }
}

class LevelIndicator extends StatelessWidget {
  const LevelIndicator({
    super.key,
    required this.levelId,
  });

  final int levelId;

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
              width: constraints.maxWidth * (levelId / (levels.length - 1)),
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
              style: const TextStyle(
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
        const SizedBox(width: 7.0),
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
                    style: TextStyle(color: Colors.grey[300], fontSize: 50.0),
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    '\$${loan.paymentPerPeriod}',
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
                    '${loan.age} / ${loan.termInPeriods}',
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
                        '$count',
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
