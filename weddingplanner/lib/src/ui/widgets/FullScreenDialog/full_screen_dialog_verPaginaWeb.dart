import 'dart:html';
import 'dart:ui' as ul;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/proveedores/view_archivos/view_archivos_bloc.dart';

class FullScreenViewWEB extends StatefulWidget {
  final Map<String, dynamic> data;

  const FullScreenViewWEB({Key key, this.data}) : super(key: key);
  @override
  _FullScreenViewWEBState createState() => _FullScreenViewWEBState();
}

class _FullScreenViewWEBState extends State<FullScreenViewWEB> {
  ViewArchivosBloc viewArchivoBloc;

  @override
  void initState() {
    viewArchivoBloc = BlocProvider.of<ViewArchivosBloc>(context);
    viewArchivoBloc.add(FechtArchivoByIdEvent(widget.data['id_archivo']));

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('View Pagina Web'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${widget.data['nombre']}',
              style: Theme.of(context).textTheme.headline4,
            ),
          )),
          SizedBox(height: 10.0),
          BlocBuilder<ViewArchivosBloc, ViewArchivosState>(
              builder: (context, state) {
            if (state is MostrarArchivoByIdState) {
              return ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: size.width * 0.8,
                    minHeight: size.width * 0.8,
                  ),
                  child: Card(
                    elevation: 10,
                    child: SizedBox(
                      width: size.width * 0.6,
                      height: size.height * 0.4,
                      child: _vistaWeb(
                          state.detlistas.results[0].archivo, size.width * 0.8),
                    ),
                  ));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
          SizedBox(
            height: 20.0,
          )
        ]),
      ),
    );
  }

  Widget _vistaWeb(String url, double width) {
    @override
    IFrameElement _iframeElement = IFrameElement();
    Widget _iframeWidget;
    url = url.replaceFirst('watch?v=', 'embed/');

    _iframeElement.src = url;
    _iframeElement.style.border = 'none';
    _iframeElement.style.height = '300';
    _iframeElement.style.width = '700';
    // ignore: undefined_prefixed_name
    ul.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iframeElement,
    );

    _iframeWidget = HtmlElementView(
      key: UniqueKey(),
      viewType: 'iframeElement',
    );

    return _iframeWidget;
  }
}
