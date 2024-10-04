import 'package:flutter/material.dart';
import 'package:note_app_sqlflit/edit_note.dart';
import 'package:note_app_sqlflit/sqldb.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SqlDb sqlDb = SqlDb();
  List<Map<String, Object?>> list = [];
  bool isLoading = false;

  Future readData() async {
    isLoading = false;
    List<Map<String, Object?>> response =
        await sqlDb.readData("SELECT * FROM notes");
    list.addAll(response);
    isLoading = true;
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? ListView(
              children: [
                TextButton(
                    onPressed: () {
                      sqlDb.deleteDtabase1();
                    },
                    child: const Text("delete")),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final data = list[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: const CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blueAccent,
                          child: Icon(Icons.note, color: Colors.white),
                        ),
                        title: Text(
                          data["note"] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            data['title'] as String,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                int response = await sqlDb.deleteData('''
                            DELETE FROM notes where id =${data['id']}
                                
                                ''');
                                if (response > 0) {
                                  list.removeWhere((_element) =>
                                      _element['id'] == data['id']);
                                  setState(() {});
                                }
                              },
                            ),
                            IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.blueAccent),
                                onPressed: () async {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => EditNote(
                                          note: data['note'] as String,
                                          title: data['title'] as String)));
                                }),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "addNotes");
        },
        backgroundColor: Colors.blueAccent,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
