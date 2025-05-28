import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/debt_model.dart';

class DetailPage extends StatefulWidget {
  final DebtModel debt;

  const DetailPage({super.key, required this.debt});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
