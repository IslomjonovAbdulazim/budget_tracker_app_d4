import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PaymentModel {
  // members
  late int payment;
  late DateTime debtId;
  late String note;
  late DateTime date;

  // constructor
  PaymentModel({
    required this.payment,
    required this.debtId,
    required this.note,
    required this.date,
  });

  // fromJson
  PaymentModel.fromJson(Map json) {
    payment = json["payment"];
    debtId = DateTime.parse(json["debtId"]);
    note = json["note"];
    date = DateTime.parse(json["debt"]);
  }

  // toJson
  Map toJson() => {
        "payment": payment,
        "debtId": debtId.toIso8601String(),
        "note": note,
        "date": date.toIso8601String(),
      };
}

Future<List<PaymentModel>> getAllPayments() async {
  final db = await SharedPreferences.getInstance();
  final data = db.getString("payments") ?? "[]";
  final listJson = List.from(jsonDecode(data));
  final result = listJson.map((json) => PaymentModel.fromJson(json)).toList();
  return result;
}

Future<void> saveAllPayments(List<PaymentModel> payments) async {
  final db = await SharedPreferences.getInstance();
  final listJson = payments.map((model) => model.toJson()).toList();
  final data = jsonEncode(listJson);
  await db.setString("payments", data);
}





















