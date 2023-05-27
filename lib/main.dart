import 'package:flutter/material.dart';
import 'package:news_app/screens/article%20page.dart';
import 'package:news_app/screens/home%20page.dart';

void main(){
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.grey.withOpacity(0.5))),
      initialRoute: '/home',
      routes: {
        '/home' : (context)=> const HomePage(),
        '/detail' : (context) => const ArticlePage(),
      },
    ),
  );
}

