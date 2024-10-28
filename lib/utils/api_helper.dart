import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  //This API key should not be here :)
  final String apiKey = 'c3445ad46e144d99b7c566c7251b17a9'; 
  final String baseUrl = 'https://newsapi.org/v2';

  Future<List<Article>> fetchTopHeadlines() async {
    final url = Uri.parse('$baseUrl/top-headlines?sources=bbc-news&apiKey=$apiKey');
    
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      // Decodifica a resposta JSON
      final List<dynamic> jsonReponse =  jsonDecode(response.body)['articles'];
      return jsonReponse.map((article) => Article.fromJson(article)).toList();

    } else {
      throw Exception('Erro ao carregar notícias');
    }
  }
}

class Article{
  final String title;
  final String description;
  final String urlToImage;
  final String url;
  
  Article({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.url
  });

   // Factory method to create a article instance from a Map representation.
  factory Article.fromJson(Map<String, dynamic> json){
    return Article(
      title: json['title'],
      description: json['description'],
      urlToImage: json['urlToImage'],
      url: json['url']
    );
  }
}
