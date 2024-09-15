import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/model_restaurant_list.dart';
import 'package:restaurant_app/data/model/model_restaurant_detail.dart';
import 'package:flutter/material.dart';

enum ResultState { loading, noData, hasData, error, noInternet }

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService});

  late WelcomeList _restaurantsResult;
  late WelcomeDetail _restaurantDetail;
  late ResultState _state;
  String _message = '';

  String get message => _message;
  WelcomeList get result => _restaurantsResult;
  WelcomeDetail get detail => _restaurantDetail;
  ResultState get state => _state;

  Future<dynamic> _fetchAllRestaurant(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        _state = ResultState.noInternet;
        notifyListeners();
        return _message =
            'Sepertinya kamu belum terhubung ke internet. Harap nyalakan koneksi internet lalu coba lagi';
      }

      final restaurant = await apiService.httpRequest(query);
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Data tidak ditemukan';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        _restaurantsResult = restaurant;
      }
    } catch (e, stackTrace) {
      _state = ResultState.error;
      notifyListeners();
      _message = 'Error --> $e, $stackTrace';
    }
  }

  Future<dynamic> _fetchFavoriteRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final restaurant = await apiService.httpRequest('');
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Kamu belum menambahkan restoran favoritmu';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        _restaurantsResult = restaurant;
      }
    } catch (e, s) {
      _state = ResultState.error;
      notifyListeners();
      _message = 'Error --> $e, $s';
    }
  }

  Future<dynamic> _fetchRestaurantDetail(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        _state = ResultState.noInternet;
        notifyListeners();
        return _message =
            'Sepertinya kamu belum terhubung ke internet.\nHarap nyalakan koneksi internet lalu coba lagi';
      }

      final restaurant = await apiService.httpRequestDetail(id);
      if (restaurant.restaurant.id.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Data tidak ditemukan';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        _restaurantDetail = restaurant;
      }
    } catch (e, stackTrace) {
      _state = ResultState.error;
      notifyListeners();
      _message = 'Error --> $e, $stackTrace';
    }
  }

  void fetchAllRestaurant(String query) {
    _fetchAllRestaurant(query);
  }

  void fetchFavoriteRestaurant() {
    _fetchFavoriteRestaurant();
  }

  void fetchRestaurantDetail(String id) {
    _fetchRestaurantDetail(id);
  }
}
