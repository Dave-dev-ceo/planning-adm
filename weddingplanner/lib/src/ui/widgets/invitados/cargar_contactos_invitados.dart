import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

class CargarContactosInvitados extends StatefulWidget {
  @override
  _CargarContactosInvitadosState createState() => _CargarContactosInvitadosState();
}

class _CargarContactosInvitadosState extends State<CargarContactosInvitados> {
  Iterable<Contact> _contacts;


  @override
  void initState() {
    getContacts();
    super.initState();
  }
  
  Future<void> getContacts() async {
    //We already have permissions for contact when we get to this page, so we
    // are now just retrieving it
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts;
      print('listaC');
    });
  }

  _avatarContact(Contact contact){
    if(contact.avatar!= null && contact.avatar.isNotEmpty){
      return CircleAvatar(
              backgroundImage: MemoryImage(contact.avatar),
              radius: 25,
            );
    }else{
      return
      CircleAvatar(
        child: Icon(Icons.person),
        backgroundColor: Theme.of(context).accentColor,
        
        radius: 25,
      );
    }
  }
  _nameContact(Contact contact){
    if(contact.displayName!= null && contact.displayName.isNotEmpty){
      return contact.displayName;
    }else{
      return
      'Sin nombre';
    }
  }
  _phoneContact(Contact contact){
    if(contact.phones!= null && contact.phones.isNotEmpty){
      return contact.phones.elementAt(0).value;
    }else{
      return
      'Sin número';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (Text('Contactos')),
      ),
      body: _contacts != null
          //Build a list view of all contacts, displaying their avatar and
          // display name
          ? ListView.builder(
              itemCount: _contacts?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Contact contact = _contacts?.elementAt(index);
                
                return Row(
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
                );
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
          : Center(child: const CircularProgressIndicator()),
    );
  }
}