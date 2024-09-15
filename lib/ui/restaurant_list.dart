import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/widgets/card_restaurant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantList extends StatelessWidget {
  const RestaurantList({super.key});

  void _searchRestaurant(BuildContext context, String query) {
    Provider.of<RestaurantProvider>(context, listen: false)
        .fetchAllRestaurant(query);
  }

  Widget _buildList() {
    return Consumer<RestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.blueAccent,
          ));
        } else if (state.state == ResultState.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.result.restaurants.length,
            itemBuilder: (context, index) {
              var restaurant = state.result.restaurants[index];
              return CardRestaurant(restaurant: restaurant);
            },
          );
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
        } else if (state.state == ResultState.error) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.question_mark, size: 48.0),
                SizedBox(height: 16.0),
                Text(
                  'Yah, sepertinya terjadi kesalahan pada aplikasi :(\nHarap coba lagi beberapa saat.',
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
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _searchRestaurant(context, '');
                  },
                  child: const Text('Refresh'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restoran Nusantara'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari restoran...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: InkWell(
                  onTap: () {},
                  child: const Icon(Icons.search),
                ),
              ),
              onSubmitted: (query) {
                query = query.isNotEmpty ? '?q=$query' : '';
                _searchRestaurant(context, query);
              },
            ),
          ),
        ),
      ),
      body: _buildList(),
    );
  }
}
