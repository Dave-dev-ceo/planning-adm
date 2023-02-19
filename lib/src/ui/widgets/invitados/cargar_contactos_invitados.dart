import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:planning/src/animations/loading_animation.dart';

import '../multi_selector_item.dart';

class CargarContactosInvitados extends StatefulWidget {
  const CargarContactosInvitados({Key? key}) : super(key: key);

  @override
  _CargarContactosInvitadosState createState() =>
      _CargarContactosInvitadosState();
}

class _CargarContactosInvitadosState extends State<CargarContactosInvitados> {
  Iterable<Contact>? _contacts;

  @override
  void initState() {
    controller = MultiSelectController();
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
    if (contact.avatar != null && contact.avatar!.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: MemoryImage(contact.avatar!),
        radius: 25,
      );
    } else {
      return CircleAvatar(
        child: const Icon(Icons.person),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        radius: 25,
      );
    }
  }

  _nameContact(Contact contact) {
    if (contact.displayName != null && contact.displayName!.isNotEmpty) {
      return contact.displayName;
    } else {
      return 'Sin nombre';
    }
  }

  _phoneContact(Contact contact) {
    if (contact.phones != null && contact.phones!.isNotEmpty) {
      return contact.phones!.elementAt(0).value;
    } else {
      return 'Sin número';
    }
  }

  late MultiSelectController controller;
  void selectAll() {
    setState(() {
      controller.toggleAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (Text(controller.selectedIndexes.isNotEmpty
            ? 'Seleccionados ${controller.selectedIndexes.length}'
            : 'Contactos')),
        actions: (controller.isSelecting)
            ? <Widget>[
                IconButton(
                  icon: const Icon(Icons.select_all),
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
                Contact contact = _contacts!.elementAt(index);
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
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              _phoneContact(contact),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    decoration: controller.isSelected(index)
                        ? BoxDecoration(color: Colors.grey[300])
                        : const BoxDecoration(),
                  ),
                );
              },
            )
          : const Center(child: LoadingCustom()),
    );
  }
}
