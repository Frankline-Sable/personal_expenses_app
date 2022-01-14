import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses_app/models/transactions.dart';

void main() => runApp(MaterialApp(
      title: 'Personal Expenses',
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ));

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  var _selectedDateTime;
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  List<Transactions> _userTransactions = [
    Transactions('t1', "Bought new shoes", DateTime.now(), 44.23),
    Transactions('t2', "Chicken at KFC", DateTime.now(), 12.46),
    Transactions('t3', "Lazy purchases", DateTime.now(), 28.22)
  ];

  void _addNewTransaction() {
    if (titleController.text == null ||
        amountController.text == null ||
        _selectedDateTime == null) {
      return;
    }
    setState(() {
      _userTransactions.add(Transactions(
          _selectedDateTime.toString(),
          titleController.text,
          _selectedDateTime,
          double.parse(amountController.text)));
    }

    );
   Navigator.of(context).pop();


  }

  void _showNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    decoration:
                        InputDecoration(label: Text('Title of expense')),
                    keyboardType: TextInputType.name,
                    controller: titleController,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                      decoration: InputDecoration(label: Text('Amount used')),
                      keyboardType: TextInputType.number,
                      controller: amountController),
                ),
                Row(
                  children: [
                    Text(_selectedDateTime == null
                        ? 'Date Not Set'
                        : DateFormat.yMMMMEEEEd().format(_selectedDateTime)),
                    TextButton(
                        onPressed: () {
                          _showDateModal();
                        },
                        child: Text("Select DateTime"))
                  ],
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10)),
                    onPressed: () {
                      _addNewTransaction();
                    },
                    child: Text('Submit Transaction'))
              ],
            ),
          );
        });
  }

  void _showDateModal() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(Duration(days: 300)),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDateTime = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personal Expenses"),
        actions: [
          IconButton(
              onPressed: () {
                _showNewTransaction(context);
              },
              icon: Icon(Icons.add))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showNewTransaction(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Card(
                  elevation: 10,
                  margin: EdgeInsets.all(10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Text("This is will be the heading "),
                  ),
                )),
            Container(
              height: 500,
              child: ListView.builder(
                  itemCount: _userTransactions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Card(
                          elevation: 10,
                          margin: EdgeInsets.all(10),
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Text(
                                      "\$ ${_userTransactions[index].amount}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 20),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Text(
                                              _userTransactions[index].title,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),
                                            )),
                                        Text(DateFormat.yMMMMEEEEd().format(
                                            _userTransactions[index].date))
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        ));
                  }),
            )
          ],
        ),
      ),
    );
  }
}
