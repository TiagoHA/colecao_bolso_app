import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'dart:async';

import './loading_model.dart';
import '../models/collection.dart';

final collectionsDbReference =
    FirebaseDatabase.instance.reference().child('collections');

class CollectionModel extends LoadingModel {
  List<Collection> _data = [];

  List<Collection> get collections => List.from(_data);

  deleteCollection(int index) {
    _data.removeAt(index);
    notifyListeners();
  }

  toggleFav(int index) {
    // var model = _data[index];
    // var newOne = Collection(model.name, !model.isFav, model.itemCount);

    // newOne.setId(model.id);
    // _data.removeAt(index);
    // _data.add(newOne);

    // _data.sort((a, b) => a.id.compareTo(b.id));

    notifyListeners();
  }

  addCollection(Collection entity) async {
    print('addCollection');
    await collectionsDbReference.push().set(entity.toMap());
  }

  Collection fetchFromSnapshot(DataSnapshot snapshot) {
    var entity = Collection.fromSnapshot(snapshot);
    _data.add(entity);

    notifyListeners();
    return entity;
  }

  Future fetch() {
    setLoading(true);

    return Future.delayed(const Duration(seconds: 1), () => "5").then((value) {
      if (_data.length == 0) {
        // _data.add(
        //     Collection.withId(1, isFav: true, name: 'alef', itemCount: 10));
      }

      setLoading(false);
    });
  }

  static CollectionModel of(BuildContext context) =>
      ScopedModel.of<CollectionModel>(context, rebuildOnChange: true);
}
