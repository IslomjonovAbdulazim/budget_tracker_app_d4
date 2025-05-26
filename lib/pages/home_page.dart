import 'package:budget_tracker_app_d4/models/debt_model.dart';
import 'package:budget_tracker_app_d4/pages/create_page.dart';
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

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    debts = await getAllDebts();
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
