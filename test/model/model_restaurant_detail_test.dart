import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/model/model_restaurant_detail.dart';
import 'dart:convert';

void main() {
  group('WelcomeDetail', () {
    test('fromJson and toJson', () {
      final jsonMap = {
        "error": false,
        "message": "success",
        "restaurant": {
          "id": "rqdv5juczeskfw1e867",
          "name": "Melting Pot",
          "description":
              "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. ...",
          "city": "Medan",
          "address": "Jln. Pandeglang no 19",
          "pictureId": "14",
          "categories": [
            {"name": "Italia"},
            {"name": "Modern"}
          ],
          "menus": {
            "foods": [
              {"name": "Paket rosemary"},
              {"name": "Toastie salmon"}
            ],
            "drinks": [
              {"name": "Es krim"},
              {"name": "Sirup"}
            ]
          },
          "rating": 4.2,
          "customerReviews": [
            {
              "name": "Ahmad",
              "review": "Tidak rekomendasi untuk pelajar!",
              "date": "13 November 2019"
            }
          ]
        }
      };

      final welcomeDetail = WelcomeDetail.fromJson(jsonMap);

      expect(welcomeDetail.error, false);
      expect(welcomeDetail.message, "success");
      expect(welcomeDetail.restaurant.id, "rqdv5juczeskfw1e867");
      expect(welcomeDetail.restaurant.name, "Melting Pot");
      expect(welcomeDetail.restaurant.rating, 4.2);
      expect(welcomeDetail.restaurant.categories.length, 2);
      expect(welcomeDetail.restaurant.customerReviews.length, 1);

      final jsonString = welcomeToJson(welcomeDetail);
      final decodedJson = json.decode(jsonString);

      expect(decodedJson["error"], false);
      expect(decodedJson["message"], "success");
      expect(decodedJson["restaurant"]["id"], "rqdv5juczeskfw1e867");
    });
  });
}
