import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../app/urls.dart';

class ApiService {
  // Fetch number of managers
  static Future<int> fetchManagerCount() async {
    try {
      final response = await http.get(Uri.parse(Urls.Admin));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          return data.length;
        }
        return 0;
      } else {
        print('Failed to load managers. Status code: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      print('Error fetching managers: $e');
      return 0;
    }
  }
}