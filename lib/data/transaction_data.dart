import 'package:expense_tracker/models/Transaction.dart';
import 'package:firebase_database/firebase_database.dart';

class FireBaseData {
  static final databaseReference = FirebaseDatabase.instance.reference();

  static Future<String> write(Transaction tx) async {
    final DatabaseReference newTransaction = databaseReference.push();

    await newTransaction.set({
      'id': newTransaction.key,
      'title': tx.title,
      'amount': tx.amount,
      'date': tx.date.toString(),
      'isCash': tx.isCash,
      'tag': tx.tag,
    });

    return newTransaction.key;
  }

  static Future<void> delete(String refID) async {
    final DatabaseReference deleteRef = databaseReference.child(refID);
    await deleteRef.remove();
  }

  static List<Transaction> read(dynamic snapshot) {
    List<Transaction> data = [];

    Map<dynamic, dynamic> transactions = snapshot.value;

    if (transactions == null) {
      return [];
    }

    transactions.forEach((id, transaction) {
      var tx = Transaction(
        id: transaction['id'],
        amount: transaction['amount'] * 1.0,
        date: DateTime.parse(transaction['date']),
        isCash: transaction['isCash'],
        title: transaction['title'],
        tag: transaction['tag'],
      );

      data.add(tx);
    });
    print('Data : ${snapshot.value}');
    print(data);
    return new List.from(data.reversed);
  }
}
