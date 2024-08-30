import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/news_channel_headlines_model.dart';

class NewsRepository {
  final String apiKey = '65616e2ee13a4347a94031872e9aba7b';
  final String baseUrl =
      'https://newsapi.org/v2/everything?q=javascript&apiKey=65616e2ee13a4347a94031872e9aba7b';

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlines(
      {String? filter}) async {
    final queryParameters = {
      'q': filter ?? 'tesla',
      'apiKey': apiKey,
    };

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
    final response = await http.get(uri);

    if (kDebugMode) {
      print('Request URL: $uri');
      print('Response body: ${response.body}');
    }

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    } else {
      throw Exception('Failed to load news');
    }
  }
}
