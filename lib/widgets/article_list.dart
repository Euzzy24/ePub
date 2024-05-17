import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_4/services/articles.dart';
import 'package:quiz_4/widgets/article_item.dart';

class ArticleList extends StatelessWidget {
  const ArticleList(
      {super.key,
      required this.onUpdateArticleList,
      required this.articles,
      required this.onRemoveArticle});

  final void Function(String id) onRemoveArticle;
  final List<Article> articles;
  final Function() onUpdateArticleList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: articles.length,
        itemBuilder: (ctx, index) => Dismissible(
            confirmDismiss: (direction) async {
              if (FirebaseAuth.instance.currentUser?.uid !=
                  articles[index].uid) {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text(
                      "Deletion Prohibited! You cannot delete someone's notes"),
                ));
                return false;
              } else {
                return true;
              }
            },
            background: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Theme.of(context).colorScheme.error.withOpacity(0.85),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            key: ValueKey(articles[index]),
            onDismissed: (direction) {
              onRemoveArticle(articles[index].id!);
            },
            child: ArticleItem(
              article: articles[index],
              onUpdateArticleList: onUpdateArticleList,
            )));
  }
}
