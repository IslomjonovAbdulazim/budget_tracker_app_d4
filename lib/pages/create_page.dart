import 'package:budget_tracker_app_d4/models/debt_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final sumFocus = FocusNode();
  final nameFocus = FocusNode();
  final phoneFocus = FocusNode();
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
      resizeToAvoidBottomInset: false,
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
                    child: Center(
                        child: Text(isBorrowed ? "Qarz Bermoq" : "Qarz Olmoq")),
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
                  SizedBox(height: 10),
                  TextFormField(
                    controller: sumController,
                    focusNode: sumFocus,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    onTapOutside: (value) => sumFocus.unfocus(),
                    validator: (value) {
                      if (value == null) return null;
                      final number = int.tryParse(value);
                      if (number == null) {
                        return "To'g'ri Formatda Son Yozing";
                      }
                      if (number < 1 || number > 10000000000) {
                        return "Chegaradan tashqari son";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Summa",
                      counter: SizedBox(),
                    ),
                  ),

                  // Phone Number Text Field
                  SizedBox(height: 10),
                  TextFormField(
                    controller: phoneController,
                    focusNode: phoneFocus,
                    inputFormatters: [mask],
                    keyboardType: TextInputType.number,
                    onTapOutside: (value) => phoneFocus.unfocus(),
                    validator: (value) {
                      if (value == null) return null;
                      final res = mask.unmaskText(value);
                      if (res.length != 9) {
                        return "Telefon Raqam Kiriting";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Telefon Raqam",
                    ),
                  ),

                  // Name Text Field
                  SizedBox(height: 10),
                  TextFormField(
                    controller: nameController,
                    focusNode: nameFocus,
                    onTapOutside: (value) => nameFocus.unfocus(),
                    validator: (value) {
                      if (value == null) return null;
                      if (value.trim().length < 2) {
                        return "Izoh kiritilsin";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Izoh",
                    ),
                  ),

                  // Create Button
                  Spacer(),
                  CupertinoButton(
                    color: Colors.yellow,
                    onPressed: () async {
                      if (key.currentState!.validate()) {
                        final sum = sumController.text.trim();
                        final phone = phoneController.text.trim();
                        final name = nameController.text.trim();
                        final phoneInt = int.tryParse(mask.unmaskText(phone)) ?? 0;
                        final model = DebtModel(
                          sum: int.tryParse(sum) ?? 0,
                          desc: "",
                          name: name,
                          phoneNumber: phoneInt,
                          createdAt: DateTime.now(),
                          date: selectedDate,
                          isBorrowed: isBorrowed,
                        );
                        await createDebt(model);
                        Get.back();
                      }
                    },
                    child: Center(child: Text("Save")),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
