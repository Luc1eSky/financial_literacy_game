import 'package:flutter/material.dart';

class FinInfo extends StatelessWidget {
  const FinInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        //minHeight: 200,
        maxHeight: 400,
      ),
      child: Column(
        children: [
          Text('Test'),
          Container(
            color: Colors.lightBlueAccent,
            child: DataTable(
              headingRowHeight: 0.0,
              //columnSpacing: MediaQuery.of(context).size.width / 2,
              dataTextStyle: const TextStyle(fontSize: 25.0),
              border: TableBorder.all(
                width: 2.0,
                color: Colors.black54,
              ),
              columns: const [
                DataColumn(label: Text('label A')),
                DataColumn(label: Text('label B')),
              ],
              rows: const [
                DataRow(cells: [
                  DataCell(Text('CASH')),
                  DataCell(Text('100')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Income')),
                  DataCell(Text('+8')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Expenses')),
                  DataCell(Text('-7')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Net Income')),
                  DataCell(Text('+1')),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
