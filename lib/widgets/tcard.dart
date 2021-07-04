import 'package:expense_tracker/widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/Transaction.dart';

class Tcard extends StatelessWidget {
  final List<Transaction> _transaction;
  final Function deleteFunction;

  Tcard(this._transaction, this.deleteFunction);

  @override
  Widget build(BuildContext context) {
    return _transaction.isEmpty
        ? LayoutBuilder(builder: (ctx, contrainsts) {
            return Column(
              children: [
                Text('No Transaction added yet!'),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: contrainsts.maxHeight * 0.25,
                  child: Image.asset(
                    'asset/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          })
        : ListView(
            scrollDirection: Axis.vertical,
            children: _transaction.map((tx) {
              // Instead of this, we can use ListTile widget
              // it has leading, title, subtitle, and trailing widges options
              return Card(
                margin: EdgeInsets.all(8),
                elevation: 3,
                child: Row(
                  children: [
                    Container(
                      width: 90,
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          border: Border.all(
                            width: 2,
                            color: Theme.of(context).primaryColorDark,
                          )),
                      child: FittedBox(
                        child: Text(
                          '\₹${tx.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColorDark),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(
                              tx.title,
                              style: TextStyle(fontSize: 16),
                              // TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Container(
                              padding: EdgeInsets.all(3),
                              child: Text(
                                tx.isCash ? 'Cash' : 'Bank',
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(220, 220, 220, 1),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Container(
                              padding: EdgeInsets.all(3),
                              child: Text(
                                NewTransaction.tagsDecoder[tx.tag],
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(220, 220, 220, 1),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ]),
                          Text(
                            DateFormat.yMMMd().format(tx.date),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: MediaQuery.of(context).size.width > 400
                          ? FlatButton.icon(
                              onPressed: () => deleteFunction(tx.id),
                              icon: Icon(
                                Icons.delete,
                                color: Theme.of(context).primaryColor,
                              ),
                              label: Text('Delete'),
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () => deleteFunction(tx.id),
                            ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
  }
}
