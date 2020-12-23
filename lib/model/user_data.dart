class UserData {
  final String name;
  final String email;
  final String phone_number;
  final String paypal_id;
  int coinCount;
  String listen_id;

  UserData(this.email, this.name, this.coinCount, this.paypal_id,
      this.phone_number, this.listen_id);

  UserData.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        email = json["email"],
        phone_number = json["phone_number"],
        coinCount = json['coinCount'],
        paypal_id = json['paypal_id'],
        listen_id = json['listen_id'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone_number'] = this.phone_number;
    data['email'] = this.email;
    data['coinCount'] = this.coinCount;
    data['paypal_id'] = this.paypal_id;
    data['listen_id'] = this.listen_id;
    return data;
  }
}
