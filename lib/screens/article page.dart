import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:news_app/model/article%20model.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({Key? key}) : super(key: key);

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  final GlobalKey inAppWedViewKey = GlobalKey();
  InAppWebViewController? inAppWebViewController;

  final TextEditingController searchController = TextEditingController();

  String searchedText = "";
  bool isSelected = true;
  late PullToRefreshController pullToRefreshController;
  List<String> allBookmarks = [];
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pullToRefreshController = PullToRefreshController(
        options: PullToRefreshOptions(color: Colors.blue),
        onRefresh: () async {
          if (Platform.isAndroid) {
            inAppWebViewController!.reload();
          }

          if (Platform.isIOS) {
            inAppWebViewController!.loadUrl(
                urlRequest:
                URLRequest(url: await inAppWebViewController!.getUrl()));
          }
        });
  }
  @override
  Widget build(BuildContext context) {

    final article = ModalRoute.of(context)!.settings.arguments as Article;
    return
      Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "${article.title}",
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  inAppWebViewController!.reload();
                },
                icon: const Icon(
                  Icons.refresh,
                  size: 30,
                  color: Colors.black,
                )),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              /* Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Enter Your Search',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50))),
                ),
              ),
            ),*/
              Expanded(
                flex: 25,
                child: InAppWebView(
                  pullToRefreshController: pullToRefreshController,
                  initialOptions: options,
                  key: inAppWedViewKey,
                  initialUrlRequest: URLRequest(
                    url: Uri.parse("${article.url}"),
                  ),
                  onWebViewCreated: (controller) {
                    inAppWebViewController = controller;
                  },
                  onLoadStop: (controller, url) async {
                    await pullToRefreshController.endRefreshing();
                    setState(() {
                      searchController.text = url.toString();
                      setState(() {
                        if (searchController.text == article.url) {
                          searchController.text = "";
                        }
                      });
                    });
                  },
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () async {
                              /*setState(() {
                    isSelected = !isSelected;
                  });*/

                              if (await inAppWebViewController!.canGoBack()) {
                                await inAppWebViewController!.goBack();
                              }
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 30,
                            )),
                        IconButton(
                            onPressed: () async {
                              await inAppWebViewController!.loadUrl(
                                urlRequest: URLRequest(
                                  url: Uri.parse("${article.url}"),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.home,
                              size: 30,
                            )),
                        IconButton(
                            onPressed: () async {
                              if (await inAppWebViewController!.canGoForward()) {
                                await inAppWebViewController!.goForward();
                              }
                            },
                            icon: const Icon(
                              Icons.arrow_forward,
                              size: 30,
                            )),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      );
  }
}

