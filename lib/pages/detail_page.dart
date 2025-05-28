import 'package:budget_tracker_app_d4/models/payment_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/debt_model.dart';

class DetailPage extends StatefulWidget {
  final DebtModel debt;

  const DetailPage({super.key, required this.debt});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final key = GlobalKey<FormState>();
  final noteController = TextEditingController();
  final sumController = TextEditingController();
  final noteFocus = FocusNode();
  final sumFocus = FocusNode();
  List<PaymentModel> payments = [];
  final mask = MaskTextInputFormatter(
    mask: "(##) ###-##-##",
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    payments = await getAllPayments();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final deadline = widget.debt.date.difference(widget.debt.createdAt).inHours;
    final spent = DateTime.now().difference(widget.debt.createdAt).inHours;
    var datePercentage = 1.0;
    if (deadline > 0 && spent >= 0) {
      datePercentage = spent / deadline;
    }
    var sumPercentage = 1.0;
    if (widget.debt.sum > 0) {
      sumPercentage = (widget.debt.sum - widget.debt.left) / widget.debt.sum;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: widget.debt.isBorrowed
            ? Colors.green.shade700
            : Colors.red.shade700,
        centerTitle: true,
        title: Text(
          widget.debt.isBorrowed ? "Berilgan Qarz" : "Olingan Qarz",
        ),
        actions: [
          CupertinoButton(
            onPressed: () async {
              await deleteDebt(widget.debt);
              Get.back();
            },
            child: Icon(CupertinoIcons.delete),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Text(
                  widget.debt.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                // Date
                SizedBox(height: 8),
                SizedBox(
                  height: 20,
                  child: Row(
                    children: [
                      Text(
                        DateFormat.yMMMd().format(widget.debt.createdAt),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: datePercentage,
                          color: widget.debt.isBorrowed
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                          backgroundColor: widget.debt.isBorrowed
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        DateFormat.yMMMd().format(widget.debt.date),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Sum
                SizedBox(height: 5),
                Divider(
                  color: widget.debt.isBorrowed
                      ? Colors.green.shade300
                      : Colors.red.shade300,
                  thickness: 0.5,
                ),
                SizedBox(height: 5),
                SizedBox(
                  height: 20,
                  child: Row(
                    children: [
                      Text(
                        NumberFormat.decimalPattern()
                            .format(widget.debt.sum - widget.debt.left),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: sumPercentage,
                          color: widget.debt.isBorrowed
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                          backgroundColor: widget.debt.isBorrowed
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        NumberFormat.decimalPattern().format(widget.debt.sum),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                CupertinoButton(
                  onPressed: () async {
                    final uri = Uri(
                      scheme: "tel",
                      path: widget.debt.phoneNumber.toString(),
                    );
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      print("Uzur, ochib bolmadi");
                    }
                  },
                  child: Text(
                    mask.maskText(
                      widget.debt.phoneNumber.toString(),
                    ),
                  ),
                ),
                Divider(),
                SizedBox(height: 10),
                CupertinoButton(
                  color: Colors.yellow,
                  onPressed: () async {
                    final res = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Form(
                          key: key,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: noteController,
                                focusNode: noteFocus,
                                onTapOutside: (value) => noteFocus.unfocus(),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null) return null;
                                  final num = int.tryParse(value);
                                  if (num == null) {
                                    return "Noto'g'ri formatdagi son";
                                  }
                                  if (num <= 0 || num > widget.debt.left) {
                                    return "0 dan katta va ${widget.debt.left} dan kichik";
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: "Summa (max:${widget.debt.left})",
                                ),
                              ),
                              SizedBox(height: 10),
                              CupertinoButton(
                                onPressed: () async {
                                  if (key.currentState!.validate()) {
                                    final txt = noteController.text.trim();
                                    int sum = int.tryParse(txt) ?? 0;
                                    final model = PaymentModel(
                                      payment: sum,
                                      debtId: widget.debt.createdAt,
                                      note: "h/w",
                                      date: DateTime.now(),
                                    );
                                    await addNewPayment(model, widget.debt);
                                    Get.back();
                                    Get.back();
                                  }
                                },
                                child: Text("Save"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Center(child: Text("New Payment")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
