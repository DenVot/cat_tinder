import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cat.dart';

class CatService {
  static const String _baseUrl =
      'https://api.thecatapi.com/v1/images/search?has_breeds=1&limit=1';

  Future<Cat> getRandomCat() async {
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        "x-api-key":
            "live_yCZPSZUTpuAXiXmMd8Pc20fL9YRt3LYYKNMM8XVHNHZSsGfEorNZ2m0lDpqJ1Vzb",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return Cat.fromJson(data[0]);
    } else {
      throw Exception('Failed to load cat');
    }
  }
}
