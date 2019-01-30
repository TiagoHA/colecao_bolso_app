import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../models/collection.dart';
import '../../scoped_models/collection.dart';

class CreateCollectionPage extends StatefulWidget {
  _CreateCollectionPageState createState() => _CreateCollectionPageState();
}

class _CreateCollectionPageState extends State<CreateCollectionPage> {
  String _name = '';
  int _totalItems = 0;
  bool _isFavorite = false;
  StreamSubscription<Event> _onAddedSubscription;

  _CreateCollectionPageState() {
    _onAddedSubscription = collectionsDbReference.onChildAdded.listen(_onAdded);
  }

  @override
  void dispose() {
    print('[_CreateCollectionPageState]:dispose');
    _onAddedSubscription.cancel();
    super.dispose();
  }

  void _onAdded(Event event) {
    print('_onAdded');
    // var model = CollectionModel.of(context);

    // model.fetchFromSnapshot(event.snapshot);
  }

  _addCollection(Function addCollection) {
    var entity = Collection(_name, _isFavorite, _totalItems);

    addCollection(entity);
    // Navigator.pop(context, entity.id);
  }

  Widget _buildSubmitButton(BuildContext context) {
    var model = CollectionModel.of(context);

    return RaisedButton(
      color: Theme.of(context).accentColor,
      onPressed: () => _addCollection(model.addCollection),
      child: Text('Salvar'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Coleção'),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    filled: true,
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                  decoration: InputDecoration(
                    labelText: 'Quantidade de itens',
                    filled: true,
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _totalItems = int.parse(value);
                    });
                  },
                ),
                SwitchListTile(
                  value: _isFavorite,
                  title: Text('Marcar como favorito'),
                  onChanged: (bool value) {
                    setState(() {
                      _isFavorite = value;
                    });
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                _buildSubmitButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
