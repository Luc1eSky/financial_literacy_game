import 'package:flutter/material.dart';

class AssetInfo extends StatelessWidget {
  const AssetInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: Center(
        child: LayoutBuilder(builder: (context, constraint) {
          double rowHeight = constraint.maxHeight / 3;
          return DataTable(
            dataRowHeight: rowHeight,
            headingRowHeight: rowHeight,
            //columnSpacing: MediaQuery.of(context).size.width / 2,
            headingTextStyle: const TextStyle(fontSize: 35.0),
            dataTextStyle: const TextStyle(fontSize: 35.0),
            border: TableBorder.all(
              width: 2.0,
              color: Colors.black54,
            ),
            columns: const [
              DataColumn(label: Text('CHICKEN')),
              DataColumn(label: Text('COW')),
              DataColumn(label: Text('GOAT')),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('2x')),
                DataCell(Text('5x')),
                DataCell(Text('10x')),
              ]),
              DataRow(cells: [
                DataCell(Text('+8')),
                DataCell(Text('+10')),
                DataCell(Text('+15')),
              ]),
            ],
          );
        }),
      ),
    );
  }
}
