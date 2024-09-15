import 'package:restaurant_app/data/db/database_helper.dart';
import 'package:restaurant_app/data/model/model_restaurant_list.dart';
import 'package:restaurant_app/utils/result_state.dart';
import 'package:flutter/foundation.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _state = ResultState.loading;
    _getFavorites();
  }

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<ModelRestaurantList> _favorites = [];
  List<ModelRestaurantList> get favorites => _favorites;

  void _getFavorites() async {
    try {
      _favorites = await databaseHelper.getFavorites();
      if (_favorites.isNotEmpty) {
        _state = ResultState.hasData;
      } else {
        _state = ResultState.noData;
        _message = 'Kamu belum menambahkan restoran favorit';
      }
    } catch (e, s) {
      _state = ResultState.error;
      _message = 'Error: $e, Trace: $s';
    }
    notifyListeners();
  }

  void addFavorite(ModelRestaurantList restaurant) async {
    try {
      await databaseHelper.insertFavorite(restaurant);
      _getFavorites();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavoriteed(String id) async {
    final favoritedRestaurant = await databaseHelper.getFavoriteByID(id);
    return favoritedRestaurant.isNotEmpty;
  }

  void removeFavorite(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
      _getFavorites();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  void _searchFavorites(String query) async {
    try {
      _favorites = await databaseHelper.searchFavorites(query);
      if (_favorites.isNotEmpty) {
        _state = ResultState.hasData;
      } else {
        _state = ResultState.noData;
        _message = 'Tidak ada restoran favorit yang ditemukan';
      }
    } catch (e, s) {
      _state = ResultState.error;
      _message = 'Error: $e, Trace: $s';
    }
    notifyListeners();
  }

  void getFavorites() {
    _getFavorites();
  }

  void searchFavorites(String query) {
    _searchFavorites(query);
  }
}
