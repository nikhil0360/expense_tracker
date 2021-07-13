import 'package:expense_tracker/data/transaction_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  static const tagsDecoder = {
    1: 'Food',
    2: 'Travelling',
    3: 'Shopping',
    4: 'Groceries',
    5: 'Entertainment',
    6: 'Bills',
    7: 'Others',
  };

  final Function addTransaction;

  NewTransaction(this.addTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime pickedDate;

  void submitData() {
    String titleData = titleController.text;
    double amountData = double.parse(amountController.text);
    int val = _value;
    int tag = _choiceIndex;

    if (titleData.isEmpty ||
        amountData <= 0 ||
        pickedDate == null ||
        tag == null) {
      return;
    }

    // firebase here!
    this.widget.addTransaction(
          titleData,
          amountData,
          pickedDate,
          val,
          tag,
        );

    Navigator.of(context).pop();
  }

  // date picker
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }

      setState(() {
        pickedDate = value;
      });
    });
  }

  int _value = 1;
  void changeValue(int s) {
    setState(() {
      _value = s;
    });
  }

  int _choiceIndex = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new transaction'),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // chips
              Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: NewTransaction.tagsDecoder.entries.map((e) {
                    return FilterChip(
                      label: Text(NewTransaction.tagsDecoder[e.key]),
                      selected: _choiceIndex == e.key,
                      selectedColor: Colors.lightGreen,
                      onSelected: (bool selected) {
                        setState(() {
                          _choiceIndex = selected ? e.key : 0;
                        });
                      },
                      // labelStyle: TextStyle(color: Colors.white),
                    );
                  }).toList()),

              TextField(
                // onChanged: (val) {
                //   inputTitle = val;
                // },
                decoration: InputDecoration(labelText: 'Title'),
                controller: titleController,
                onSubmitted: (_) => submitData(),
              ),
              SizedBox(
                height: 16,
              ),
              TextField(
                // onChanged: (val) {
                //   inputAmount = val;
                // },
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(pickedDate == null
                        ? 'Date not chosen!'
                        : 'Picked Date: ${DateFormat.yMMMd().format(pickedDate)}'),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: _presentDatePicker,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Card(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Paid using'),
                    ActionChip(
                        padding: EdgeInsets.all(8),
                        label: const Text('Bank'),
                        backgroundColor: _value == 0
                            ? Theme.of(context).primaryColorLight
                            : Colors.white,
                        onPressed: () => changeValue(0)),
                    ActionChip(
                        padding: EdgeInsets.all(8),
                        label: const Text('Cash'),
                        backgroundColor: _value == 1
                            ? Theme.of(context).primaryColorLight
                            : Colors.white,
                        onPressed: () => changeValue(1)),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: submitData,
                // print(inputAmount);
                // print(inputTitle);
                // return Transaction(
                //     id: '1',
                //     title: titleController.text,
                //     amount: double.parse(amountController.text),
                //     date: DateTime.now());
                child: Text('Add Transaction'),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
