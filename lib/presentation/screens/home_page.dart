import 'package:financial_literacy_game/config/constants.dart';
import 'package:flutter/material.dart';

import '../widgets/asset_info.dart';
import '../widgets/fin_info.dart';
import '../widgets/loan_info.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(appTitle)),
      body: Container(
        color: Colors.yellow,
        child: Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 10,
              child: Column(
                children: [
                  const Expanded(flex: 3, child: FinInfo()),
                  const Expanded(flex: 3, child: AssetInfo()),
                  const Expanded(flex: 3, child: LoanInfo()),
                  Expanded(
                      flex: 2, child: Container(color: Colors.purpleAccent)),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
