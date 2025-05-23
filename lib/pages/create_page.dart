import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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

  final mask = MaskTextInputFormatter(
    mask: "(##) ###-##-##",
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isBorrowed ? Colors.green : Colors.red,
        title: Text(isBorrowed ? "Qarz Bermoq" : "Qarz Olmoq"),
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
                    child: Center(child: Text(isBorrowed ? "Qarz Bermoq" : "Qarz Olmoq")),
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
                        "Sana: ${DateFormat.yMMMMd().format(selectedDate)}",
                      ),
                    ),
                  ),

                  // Sum Text Field

                  // Phone Number Text Field
                  SizedBox(height: 10),
                  TextFormField(
                    controller: phoneController,
                    inputFormatters: [mask],
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null) return null;
                      final res = mask.unmaskText(value);
                      if (res.isEmpty) return null;
                      if (res.length != 9) {
                        return "Telefon Raqam Kiriting";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Telefon Raqam",
                    ),
                  ),

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
