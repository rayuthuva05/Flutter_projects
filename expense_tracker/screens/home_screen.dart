import 'package:expense_tracker/models/expense_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List<ExpenseModel> expenses=[
  //   ExpenseModel(title: "Groceries", amount: 2280, date: DateTime.now()),
  // ];

  final expensesBox= Hive.box<ExpenseModel>("expenses");

  List<ExpenseModel> get expenses => expensesBox.values.toList();

  final double totalBudget = 5000;
  double get totalExpense => expenses.fold(0.0, (sum,item) => sum+item.amount);

  double get balance => totalBudget- totalExpense;

  void ConfirmDelete(index) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Delete Expense"),
          content: Text("Are you sure you want to delete?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("cancel")
            ),
            ElevatedButton(
              onPressed: () async {
                final expensesBox= Hive.box<ExpenseModel>("expenses");
                await expensesBox.deleteAt(index);
                Navigator.pop(context);
                setState(() {

                });
              },
              child: Text("Yes"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white
              ),
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Expense Tracker")),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final newExpense = await Navigator.pushNamed(
                context,
                "/add-expense"
            ) as ExpenseModel;
            setState(() {
              //expenses.add(newExpense);
              expensesBox.add(newExpense);
            });

            print("newExpense: ${newExpense.title}, ${newExpense.amount}, ${newExpense.date}");
          },
          backgroundColor: Colors.indigoAccent,
          foregroundColor: Colors.white,
          child: Icon(Icons.add)
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Total Expenses: Rs ",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      totalExpense.toStringAsFixed(2),
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 24,
                          color: totalBudget > totalExpense ? Colors.green : Colors.red
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Balance: Rs ",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                      ),
                    ),
                    Text(
                      balance.toStringAsFixed(2),
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 24,
                          color: totalBudget > totalExpense ? Colors.green : Colors.red
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  return ExpenseCard(
                    title: expense.title,
                    date: expense.date,
                    amount: expense.amount,
                    onDelete: () => ConfirmDelete(index),
                  );
                }
            ),
          ),
        ],
      )
    );
  }
}

class ExpenseCard extends StatefulWidget {
  final String title;
  final DateTime? date;
  final double amount;
  final VoidCallback onDelete;

  const ExpenseCard({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.onDelete
  });

  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
  String get formatDate {
    return widget.date == null ? "No date" : DateFormat("MMM d, y").format(widget.date!);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title.length > 10 ? '${widget.title.substring(0,12)}...':widget.title,
                  style: TextStyle(
                      fontSize: widget.title.length >10 ? 14 : 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  formatDate,
                  style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Text(
                "Rs ${widget.amount.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsetsDirectional.only(start: 30),
              child: IconButton(
                  onPressed: widget.onDelete,
                  icon: Icon(Icons.delete_forever_rounded),
                  color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}