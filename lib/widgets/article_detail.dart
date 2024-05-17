import 'package:flutter/material.dart';
import 'package:quiz_4/pages/pdf_viewer.dart';
import 'package:quiz_4/services/articles.dart';

class ArticleDetailsDialog extends StatelessWidget {
  const ArticleDetailsDialog({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.only(
                    top: 16, left: 16, right: 16, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Article Details',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 20),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close_rounded))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      article.title!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    Text('Platform Used: ${article.platform!}'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      child: const Text('View PDF'),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PDFViewerRoute(
                                  path: article.path!,
                                )));
                      },
                    )
                  ],
                )),
          )),
    );
  }
}
