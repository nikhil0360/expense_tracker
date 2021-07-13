import 'package:flutter/foundation.dart';

class Transaction {
  String id;
  final String title;
  final double amount;
  final DateTime date;
  final bool isCash;
  final int tag;

  Transaction({
    this.id,
    @required this.title,
    @required this.amount,
    @required this.date,
    @required this.isCash,
    @required this.tag,
  });
}
