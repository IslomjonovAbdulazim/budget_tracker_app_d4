import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final sumController = TextEditingController();
  final descController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool isBorrowed = true;
  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isBorrowed ? Colors.green : Colors.red,
        title: Text(isBorrowed ? "Borrow" : "Debt"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: key,
            child: Center(
              child: Column(
                children: [
                  // Borrow/Debt Button
                  CupertinoButton(
                    color: isBorrowed ? Colors.green : Colors.red,
                    onPressed: () {
                      if (isBorrowed == true) {
                        isBorrowed = false;
                      } else if (isBorrowed == false) {
                        isBorrowed = true;
                      }
                      setState(() {});
                    },
                    child: Center(child: Text(isBorrowed ? "Borrow" : "Debt")),
                  ),

                  // Select Date
                  SizedBox(height: 10),
                  CupertinoButton(
                    color: Colors.yellow,
                    onPressed: () async {
                      final result = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now().subtract(Duration(days: 100)),
                        lastDate: DateTime.now().add(Duration(days: 3)),
                        currentDate: selectedDate,
                      );
                      selectedDate = result ?? selectedDate;
                      setState(() {});
                    },
                    child: Center(
                      child: Text(
                        "Date: ${DateFormat.yMMMMd().format(selectedDate)}",
                      ),
                    ),
                  ),

                  // Phone Number Text Field

                  // Name Text Field

                  // Desc Text Field

                  // Create Button
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
