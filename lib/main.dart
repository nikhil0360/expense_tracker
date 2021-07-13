import 'dart:io';

import 'package:expense_tracker/widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for fixing app orientations
import 'package:flutter/cupertino.dart';

import './models/Transaction.dart';
import './widgets/tcard.dart';
import './widgets/chart.dart';

import 'package:firebase_core/firebase_core.dart';

import 'data/transaction_data.dart';
import 'models/Transaction.dart';

Future<void> main() async {
  // locking device orientation
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      home: MyHomePage(),
      // create theme for uniform and easy styling
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.amber,

        // copy the existing theme, and do the following changes for 'bodyText1'
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 16,
              ),
              // body2: TextStyle(
              //   fontWeight: FontWeight.w300,
              //   fontSize: 20,
              // ),
            ),

        // https://www.youtube.com/watch?v=ePLhVrT4au0
        // video for custom textTheme

        // textTheme: TextTheme(
        //   headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        //   headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        //   bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),

        // ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String inputTitle;
  // String inputAmount;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Transaction> transaction = [];

  void deleteTransaction(String id) async {
    setState(() {
      transaction.removeWhere((tx) => tx.id == id);
    });

    await FireBaseData.delete(id);
  }

  void addTransaction(
      String title, double amount, DateTime date, int cash, int tag) async {
    final Transaction tx = Transaction(
      title: title,
      amount: amount,
      date: date,
      isCash: cash == 1 ? true : false,
      tag: tag,
    );

    final id = await FireBaseData.write(tx);

    tx.id = id;
    setState(() {
      transaction.add(tx);
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewTransaction(addTransaction)),
    );

    // showModalBottomSheet(
    //   context: ctx,
    //   builder: (_) {
    //     return NewTransaction(addTransaction);
    //   },
    // );
  }

  List<Transaction> get getRecentTransaction {
    return transaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final appbar = AppBar(
      title: Text('Expense Tracker'),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => startAddNewTransaction(context),
        ),
      ],
    );

    final txListView = Container(
      child: Tcard(transaction, deleteTransaction),
      height: (MediaQuery.of(context).size.height -
              appbar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.7,
    );

    return FutureBuilder(
        future: FireBaseData.databaseReference.once(),
        builder: (context, datasnap) {
          if (datasnap.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          if (datasnap.hasError) {
            return Scaffold(
              body: Center(
                child: Text('An error has occured! try again later'),
              ),
            );
          }

          if (datasnap.hasData) {
            transaction = FireBaseData.read(datasnap.data);
          }

          return Scaffold(
            appBar: appbar,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container(
                    // empty container
                    )
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => startAddNewTransaction(context),
                  ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   width: double.infinity,
                    //   height: 100,
                    //   child: Card(
                    //     color: Theme.of(context).primaryColorLight,
                    //     child: Text('data'),
                    //   ),
                    // ),
                    if (isLandscape)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Show Chart'),
                          Switch(
                            value: _showChart,
                            onChanged: (bool newValue) {
                              setState(() {
                                _showChart = newValue;
                              });
                            },
                          ),
                        ],
                      ),

                    if (!isLandscape)
                      Container(
                        child: Chart(getRecentTransaction),
                        height: (MediaQuery.of(context).size.height -
                                appbar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.3,
                      ),
                    if (!isLandscape) txListView,

                    if (isLandscape)
                      _showChart
                          ? Container(
                              child: Chart(getRecentTransaction),
                              height: (MediaQuery.of(context).size.height -
                                      appbar.preferredSize.height -
                                      MediaQuery.of(context).padding.top) *
                                  0.6,
                            )
                          : txListView,
                  ],
                ),
              ),
            ),
          );
        });
  }
}
