import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiz_4/services/mixins.dart';

final _firebase = FirebaseAuth.instance;
final CollectionReference articles =
    FirebaseFirestore.instance.collection('articles');

class Article with DisplayMixin {
  Article(
      {this.path, this.id, this.title, this.uid, this.platform, this.context});

  final String? title;
  final String? uid;
  final String? id;
  final String? platform;
  final String? path;
  final BuildContext? context;

  factory Article.fromMap(Map<String, dynamic> data, id) {
    return Article(
      id: id,
      title: data['title'],
      uid: data['uid'],
      path: data['path'],
      platform: data['platform'],
    );
  }

  Future<void> addArticle() async {
    try {
      await articles.add({
        'title': title,
        'uid': _firebase.currentUser?.uid,
        'path': path,
        'platform': getPlatform()
      });
    } on FirebaseException catch (e) {
      showError(errorMessage: e.message!, errorTitle: 'Database Error!');
      return;
    }
  }

  Future<void> updateArticle() async {
    try {
      await articles
          .doc(id)
          .update({'title': title, 'path': path, 'platform': getPlatform()});
    } on FirebaseException catch (e) {
      showError(errorMessage: e.message!, errorTitle: 'Database Error!');
      return;
    }
  }

  Future<void> deleteArticle() async {
    try {
      await articles.doc(id).delete();
    } on FirebaseException catch (e) {
      showError(errorMessage: e.message!, errorTitle: 'Database Error!');
      return;
    }
  }

  Future<List<Article>> getArticles() async {
    QuerySnapshot querySnapshot = await articles.get();
    final allArticles = querySnapshot.docs
        .map((doc) =>
            Article.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
    return allArticles;
  }

  String getPlatform() {
    if (kIsWeb) {
      return 'Web';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return 'Android';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'iOS';
    } else if (defaultTargetPlatform == TargetPlatform.linux) {
      return 'Linux';
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      return 'macOS';
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      return 'Windows';
    } else {
      return 'Unidentified';
    }
  }
}
