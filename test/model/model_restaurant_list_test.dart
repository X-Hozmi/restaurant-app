import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/model/model_restaurant_list.dart';
import 'dart:convert';

void main() {
  group('WelcomeList', () {
    test('fromJson and toJson', () {
      final jsonMap = {
        "error": false,
        "message": "success",
        "count": 20,
        "restaurants": [
          {
            "id": "rqdv5juczeskfw1e867",
            "name": "Melting Pot",
            "description":
                "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
            "pictureId": "14",
            "city": "Medan",
            "rating": 4.2
          },
          {
            "id": "s1knt6za9kkfw1e867",
            "name": "Kafe Kita",
            "description":
                "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. ...",
            "pictureId": "25",
            "city": "Gorontalo",
            "rating": 4
          }
        ]
      };

      final welcomeList = WelcomeList.fromJson(jsonMap);

      expect(welcomeList.error, false);
      expect(welcomeList.message, "success");
      expect(welcomeList.count, 20);
      expect(welcomeList.restaurants.length, 2);
      expect(welcomeList.restaurants[0].id, "rqdv5juczeskfw1e867");
      expect(welcomeList.restaurants[1].name, "Kafe Kita");

      final jsonString = welcomeToJson(welcomeList);
      final decodedJson = json.decode(jsonString);

      expect(decodedJson["error"], false);
      expect(decodedJson["message"], "success");
      expect(decodedJson["count"], 20);
      expect(decodedJson["restaurants"].length, 2);
      expect(decodedJson["restaurants"][0]["id"], "rqdv5juczeskfw1e867");
    });
  });

  group('ModelRestaurantList', () {
    test('fromJson and toJson', () {
      final jsonMap = {
        "id": "rqdv5juczeskfw1e867",
        "name": "Melting Pot",
        "description":
            "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
        "pictureId": "14",
        "city": "Medan",
        "rating": 4.2
      };

      final restaurant = ModelRestaurantList.fromJson(jsonMap);

      expect(restaurant.id, "rqdv5juczeskfw1e867");
      expect(restaurant.name, "Melting Pot");
      expect(restaurant.rating, 4.2);

      final jsonString = json.encode(restaurant.toJson());
      final decodedJson = json.decode(jsonString);

      expect(decodedJson["id"], "rqdv5juczeskfw1e867");
      expect(decodedJson["name"], "Melting Pot");
    });
  });
}
