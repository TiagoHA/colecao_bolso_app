import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import './collections/collections.dart';
import './tags/tags.dart';
import './collection/collection.dart';
import './config/app_config.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition.toString());
  }
}

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();

  runApp(ColecaoDeBolsoApp(
    collectionItemModel: CollectionItemModel(),
    tagsService: TagsService(httpClient: http.Client()),
    collectionsService: CollectionsService(httpClient: http.Client()),
  ));
}

class ColecaoDeBolsoApp extends StatefulWidget {
  final CollectionItemModel collectionItemModel;
  final TagsService tagsService;
  final CollectionsService collectionsService;

  ColecaoDeBolsoApp(
      {@required this.collectionItemModel,
      @required this.tagsService,
      @required this.collectionsService}) {
    final router = new Router();

    //Configurar rotas
    Routes.configureRoutes(router);
    CollectionRoute.configureRoutes(router);
    CollectionsRoute.configureRoutes(router);
    TagsRoute.configureRoutes(router);

    Application.router = router;
  }

  @override
  State<StatefulWidget> createState() => _ColecaoDeBolsoAppState();
}

class _ColecaoDeBolsoAppState extends State<ColecaoDeBolsoApp> {
  TagsBloc tagsBloc;
  CollectionsBloc collectionsBloc;

  @override
  void initState() {
    tagsBloc = TagsBloc(widget.tagsService);
    collectionsBloc = CollectionsBloc(widget.collectionsService);
    super.initState();
  }

  @override
  void dispose() {
    tagsBloc.dispose();
    collectionsBloc.dispose();
    super.dispose();
  }

  _injectScopedModels({@required Widget child}) {
    return ScopedModel<CollectionItemModel>(
        model: widget.collectionItemModel, child: child);
  }

  _injectBloc({@required Widget child}) {
    return BlocProvider<TagsBloc>(
      bloc: tagsBloc,
      child: BlocProvider<CollectionsBloc>(
        bloc: collectionsBloc,
        child: child,
      ),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return _injectScopedModels(
      child: _injectBloc(
        child: MaterialApp(
          title: 'Coleção de Bolso',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.orange,
            primaryTextTheme: TextTheme(
              title: TextStyle(color: Colors.white),
            ),
            primaryIconTheme: IconThemeData(color: Colors.white),
            tabBarTheme: TabBarTheme(labelColor: Colors.white),
            accentColor: Colors.deepOrangeAccent,
          ),
          // home: AuthPage(),
          onGenerateRoute: Application.router.generator,
        ),
      ),
    );
  }
}
