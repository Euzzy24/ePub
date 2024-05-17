import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:quiz_4/services/articles.dart';
import 'package:quiz_4/services/auth.dart';
import 'package:quiz_4/widgets/article_form.dart';
import 'package:quiz_4/widgets/article_list.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;

  List<Article> _articles = [];

  @override
  void initState() {
    super.initState();
    _authService = _getIt<AuthService>();
  }

  Future<void> fetchArticles() async {
    _articles.clear();
    _articles = await Article().getArticles();
  }

  void _refreshList() {
    setState(() {});
  }

  void _removeArticle(String id) async {
    await Article(id: id).deleteArticle();
    _refreshList();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 2),
      content: Text("Article Deleted!"),
    ));
  }

  void _openArticleDialog() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (ctx) => ArticleFormDialog(
              mode: Mode.create,
              onAddArticle: _refreshList,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchArticles(),
        builder: (ctx, snapshot) {
          Widget body;
          if (snapshot.connectionState == ConnectionState.waiting) {
            body = const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            body = Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Widget mainContent = Container(
              width: double.infinity,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: 0.5,
                        child: Icon(
                          Icons.warning,
                          color: Colors.red,
                          size: 50.0,
                        ),
                      ),
                      Text(
                        'WHOOPS!',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 50),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                      'There are no available articles found. Try adding some!')
                ],
              ),
            );

            if (_articles.isNotEmpty) {
              mainContent = ArticleList(
                  onUpdateArticleList: _refreshList,
                  articles: _articles,
                  onRemoveArticle: _removeArticle);
            }

            body = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _articles.isNotEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(left: 15, top: 5, bottom: 5),
                        child: Text(
                          'PDF',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 23,
                              color: Color.fromARGB(255, 27, 25, 20)),
                        ),
                      )
                    : const SizedBox.shrink(),
                Expanded(child: mainContent),
              ],
            );
          }

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text(
                'ePub',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    color: const Color.fromARGB(255, 217, 216, 216)),
              ),
              backgroundColor: const Color.fromARGB(255, 45, 96, 87),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () async {
                      await _authService.signOut(context);
                    },
                    icon: const Icon(
                      Icons.logout,
                      size: 25,
                      color: Colors.white,
                    ))
              ],
            ),
            body: body,
            floatingActionButton: FloatingActionButton(
              onPressed: _openArticleDialog,
              child: const Icon(Icons.add),
            ),
          );
        });
  }
}
