import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/data/model/model_restaurant_list.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/views/page_detail.dart';

class CardRestaurant extends StatelessWidget {
  final ModelRestaurantList restaurant;

  const CardRestaurant({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isFavoriteed(restaurant.id),
          builder: (context, snapshot) {
            var isFavoriteed = snapshot.data ?? false;
            return Material(
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading: Hero(
                  tag: 'IDGambar_${restaurant.pictureId}',
                  child: SizedBox(
                    width: 100,
                    child: Image.network(
                      'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  restaurant.name,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 4.0),
                        Flexible(
                          child: Text(
                            restaurant.city,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 16),
                        const SizedBox(width: 4.0),
                        Flexible(
                          child: Text(
                            restaurant.rating.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: isFavoriteed
                    ? IconButton(
                        icon: const Icon(Icons.favorite),
                        color: Colors.red,
                        onPressed: () => provider.removeFavorite(restaurant.id),
                      )
                    : IconButton(
                        icon: const Icon(Icons.favorite_border),
                        color: Colors.red,
                        onPressed: () => provider.addFavorite(restaurant),
                      ),
                onTap: () => Navigation.intentWithData(
                  PageDetail.routeName,
                  {
                    "id": restaurant.id,
                    "pic_id": restaurant.pictureId,
                    "name": restaurant.name
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
