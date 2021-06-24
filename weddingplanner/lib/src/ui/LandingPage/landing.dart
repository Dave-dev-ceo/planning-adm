import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/utils/shims/dart_ui_real.dart';
import 'package:transparent_image/transparent_image.dart';

class Landing extends StatefulWidget {
  const Landing({ Key key }) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  int _pageIndex = 0;
  List<String> imageList = [
  'https://cdn.pixabay.com/photo/2020/12/15/16/25/clock-5834193__340.jpg',
  'https://cdn.pixabay.com/photo/2020/09/18/19/31/laptop-5582775_960_720.jpg',
  'https://media.istockphoto.com/photos/woman-kayaking-in-fjord-in-norway-picture-id1059380230?b=1&k=6&m=1059380230&s=170667a&w=0&h=kA_A_XrhZJjw2bo5jIJ7089-VktFK0h0I4OWDqaac0c=',
  'https://cdn.pixabay.com/photo/2019/11/05/00/53/cellular-4602489_960_720.jpg',
  'https://cdn.pixabay.com/photo/2017/02/12/10/29/christmas-2059698_960_720.jpg',
  'https://cdn.pixabay.com/photo/2020/01/29/17/09/snowboard-4803050_960_720.jpg',
  'https://cdn.pixabay.com/photo/2020/02/06/20/01/university-library-4825366_960_720.jpg',
  'https://cdn.pixabay.com/photo/2020/11/22/17/28/cat-5767334_960_720.jpg',
  'https://cdn.pixabay.com/photo/2020/12/13/16/22/snow-5828736_960_720.jpg',
  'https://cdn.pixabay.com/photo/2020/12/09/09/27/women-5816861_960_720.jpg',
];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 120,
          bottom: TabBar( onTap: (int index) {
            setState(
              () {
                _pageIndex = index;
              },
            );
          },
            indicatorColor: Colors.white,
            isScrollable: true,labelPadding: EdgeInsets.fromLTRB(32, 0, 32,0),
            tabs: [
              Tab(
                
                child: Text(
                  'Requisitos para ceremonias',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              Tab(
                //text: 'Home',
                child: Text(
                  'Tips',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              Tab(
                //text: 'Timings',
                child: Text(
                  'Tradiciones',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ],
          ),
          leading:Image.asset(
              'assets/logo.png',
              height: 180.0,
              width: 450,
          ),leadingWidth: 200,automaticallyImplyLeading: true,),
          body: IndexedStack(
              index: _pageIndex,
              children: [
                SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    //margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        for (var i = 0; i < 2; i++) _cardInfo(),
                      ]
                    )
                  ),
                ),
              ]
          ),
      ),
    );
  }
  _cardInfo(){
    return Padding(
       padding: EdgeInsets.all(15),
          child: Container(
        width: 400,
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Container(
                
                padding: EdgeInsets.all(5),
                height: 350,width: 350,
                child: FittedBox(
                  child: Image.network('https://www.hola.com/imagenes/novias/20210410187228/vestidos-novia-desmontables/0-937-364/portada-vestidos-desmontables-m.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: Title(color: Colors.black, child: Text('¿Vestidos de novia lenceros? Descubre si es el estilo que necesitas para tu boda',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),))
              ), 
              //Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 5),child: Text('Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido usó una galería de textos y los mezcló de tal manera que logró hacer un libro de textos especimen. ',textAlign: TextAlign.justify,))

            ],
          ),

        ),
      ),
    );
  }
}