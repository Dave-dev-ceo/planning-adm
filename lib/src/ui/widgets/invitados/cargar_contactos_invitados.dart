import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:planning/src/animations/loading_animation.dart';

class CargarContactosInvitados extends StatefulWidget {
  @override
  _CargarContactosInvitadosState createState() =>
      _CargarContactosInvitadosState();
}

class _CargarContactosInvitadosState extends State<CargarContactosInvitados> {
  Iterable<Contact> _contacts;

  @override
  void initState() {
    controller = new MultiSelectController();
    getContacts();
    super.initState();
  }

  Future<void> getContacts() async {
    //We already have permissions for contact when we get to this page, so we
    // are now just retrieving it
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts;
      controller.set(_contacts?.length ?? 0);
    });
  }

  _avatarContact(Contact contact) {
    if (contact.avatar != null && contact.avatar.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: MemoryImage(contact.avatar),
        radius: 25,
      );
    } else {
      return CircleAvatar(
        child: Icon(Icons.person),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        radius: 25,
      );
    }
  }

  _nameContact(Contact contact) {
    if (contact.displayName != null && contact.displayName.isNotEmpty) {
      return contact.displayName;
    } else {
      return 'Sin nombre';
    }
  }

  _phoneContact(Contact contact) {
    if (contact.phones != null && contact.phones.isNotEmpty) {
      return contact.phones.elementAt(0).value;
    } else {
      return 'Sin número';
    }
  }

  MultiSelectController controller;
  void selectAll() {
    setState(() {
      controller.toggleAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (Text(controller.selectedIndexes.length > 0
            ? 'Seleccionados ${controller.selectedIndexes.length}'
            : 'Contactos')),
        actions: (controller.isSelecting)
            ? <Widget>[
                IconButton(
                  icon: Icon(Icons.select_all),
                  onPressed: selectAll,
                )
              ]
            : <Widget>[],
      ),
      body: _contacts != null
          //Build a list view of all contacts, displaying their avatar and
          // display name
          ? ListView.builder(
              itemCount: _contacts?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Contact contact = _contacts?.elementAt(index);
                return MultiSelectItem(
                  isSelecting: controller.isSelecting,
                  onSelected: () {
                    setState(() {
                      controller.toggle(index);
                    });
                  },
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 10),
                          child: _avatarContact(contact),
                        ),
                        //SizedBox(height: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _nameContact(contact),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              _phoneContact(contact),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    decoration: controller.isSelected(index)
                        ? new BoxDecoration(color: Colors.grey[300])
                        : new BoxDecoration(),
                  ),
                );
                ////////////////////////
                /*return Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      child: _avatarContact(contact),
                    ),
                    //SizedBox(height: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nameContact(contact),
                          style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          _phoneContact(contact),
                          style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                );*/
                //////////////////////////////////////////////////
                /*ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                  leading: (contact.avatar != null && contact.avatar.isNotEmpty)
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(contact.avatar),
                        )
                      : CircleAvatar(
                          child: Text(contact.initials()),
                          backgroundColor: Theme.of(context).accentColor,
                        ),
                  title: Text(contact.displayName ?? ''),
                  );*/
              },
            )
          : Center(child: LoadingCustom()),
    );
  }
}
