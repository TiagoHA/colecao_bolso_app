import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';

import './collection_scoped_model.dart';
import '../config/app_config.dart';
import '../common/common.dart';

class CollectionsList extends StatefulWidget {
  final CollectionModel collectionModel;
  CollectionsList(this.collectionModel);

  _CollectionsListState createState() => _CollectionsListState();
}

class _CollectionsListState extends State<CollectionsList> {
  @override
  void initState() {
    widget.collectionModel.fetch();
    super.initState();
  }

  Widget _buildList() {
    return ListView.builder(
      itemBuilder: (context, index) => _buildListTile(context, index),
      itemCount: widget.collectionModel.collections.length,
    );
  }

  Future<bool> _showConfirmDeletion(BuildContext context, int index) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirma a exclusão desssa coleção ?'),
          content: Text(
              'A coleção assim como todos os seus itens serão excluídos permanentimente!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: Text('Excluir'),
              onPressed: () => Navigator.of(context).pop(true),
            )
          ],
        );
      },
    );
  }

  Widget _buildListTile(BuildContext context, int index) {
    var item = widget.collectionModel.collections[index];

    return Slidable(
      key: Key(item.id.toString()),
      delegate: SlidableBehindDelegate(),
      slideToDismissDelegate: new SlideToDismissDrawerDelegate(
          onDismissed: (actionType) {
            if (actionType == SlideActionType.secondary)
              widget.collectionModel.deleteCollection(index);
          },
          dismissThresholds: <SlideActionType, double>{
            SlideActionType.primary: 1.0
          },
          onWillDismiss: (actionType) => _showConfirmDeletion(context, index)),
      actionExtentRatio: 0.25,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: <Widget>[
            ListTile(
              onTap: () => Application.router.navigateTo(
                  context, '/collection/$index',
                  transition: TransitionType.inFromRight),
              title: Text(item.name),
              subtitle: Text('10 de ${item.itemCount}'),
              leading: Icon(
                item.isFav ? Icons.favorite : Icons.favorite_border,
                color: item.isFav ? Colors.red : null,
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: item.isFav ? 'Desmarcar favorito' : 'Marcar favorito',
          color: Colors.indigo,
          icon: item.isFav ? Icons.favorite_border : Icons.favorite,
          onTap: () {
            widget.collectionModel.toggleFav(index);
            showSnackBar(context, 'Ação realizada com sucesso!');
          },
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
            caption: 'Excluir coleção',
            color: Colors.red,
            icon: Icons.delete_forever),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, CollectionModel model) {
        Widget content = Empty();

        if (model.collections.length > 0 && !model.isLoading) {
          content = _buildList();
        } else if (model.collections.length == 0 && !model.isLoading) {
          content = content;
        } else if (model.isLoading) {
          content = ShimmerList();
        }
        return RefreshIndicator(
          child: content,
          onRefresh: model.fetch,
        );
      },
    );
  }
}
