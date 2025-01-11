import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproje/model/status.dart';
import 'package:finalproje/service/storage_service.dart';

class StatusService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StorageService _storageService = StorageService();
  String mediaUrl = '';

  // Status eklemek için
  Future<Status> addStatus(String status, XFile pickedFile) async {
    var ref = _firestore.collection("Status");

    mediaUrl = await _storageService.uploadMedia(File(pickedFile.path));

    var documentRef = await ref.add({'status': status, 'image': mediaUrl});

    return Status(id: documentRef.id, status: status, image: mediaUrl);
  }

  // Status göstermek için
  Stream<QuerySnapshot> getStatus() {
    var ref = _firestore.collection("Status").snapshots();

    return ref;
  }

  // Status silmek için
  Future<void> removeStatus(String docId) {
    var ref = _firestore.collection("Status").doc(docId).delete();

    return ref;
  }

  // Status güncellemek için
  Future<void> updateStatus(String docId, String updatedStatus, XFile? pickedFile) async {
    var ref = _firestore.collection("Status").doc(docId);

    // Eğer yeni bir resim seçilmişse, önce resmi yükle
    if (pickedFile != null) {
      mediaUrl = await _storageService.uploadMedia(File(pickedFile.path));
      await ref.update({'status': updatedStatus, 'image': mediaUrl});
    } else {
      // Sadece metni güncelle
      await ref.update({'status': updatedStatus});
    }
  }
}
