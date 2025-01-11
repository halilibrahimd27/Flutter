import 'dart:io';

import 'package:finalproje/service/status_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class StatusListPage extends StatefulWidget {
  @override
  _StatusListPageState createState() => _StatusListPageState();
}

class _StatusListPageState extends State<StatusListPage> {
  StatusService _statusService = StatusService();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return StreamBuilder<QuerySnapshot>(
      stream: _statusService.getStatus(),
      builder: (context, snaphot) {
        return !snaphot.hasData
            ? CircularProgressIndicator()
            : ListView.builder(
          itemCount: snaphot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot mypost = snaphot.data!.docs[index];

            Future<void> _showChoiceDialog(BuildContext context) {
              return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "Silmek istediğinize emin misiniz?",
                      textAlign: TextAlign.center,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    content: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              _statusService.removeStatus(mypost.id);
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Evet",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Vazgeç",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            Future<void> _showUpdateDialog(BuildContext context, DocumentSnapshot post) {
              TextEditingController statusController =
              TextEditingController(text: post['status']);
              XFile? pickedFile;

              Future<void> _pickImage() async {
                final ImagePicker picker = ImagePicker();
                try {
                  pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  setState(() {}); // Resim seçildikten sonra arayüzü güncelle
                } catch (e) {
                  print("Resim seçme işlemi başarısız: $e");
                }
              }

              return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "Durumu Güncelle",
                      textAlign: TextAlign.center,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            controller: statusController,
                            decoration: InputDecoration(
                              labelText: "Durum",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: _pickImage,
                            child: Text("Resim Seç"),
                          ),
                          pickedFile != null
                              ? Image.file(
                            File(pickedFile!.path),
                            height: 100,
                          )
                              : Container(), // Seçilen resmi göster
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Vazgeç"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (statusController.text.isNotEmpty) {
                            if (pickedFile != null) {
                              await _statusService.updateStatus(
                                post.id,
                                statusController.text,
                                pickedFile,
                              );
                            } else {
                              await _statusService.updateStatus(
                                post.id,
                                statusController.text,
                                null,
                              );
                            }
                            Navigator.pop(context); // Dialog'u kapat
                          } else {
                            print("Durum boş bırakılamaz.");
                          }
                        },
                        child: Text("Güncelle"),
                      ),
                    ],
                  );
                },
              );
            }


            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onLongPress: () {
                  _showUpdateDialog(context, mypost);
                },
                onTap: () {
                  _showChoiceDialog(context);
                },
                child: Container(
                  height: size.height * .3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${mypost['status']}",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: CircleAvatar(
                            backgroundImage:
                            NetworkImage(mypost['image']),
                            radius: size.height * 0.08,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
