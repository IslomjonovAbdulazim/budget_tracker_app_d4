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


















