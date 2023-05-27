import 'package:flutter/material.dart';
import 'package:news_app/model/article%20model.dart';
import 'package:news_app/model/news_api_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NewsApiHelper client = NewsApiHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News App",style: TextStyle(color: Colors.black),),
        centerTitle: true,


      ),
      body: FutureBuilder(
        future: client.getArticle(),
        builder: (context,snapshot){
          if(snapshot.hasError) {
            return Center(
              child: Text(" Error : ${snapshot.error}"),
            );
          } else if(snapshot.hasData){
         List<Article> data = snapshot.data as List<Article>;
            return ListView.builder(itemBuilder: (context,i){
              return InkWell(
                onTap: () {
                 /* Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ArticlePage(
                            article: data[i],
                          )));*/
                  Navigator.of(context).pushNamed('/detail' ,arguments: data[i]);
                },
                child: Container(
                  margin: const EdgeInsets.all(12.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: const [
                         BoxShadow(
                          color: Colors.black12,
                          blurRadius: 3.0,
                        ),
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          //let's add the height

                          image: DecorationImage(
                              image: NetworkImage("${data[i].urlToImage}"), fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Text(
                          "${data[i].source?.name}",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        "${data[i].title}" ,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },itemCount: data.length,);
          }
          return const Center(child: CircularProgressIndicator(),);
        },

      ),
    );
  }
}
