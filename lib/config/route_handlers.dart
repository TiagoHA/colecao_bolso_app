import '../pages/collections/collections.dart';
import '../pages/collections/create.dart';
import '../pages/collection_detail/collection_tabs.dart';
import '../pages/auth/auth.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

var collectionsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CollectionsPage();
});

var collectionItemsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  var index = int.parse(params['id']?.first);

  return CollectionPage(index);
});

var createCollectionHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CreateCollectionPage();
});

var authHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AuthPage();
});