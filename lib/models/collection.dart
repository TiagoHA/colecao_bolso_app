import 'package:firebase_database/firebase_database.dart';

class Collection {
  String _id;
  String _name;
  bool _isFav;
  int _itemCount;

  Collection(this._name, this._isFav, this._itemCount);

  Collection.map(dynamic obj) {
    this._id = obj['id'];
    this._name = obj['name'];
    this._itemCount = obj['isFav'];
    this._isFav = obj['itemCount'];
  }

  Collection.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _name = snapshot.value['name'];
    _isFav = snapshot.value['isFav'];
    _itemCount = snapshot.value['itemCount'];
  }

  String get id => _id;
  String get name => _name;
  bool get isFav => _isFav;
  int get itemCount => _itemCount;

  dynamic toMap() => {'name': this._name, 'isFav': this.isFav, 'itemCount': _itemCount};
}
