import 'package:expense_tracker/models/expense_model.dart';
import 'package:flutter/material.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpenseScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  final _formKey = GlobalKey<FormState>();

  void showDatepicker() async {
    final pickedDate = await showDatePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
        initialDate: _selectedDate == null? DateTime.now() : _selectedDate
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });

      print("Selected Date: $pickedDate");
    }
  }

  void submitForm() {

    if((_formKey.currentState?.validate() ?? false) && _selectedDate!=null) {
      final title =_titleController.text;
      final amount = double.parse(_amountController.text);
      //print("Title: $title, Amount: $amount, Date: $_selectedDate");

      //final newExpense = {"title": title, "amount": amount, "date": _selectedDate};
      final newExpense = ExpenseModel(title: title, amount: amount, date: _selectedDate);
      Navigator.pop(context, newExpense);
    }
    final title = _titleController.text;
    final amount = double.parse(_amountController.text);

    print("Title: $title \nAmount: $amount \nDate: $_selectedDate");
  }

  void resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _amountController.clear();
    setState(() {
      _selectedDate = null;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Expense")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Title is required";
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                controller: _amountController,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Amount is required";
                  if (double.tryParse(value) == null) return "Enter Number value";
                  return null;
                },
              ),
              Text(
                  _selectedDate==null
                      ? "No Date choosen"
                      : "Picked Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
              ),
              TextButton(
                onPressed: () => showDatepicker(),
                child: Text("Select Date"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => submitForm(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(15)
                        )
                    ),
                    child: Text("Add Expense"),
                  ),
                  SizedBox(width: 25.0,),
                  ElevatedButton(
                    onPressed: () => resetForm(),
                    child: Text(
                        "Reset"
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(15)
                        )
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}