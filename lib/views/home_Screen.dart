import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/models/news_channel_headlines_model.dart';
import 'package:news_app/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsViewModel newsViewModel = NewsViewModel();
  String _selectedFilter = 'abc-news'; // Default to ABC News

  final List<Map<String, String>> _categories = [
    {'title': 'Business', 'value': 'business'},
    {'title': 'Technology', 'value': 'technology'},
    {'title': 'Sports', 'value': 'sports'},
    {'title': 'Health', 'value': 'health'},
    {'title': 'JavaScript', 'value': 'javascript'},
    {'title': 'Dart', 'value': 'dart'},
    {'title': 'Flutter', 'value': 'flutter'},
    {'title': 'Web3', 'value': 'web3'},
    {'title': 'Food', 'value': 'food'},
    {'title': 'Music', 'value': 'music'},
    {'title': 'Travel', 'value': 'travel'},
  ];

  final List<Map<String, String>> _filters = [
    {'title': 'CNN News', 'value': 'cnn'},
    {'title': 'ARY News', 'value': 'ary'},
    {'title': 'AL JAZEERA News', 'value': 'al-jazeera'},
    {'title': 'TRT World', 'value': 'trt-world'},
    {'title': 'New York Times', 'value': 'the-new-york-times'},
    {'title': 'Reuters', 'value': 'reuters'},
    {'title': 'BBC News', 'value': 'bbc-news'},
  ];

  void _showDialog({
    required String title,
    required List<Map<String, String>> options,
    required Function(String) onOptionSelected,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              return ListTile(
                title: Text(option['title']!),
                onTap: () {
                  onOptionSelected(option['value']!);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showCategories() {
    _showDialog(
      title: 'Select Category',
      options: _categories,
      onOptionSelected: (value) {
        setState(() {
          _selectedFilter = value;
        });
      },
    );
  }

  void _showFilterOptions() {
    _showDialog(
      title: 'Filter News',
      options: _filters,
      onOptionSelected: (value) {
        setState(() {
          _selectedFilter = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.category),
          onPressed: _showCategories,
        ),
        title: Text(
          "Top Headlines",
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterOptions,
          ),
        ],
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<NewsChannelsHeadlinesModel>(
        future:
            newsViewModel.fetchNewsChannelHeadlines(filter: _selectedFilter),
        builder: (BuildContext context,
            AsyncSnapshot<NewsChannelsHeadlinesModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading news',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  color: Colors.redAccent,
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final articlesWithImages = snapshot.data!.articles!
                .where((article) =>
                    article.urlToImage != null &&
                    article.urlToImage!.isNotEmpty)
                .toList();

            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: articlesWithImages.length,
              itemBuilder: (context, index) {
                var article = articlesWithImages[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NewsDetailScreen(article: article),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl: article.urlToImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: height * 0.25,
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            article.title ?? 'No Title Available',
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            article.description ?? 'No Description Available',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Read more",
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.deepPurple,
                                size: 18,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text(
                'No news available',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class NewsDetailScreen extends StatelessWidget {
  final Articles article;

  const NewsDetailScreen({required this.article, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          article.title ?? 'News Detail',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: article.urlToImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              SizedBox(height: 10),
              Text(
                article.title ?? 'No Title Available',
                style: GoogleFonts.roboto(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                article.content ?? 'No Content Available',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
