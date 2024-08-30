import 'package:news_app/models/news_channel_headlines_model.dart';
import 'package:news_app/repository/news_repository.dart';

class NewsViewModel {
  final NewsRepository _repository = NewsRepository();

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlines(
      {String? filter}) {
    return _repository.fetchNewsChannelHeadlines(filter: filter);
  }
}
