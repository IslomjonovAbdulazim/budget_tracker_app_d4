import 'package:budget_tracker_app_d4/models/debt_model.dart';
import 'package:budget_tracker_app_d4/pages/create_page.dart';
import 'package:budget_tracker_app_d4/pages/detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DebtModel> debts = [];
  var totalDebt = 0;
  var paidDebt = 0;
  var totalLand = 0;
  var paidLand = 0;
  var debtPercentage = 0.0;
  var landPercentage = 0.0;

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    debts = await getAllDebts();
    totalDebt = 0;
    paidDebt = 0;
    totalLand = 0;
    paidLand = 0;
    for (final model in debts) {
      if (model.isBorrowed) {
        totalLand += model.sum;
        paidLand += (model.sum - model.left);
      } else {
        totalDebt += model.sum;
        paidDebt += (model.sum - model.left);
      }
    }
    if (totalDebt > 0) {
      debtPercentage = paidDebt / totalDebt;
    } else {
      debtPercentage = 1;
    }
    if (totalLand > 0) {
      landPercentage = paidLand / totalLand;
    } else {
      landPercentage = 1;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Oldi Berdi"),
        actions: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              await Get.to(CreatePage());
              load();
            },
            child: Icon(Icons.add, size: 30),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Summary...
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: debtPercentage,
                        backgroundColor: Colors.red.shade100,
                        color: Colors.red.shade800,
                        minHeight: 60,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: landPercentage,
                        backgroundColor: Colors.green.shade100,
                        color: Colors.green.shade800,
                        minHeight: 60,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              // All Debts
              Expanded(
                child: ListView.builder(
                  itemCount: debts.length,
                  itemBuilder: (context, index) {
                    final model = debts[index];
                    final deadline =
                        model.date.difference(model.createdAt).inHours;
                    final spent =
                        DateTime.now().difference(model.createdAt).inHours;
                    var datePercentage = 1.0;
                    if (deadline > 0 && spent >= 0) {
                      datePercentage = spent / deadline;
                    }
                    var sumPercentage = 1.0;
                    if (model.sum > 0) {
                      sumPercentage = (model.sum - model.left) / model.sum;
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: CupertinoButton(
                        color: model.isBorrowed
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        onPressed: () async {
                          await Get.to(DetailPage(debt: model));
                          load();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    model.name,
                                    style: TextStyle(
                                      color: model.isBorrowed
                                          ? Colors.green.shade800
                                          : Colors.red.shade800,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            // date
                            SizedBox(height: 5),
                            SizedBox(
                              height: 20,
                              child: Row(
                                children: [
                                  Text(
                                    DateFormat.yMMMd().format(model.createdAt),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: LinearProgressIndicator(
                                      value: datePercentage,
                                      color: model.isBorrowed
                                          ? Colors.green.shade800
                                          : Colors.red.shade800,
                                      backgroundColor: model.isBorrowed
                                          ? Colors.green.shade100
                                          : Colors.red.shade100,
                                      minHeight: 10,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    DateFormat.yMMMd().format(model.date),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // sum
                            SizedBox(height: 5),
                            Divider(
                              color: model.isBorrowed
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
                                        .format(model.sum - model.left),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: LinearProgressIndicator(
                                      value: sumPercentage,
                                      color: model.isBorrowed
                                          ? Colors.green.shade800
                                          : Colors.red.shade800,
                                      backgroundColor: model.isBorrowed
                                          ? Colors.green.shade100
                                          : Colors.red.shade100,
                                      minHeight: 10,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    NumberFormat.decimalPattern()
                                        .format(model.sum),
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
