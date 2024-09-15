import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/utils/result_state.dart';
import 'package:restaurant_app/widgets/card_restaurant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageFavorites extends StatelessWidget {
  static const String favoritesTitle = 'Favorites';
  const PageFavorites({super.key});

  void _searchRestaurant(BuildContext context, String query) {
    Provider.of<DatabaseProvider>(context, listen: false)
        .searchFavorites(query);
  }

  Widget _buildList() {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        if (provider.state == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (provider.state == ResultState.hasData) {
          return ListView.builder(
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              return CardRestaurant(
                restaurant: provider.favorites[index],
              );
            },
          );
        } else if (provider.state == ResultState.noData) {
          return Center(
            child: Material(
              child: Text(provider.message),
            ),
          );
        } else if (provider.state == ResultState.error) {
          return Center(
            child: Material(
              child: Text(provider.message),
            ),
          );
        } else {
          return const Center(
            child: Material(
              child: Text(''),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restoran Favorit'),
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
