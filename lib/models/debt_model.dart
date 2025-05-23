import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DebtModel {
  // members
  late int sum;
  late String desc;
  late String name;
  late int phoneNumber;
  late DateTime date;
  late DateTime createdAt;

  // constructor
  DebtModel({
    required this.sum,
    required this.desc,
    required this.name,
    required this.phoneNumber,
    required this.createdAt,
    required this.date,
  });

  // fromJson
  DebtModel.fromJson(Map json) {
    sum = json["sum"];
    desc = json["desc"];
    name = json["name"];
    phoneNumber = json["phoneNumber"];
    createdAt = DateTime.parse(json["createdAt"]);
    date = DateTime.parse(json["date"]);
  }

  // toJson
  Map toJson() => {
    "sum": sum,
    "desc": desc,
    "name": name,
    "phoneNumber": phoneNumber,
    "createdAt": createdAt.toIso8601String(),
    "date": date.toIso8601String(),
  };
}

Future<void> saveAllDebts(List<DebtModel> debts) async {
  final db = await SharedPreferences.getInstance();
  final listJson = debts.map((model) => model.toJson()).toList();
  final data = jsonEncode(listJson);
  await db.setString("debts", data);
}

Future<List<DebtModel>> getAllDebts() async {
  final db = await SharedPreferences.getInstance();
  final data = db.getString("debts") ?? "[]";
  final listJson = List.from(jsonDecode(data));
  final result = listJson.map((json) => DebtModel.fromJson(json)).toList();
  return result;
}

Future<void> deleteDebt(DebtModel debt) async {
  final allDebts = await getAllDebts();
  allDebts.removeWhere((model) => model.createdAt == debt.createdAt);
  await saveAllDebts(allDebts);
}

Future<void> createDebt(DebtModel debt) async {
  final allDebts = await getAllDebts();
  allDebts.removeWhere((model) => model.createdAt == debt.createdAt);
  allDebts.add(debt);
  await saveAllDebts(allDebts);
}














