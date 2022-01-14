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
  double get totalSpending{
    return groupedTransactionsValues.fold(0.0, (sum,item){
      return sum + (item['amount'] as double);
    });
  }
  List<Transactions> get recentTransactions{
    return _userTransactions.where((tx){
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  List<Map<String, Object>> get groupedTransactionsValues {
    return List.generate(7, (index) {

      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {'day': DateFormat.E().format(weekDay).substring(0,1), 'amount': totalSum};
    }).reversed.toList();
  }
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
    });
    Navigator.of(context).pop();
  }
  void _removeTransaction(String id){
    setState(() {
      _userTransactions.removeWhere((element){
        return element.id==id;
      });
    });
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
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Card(
                  elevation: 10,
                  margin: EdgeInsets.symmetric(vertical: 4,horizontal: 10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: groupedTransactionsValues.map((data){
                        return Container(
                          child: Column(
                              children: [
                                Text("\$"),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  width: 10,
                                  height: 60,
                                  decoration: BoxDecoration(color: Color.fromRGBO(211, 211, 211, 1), borderRadius:BorderRadius.circular(30) ),
                                  child: Stack(
                                    children: [
                                      FractionallySizedBox(
                                        heightFactor:(totalSpending==0.0?0.0:(data['amount'] as double)/totalSpending),
                                        child: Container(
                                          decoration: BoxDecoration(color: Colors.amber, borderRadius:BorderRadius.circular(30) ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Text(data['day'] as String)
                              ],
                            )
                        );
                      }).toList(),


                    )
                  ),
                )),
            Container(
              height: 500,
              child: _userTransactions.length>0?
              ListView.builder(
                  itemCount: _userTransactions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        margin: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                          trailing: IconButton(
                            icon: Icon(Icons.delete), onPressed: () {
                            _removeTransaction(_userTransactions[index].id);
                          },
                          ),
                          leading: CircleAvatar(
                            radius: 30,

                            child: Text(
                              "\$ ${_userTransactions[index].amount}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 14),
                            ),
                          ),
                          title: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                _userTransactions[index].title,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              )),
                          subtitle: Text(DateFormat.yMMMMEEEEd()
                              .format(_userTransactions[index].date)),
                        ));
                  })
              :
                Column(
                  children: [
                    Image.asset(
                        'assets/images/prohibited_48px.png', fit: BoxFit.cover
                    ),
                    SizedBox(height: 10),
                    Text(
                      "No transactions available"
                    )
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}
