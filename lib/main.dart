import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double balance = 0;
  TextEditingController expenseController = TextEditingController();

  void addMoney() async {
    // Validate and parse the entered expense
    double enteredExpense = double.tryParse(expenseController.text) ?? 0.0;

    // Update the balance
    setState(() {
      balance += enteredExpense;
    });

    // Save the updated balance to SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('balance', balance);

    // Clear the text field after adding money
    expenseController.clear();
  }

  @override
  void initState() {
    loadMoney();
    super.initState();
  }

  void loadMoney() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      balance = prefs.getDouble('balance') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Expense Tracker'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            color: Colors.white12,
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      TextField(
                        controller: expenseController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your expense',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(onPressed: addMoney, child: Text('Enter'))
                    ],
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Total Expense', style: TextStyle(fontSize: 32)),
                      SizedBox(height: 10),
                      Text('$balance', style: TextStyle(fontSize: 36)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
