import 'package:restaurant_app/data/model/model_restaurant_detail.dart';
import 'package:restaurant_app/data/model/model_restaurant_list.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/widgets/text_expandable.dart';

class RestaurantDetail extends StatefulWidget {
  final Map<String, dynamic> restaurantMap;
  const RestaurantDetail({super.key, required this.restaurantMap});

  @override
  State<RestaurantDetail> createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  late ModelRestaurantDetail restaurant;

  Widget _buildDetail() {
    return Consumer<RestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.blueAccent,
          ));
        } else if (state.state == ResultState.hasData) {
          restaurant = state.detail.restaurant;
          return Consumer<DatabaseProvider>(
            builder: (context, provider, child) {
              return FutureBuilder<bool>(
                future: provider.isFavoriteed(restaurant.id),
                builder: (context, snapshot) {
                  var isFavoriteed = snapshot.data ?? false;
                  return Stack(
                    children: [
                      Positioned(
                        left: 330.0,
                        top: 30.0,
                        child: IconButton(
                          icon: isFavoriteed
                              ? const Icon(Icons.favorite)
                              : const Icon(Icons.favorite_border),
                          color: Colors.red,
                          onPressed: () {
                            if (isFavoriteed) {
                              provider.removeFavorite(restaurant.id);
                            } else {
                              provider.addFavorite(
                                ModelRestaurantList.fromJson(
                                  {
                                    "id": restaurant.id,
                                    "name": restaurant.name,
                                    "description": restaurant.description,
                                    "pictureId": restaurant.pictureId,
                                    "city": restaurant.city,
                                    "rating": restaurant.rating,
                                  },
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      detailRestaurant(context, restaurant)
                    ],
                  );
                },
              );
            },
          );
          // return detailRestaurant(context, restaurant);
        } else if (state.state == ResultState.noData) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.question_mark, size: 48.0),
                const SizedBox(height: 16.0),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        } else if (state.state == ResultState.noInternet) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off, size: 48.0),
                const SizedBox(height: 16.0),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget detailRestaurant(
      BuildContext context, ModelRestaurantDetail restaurant) {
    final tinggiLayar = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                restaurant.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(width: 4.0),
                  Flexible(
                    child: Text(
                      restaurant.city,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star),
                  const SizedBox(width: 4.0),
                  Flexible(
                    child: Text(
                      restaurant.rating.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.grey),
              SizedBox(height: tinggiLayar * 0.02),
              const Text(
                'Deskripsi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              ExpandableText(
                text: restaurant.description,
              ),
              const Divider(color: Colors.grey),
              SizedBox(height: tinggiLayar * 0.02),
              const Text(
                'Daftar Menu',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: tinggiLayar * 0.02),
              const Text(
                'Makanan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 120.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: restaurant.menus.foods.map((food) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 100,
                          color: Colors.blueAccent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.lunch_dining,
                                color: Colors.white,
                                size: 40,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                food.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: tinggiLayar * 0.02),
              const Text(
                'Minuman',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 120.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: restaurant.menus.drinks.map((drink) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 100,
                          color: Colors.blueAccent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.local_drink,
                                color: Colors.white,
                                size: 40,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                drink.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const Divider(color: Colors.grey),
              SizedBox(height: tinggiLayar * 0.02),
              const Text(
                'Review Pelanggan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 120.0,
                child: ListView(
                  children: restaurant.customerReviews.map((review) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 100,
                          color: Colors.blueAccent,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 50,
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nama: ${review.name}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                      ),
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Review: ${review.review}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                      ),
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    Text(
                                      'Tanggal: ${review.date}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                      ),
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget isDetailFavoriteed() {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isFavoriteed(restaurant.id),
          builder: (context, snapshot) {
            var isFavoriteed = snapshot.data ?? false;
            return Positioned(
              top: 250.0,
              right: 30.0,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: isFavoriteed
                      ? const Icon(Icons.favorite)
                      : const Icon(Icons.favorite_border),
                  color: Colors.red,
                  onPressed: () {
                    if (isFavoriteed) {
                      provider.removeFavorite(restaurant.id);
                    } else {
                      provider.addFavorite(
                        ModelRestaurantList.fromJson(
                          {
                            "id": restaurant.id,
                            "name": restaurant.name,
                            "description": restaurant.description,
                            "pictureId": restaurant.pictureId,
                            "city": restaurant.city,
                            "rating": restaurant.rating,
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kembali'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Hero(
                tag: 'IDGambar_${widget.restaurantMap['pic_id']}',
                child: Image.network(
                  'https://restaurant-api.dicoding.dev/images/large/${widget.restaurantMap['pic_id']}',
                  fit: BoxFit.cover,
                ),
              ),
              _buildDetail(),
            ],
          ),
        ),
      ),
    );
  }
}
