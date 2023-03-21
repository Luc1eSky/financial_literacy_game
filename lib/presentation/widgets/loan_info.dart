import 'package:flutter/material.dart';

class LoanInfo extends StatelessWidget {
  const LoanInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.limeAccent,
      child: Center(
        child: DataTable(
          headingRowHeight: 0.0,
          //columnSpacing: MediaQuery.of(context).size.width / 2,
          headingTextStyle: const TextStyle(fontSize: 25.0),
          dataTextStyle: const TextStyle(fontSize: 25.0),
          border: TableBorder.all(
            width: 2.0,
            color: Colors.black54,
          ),
          columns: const [
            DataColumn(label: Text('Loan')),
            DataColumn(label: Text('Payment')),
            DataColumn(label: Text('Age')),
          ],
          rows: const [
            DataRow(cells: [
              DataCell(Text('Loan A')),
              DataCell(Text('-6.50')),
              DataCell(Text('1/2')),
            ]),
            DataRow(cells: [
              DataCell(Text('Loan B')),
              DataCell(Text('-5.00')),
              DataCell(Text('2/2')),
            ]),
          ],
        ),
      ),
    );
  }
}
