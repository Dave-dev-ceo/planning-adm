import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:weddingplanner/src/models/item_model_parametros.dart';
import 'package:weddingplanner/src/ui/home/home_content_desktop.dart';
import 'package:weddingplanner/src/ui/home/home_content_mobile.dart';
import 'package:weddingplanner/src/ui/widgets/centered_view/centered_view.dart';
import 'package:weddingplanner/src/ui/widgets/navigation_bar/navigation_bar.dart';
import 'package:weddingplanner/src/ui/widgets/navigation_drawer/navigation_drawer.dart';

class HomeView extends StatelessWidget {
  //static const routeName = '/eventos';
  const HomeView({Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final ScreenArguments param =  ModalRoute.of(context).settings.arguments;
    return ResponsiveBuilder(
      builder: (context,sizingInformation) =>
      Scaffold(
        drawer: sizingInformation.deviceScreenType == DeviceScreenType.mobile 
        ? NavigationDrawer() 
        : null,
        body: CenteredView(
          child: Column(
            children: <Widget>[
              NavigationBar(),
              Expanded(
                child: ScreenTypeLayout(
                  mobile: HomeContentMobile(id: param.id),
                  desktop: HomeContentDesktop(id: param.id),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}