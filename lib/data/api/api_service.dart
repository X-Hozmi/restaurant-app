import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/model_restaurant_detail.dart';
import 'package:restaurant_app/data/model/model_restaurant_list.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  final String endpoints;
  final String method;
  final Map<String, dynamic> bodyPost;

  ApiService({
    required this.endpoints,
    required this.method,
    required this.bodyPost,
  });

  String endpointsFull = '';

  Future<WelcomeList> httpRequest(String query) async {
    http.Response response;

    switch (method.toLowerCase()) {
      case 'get':
        endpointsFull = endpoints;
        if (query.isNotEmpty) {
          endpointsFull = 'search$query';
        }
        response = await http.get(Uri.parse("$_baseUrl$endpointsFull"));
      case 'post':
        response = await http.post(
          Uri.parse("$_baseUrl$endpoints"),
          body: bodyPost,
        );
        break;
      default:
        throw Exception('HTTP method tidak didukung');
    }

    if (response.statusCode == 200) {
      return welcomeFromJson(response.body);
    } else {
      throw Exception('Daftar restoran gagal dimuat');
    }
  }

  Future<WelcomeDetail> httpRequestDetail(String id) async {
    final response = await http.get(Uri.parse("$_baseUrl/detail/$id"));

    if (response.statusCode == 200) {
      return welcomeDetailFromJson(response.body);
    } else {
      throw Exception('Detail restoran gagal dimuat');
    }
  }
}
