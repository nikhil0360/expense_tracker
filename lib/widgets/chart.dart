import 'package:flutter/material.dart';
import '../models/Transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;

  Chart(this.recentTransaction);

  List<Map<String, Object>> get chartValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      var totalSum = 0.0;

      for (var i = 0; i < recentTransaction.length; i++) {
        if (recentTransaction[i].date.day == weekDay.day &&
            recentTransaction[i].date.month == weekDay.month &&
            recentTransaction[i].date.year == weekDay.year)
          totalSum += recentTransaction[i].amount;
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalAmount {
    return chartValues.fold(0.0, (sum, element) {
      return sum + element['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: Card(
        elevation: 6,
        color: Theme.of(context).primaryColorLight,
        child: Container(
          padding: EdgeInsets.all(10),
          child: LayoutBuilder(
            builder: (ctx, contraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: chartValues.map((e) {
                  return Container(
                    child: Column(
                      children: [
                        Container(
                          height: contraints.maxHeight * 0.12,
                          child: FittedBox(
                            child: Text('₹' +
                                (e['amount'] as double).toStringAsFixed(0)),
                          ),
                        ),
                        SizedBox(
                          height: contraints.maxHeight * 0.08,
                        ),
                        Container(
                          height: contraints.maxHeight * 0.6,
                          width: 10,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(220, 220, 220, 1),
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              FractionallySizedBox(
                                heightFactor: totalAmount == 0.0
                                    ? 0.0
                                    : (e['amount'] as double) / totalAmount,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColorDark,
                                      border: Border.all(
                                          width: 1, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: contraints.maxHeight * 0.08,
                        ),
                        Container(
                          child: FittedBox(
                              child: Text(
                            e['day'],
                            style: TextStyle(fontSize: 12),
                          )),
                          height: contraints.maxHeight * 0.12,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
