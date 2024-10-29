import 'package:flutter/material.dart';
import 'package:flutter_application/utils/api_helper.dart';
import 'package:url_launcher/url_launcher.dart';


class Programs extends StatelessWidget {
  const Programs({super.key});

  

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      height: 300,
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Article>>(
              future: NewsService().fetchTopHeadlines(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No articles found.'));
                } else {
                  final articles = snapshot.data!.take(8).toList();

                  return PageView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 300,
                        height: 200,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(47, 62, 70, 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                                child: Image.network(
                                  articles[index].urlToImage,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(child: Text('Image not available', style: TextStyle(color: Colors.white)));
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    articles[index].title,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    articles[index].description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      final websiteUri = Uri.parse(articles[index].url);
                                      launchUrl(
                                        websiteUri,
                                        mode: LaunchMode.inAppBrowserView
                                      );
                                    },
                                    child: Text(
                                      "Read More...",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
