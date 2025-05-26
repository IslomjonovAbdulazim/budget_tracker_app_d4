import 'package:budget_tracker_app_d4/models/debt_model.dart';
import 'package:budget_tracker_app_d4/pages/create_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                        value: .4,
                        backgroundColor: Colors.red.shade100,
                        color: Colors.red.shade800,
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: CupertinoButton(
                        color: Colors.yellow,
                        onPressed: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    model.name,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
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
