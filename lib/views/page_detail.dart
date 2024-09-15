import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/ui/restaurant_detail.dart';

class PageDetail extends StatelessWidget {
  static const routeName = '/restaurant_detail';

  final Map<String, dynamic> restaurant;

  const PageDetail({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestaurantProvider>(
      create: (_) => RestaurantProvider(
        apiService: ApiService(
          endpoints: 'detail/${restaurant['id']}',
          method: 'get',
          bodyPost: {},
        ),
      )..fetchRestaurantDetail(restaurant['id']),
      child: RestaurantDetail(
        restaurantMap: restaurant,
      ),
    );
  }
}
