import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();

  CollectionReference _users = FirebaseFirestore.instance.collection("users");

  void _addUser() {
    _users.add({
      'name': _nameController.text,
      'vehicle': _vehicleController.text,
    });
    _nameController.clear();
    _vehicleController.clear();
  }

  void _deleteUser(String userId) {
    _users.doc(userId).delete();
  }

  void _editUser(DocumentSnapshot user) {
    _nameController.text = user['name'];
    _vehicleController.text = user['vehicle'];

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Edit User"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "User Name"),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _vehicleController,
                  decoration: InputDecoration(labelText: "User Vehicle"),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              ElevatedButton(
                  onPressed: () {
                    _updateUser(user.id);
                    Navigator.pop(context);
                  },
                  child: Text("Update")),
            ],
          );
        });
  }

  void _updateUser(String userId) {
    _users.doc(userId).update({
      'name': _nameController.text,
      'vehicle': _vehicleController.text,
    });

    _nameController.clear();
    _vehicleController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Data"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Enter User Name"),
            ),
            SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _vehicleController,
              decoration: InputDecoration(labelText: "Enter Your Vehicle"),
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                _addUser();
              },
              child: Text("Add User"),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
                child: StreamBuilder(
              stream: _users.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var user = snapshot.data!.docs[index];
                    return Dismissible(
                      key: Key(user.id),
                      background: Container(
                        color: Colors.redAccent,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) {
                        _deleteUser(user.id);
                      },
                      direction: DismissDirection.endToStart,
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(
                            user['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            user['vehicle'],
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              _editUser(user);
                            },
                            icon: Icon(Icons.edit),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
