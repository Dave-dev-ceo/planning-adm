// imports flutter/dart
import 'package:flutter/material.dart';

// imports
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class NewContrato extends StatefulWidget {
  NewContrato({Key key}) : super(key: key);

  @override
  New_ContratoState createState() => New_ContratoState();
}

class New_ContratoState extends State<NewContrato> {
  // vaiables clase
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showContratos(),
      bottomNavigationBar: _showNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _showButton(),
    );
  }

  // BLoC
  _myBloc() {
    return _showContratos();
  }

  // cointener => columna => listas x tipo
  _showContratos() {
    return Container(
      padding: EdgeInsets.all(10.0),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _itemsContratos(),
      ),
    );
  }

  // select lista
  _itemsContratos() {
    switch(_selectedIndex) {
      case 0:
        return _contratosItem();
      case 1:
        return _recibosItem();
      case 2:
        return _pagosItem();
      default:
        return _minutasItem();
    }
  }

  // ini items
  _contratosItem() {
    List<Widget> item = [];
    item.add(
      Text('contratos')
    );
    return item;
  }
  _recibosItem() {
    List<Widget> item = [];
    item.add(
      Text('recibos')
    );
    return item;
  }
  _pagosItem() {
    List<Widget> item = [];
    item.add(
      Text('pagos')
    );
    return item;
  }
  _minutasItem() {
    List<Widget> item = [];
    item.add(
      Text('minutas')
    );
    return item;
  }
  // fin items

  _showNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.gavel),
          label: 'Contratos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: 'Recibos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.request_page),
          label: 'Pagos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: 'Minutas',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
    );
  }

  _showButton() {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      children: _childrenButtons(),
    );
  }

  _childrenButtons() {
    List<SpeedDialChild> temp = [];
    // 2do
    temp.add(
      SpeedDialChild(
        child: Icon(Icons.upload_file),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onTap: _eventoUpload
      )
    );
    // 1ro
    temp.add(
      SpeedDialChild(
        child: Icon(Icons.send_and_archive_sharp),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onTap: _eventoAdd
      )
    );
    return temp;
  }

  _eventoUpload() {
    switch(_selectedIndex) {
      case 0:
        print('up1');
        break;
      case 1:
        print('up2');
        break;
      case 2:
        print('up3');
        break;
      default:
        print('up4');
        break;
    }
  }

  _eventoAdd() {
    switch(_selectedIndex) {
      case 0:
        Navigator.pushNamed(context, '/addContratos', arguments: 'CT');
        break;
      case 1:
        Navigator.pushNamed(context, '/addContratos', arguments: 'RC');
        break;
      case 2:
        Navigator.pushNamed(context, '/addContratos', arguments: 'PG');
        break;
      default:
        Navigator.pushNamed(context, '/addContratos', arguments: 'MT');
        break;
    }
  }
}