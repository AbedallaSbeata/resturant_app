class AddFoodModel {
  List<String>? data;

  AddFoodModel({
    this.data,
  });

  AddFoodModel.fromJson(Map<String, dynamic>? json) {
    data = json!['data'];
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data,
    };
  }
}
