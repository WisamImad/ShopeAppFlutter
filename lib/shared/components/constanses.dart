
// POST
// UPDATE
// DELETE
// GET

// base url : https://newsapi.org/
// method (url) : v2/top-headlines?
// queries : country=eg&category=business&apiKey=65f7556ec76449fa7dc7c0069f040ca

import 'package:flutter/material.dart';
import 'package:learn_section8/modules/login/login_screen.dart';
import 'package:learn_section8/shared/network/local/cache_helper.dart';

void signOut(context){
  CacheHelper.removeData(key: 'token').then((value) {
    if (value) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()), (
          route) => false);
    }
  });
}

void printFullText(String text){
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match)=>print(match.group(0)));
}

String token = CacheHelper.getData(key: 'token');