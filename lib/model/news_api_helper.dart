import 'dart:convert';

import 'package:http/http.dart';

import 'article model.dart';

class NewsApiHelper{
 /* NewsApiHelper._();

  static final NewsApiHelper newsApiHelper =   NewsApiHelper._();*/

  final String url = "http://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=e3d137b600fc4a9b9b05bf6cb2a79872";

  Future<List<Article>> getArticle() async {
    Response res = await get(Uri.parse(url));

    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);

      List<dynamic> body = json['articles'];

      List<Article> articles =
      body.map((dynamic item) => Article.fromJson(item)).toList();

      return articles;
    } else {
      throw ("Can't get the Articles");
    }
  }

}