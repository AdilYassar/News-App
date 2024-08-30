import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_app/models/news_channel_headlines_model.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatelessWidget {
  final Articles article;

  const NewsDetailScreen({required this.article, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
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
              Html(
                data: article.description ?? 'No Description Available',
                style: {
                  "body": Style(
                    fontSize: FontSize.large,
                    color: Colors.black,
                  ),
                },
              ),
              SizedBox(height: 10),
              if (article.content != null && article.content!.isNotEmpty)
                Html(
                  data: article.content!,
                  style: {
                    "body": Style(
                      fontSize: FontSize.large,
                      color: Colors.black,
                    ),
                  },
                ),
              SizedBox(height: 10),
              if (article.publishedAt != null)
                Text(
                  'Published on: ${article.publishedAt}',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              if (article.author != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Author: ${article.author}',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              if (article.source?.name != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Source: ${article.source!.name}',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              if (article.url != null && article.url!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: () => _launchUrl(article.url!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 116, 105, 134),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('Read Full Article'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
