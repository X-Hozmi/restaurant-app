import 'dart:convert';

WelcomeList welcomeFromJson(String str) =>
    WelcomeList.fromJson(json.decode(str));

String welcomeToJson(WelcomeList data) => json.encode(data.toJson());

class WelcomeList {
  bool error;
  String message;
  int count;
  int founded;
  List<ModelRestaurantList> restaurants;

  WelcomeList({
    required this.error,
    required this.message,
    required this.count,
    required this.founded,
    required this.restaurants,
  });

  factory WelcomeList.fromJson(Map<String, dynamic> json) => WelcomeList(
        error: json["error"],
        message: json["message"] ?? '',
        count: json["count"] ?? 1,
        founded: json["founded"] ?? 1,
        restaurants: List<ModelRestaurantList>.from(
            json["restaurants"].map((x) => ModelRestaurantList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "count": count,
        "founded": founded,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}

class ModelRestaurantList {
  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;

  ModelRestaurantList({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory ModelRestaurantList.fromJson(Map<String, dynamic> json) =>
      ModelRestaurantList(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        pictureId: json["pictureId"].toString(),
        city: json["city"],
        rating: json["rating"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "pictureId": pictureId,
        "city": city,
        "rating": rating,
      };

  ModelRestaurantList.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        description = map['description'],
        pictureId = map['pictureId'].toString(),
        city = map['city'],
        rating = map['rating'].toDouble();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pictureId': pictureId,
      'city': city,
      'rating': rating,
    };
  }
}
