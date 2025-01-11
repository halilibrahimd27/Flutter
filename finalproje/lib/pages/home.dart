import 'package:finalproje/pages/add_status.dart';
import 'package:finalproje/pages/status_list.dart';
import 'package:finalproje/pages/login.dart'; // LoginPage import edildi
import 'package:finalproje/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  User? _user; // Kullanıcı bilgisi

  @override
  void initState() {
    super.initState();
    _getCurrentUser(); // Giriş yapan kullanıcının bilgilerini al
  }

  void _getCurrentUser() {
    setState(() {
      _user = FirebaseAuth.instance.currentUser; // Giriş yapan kullanıcı bilgisi
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ana Sayfa"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStatusPage()),
          );
        },
        child: Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                _user?.displayName ?? "Anonim Kullanıcı",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                _user?.email ?? "E-posta bulunamadı",
                style: TextStyle(fontSize: 16),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: _user?.photoURL != null
                    ? NetworkImage(_user!.photoURL!) // Kullanıcı profil fotoğrafı
                    : AssetImage("assets/default-avatar.png") as ImageProvider, // Varsayılan fotoğraf
              ),
            ),
            ListTile(
              title: Text('Anasayfa'),
              leading: Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Profilim'),
              leading: Icon(Icons.person),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              title: Text('Çıkış yap'),
              leading: Icon(Icons.remove_circle),
              onTap: () async {
                await _authService.signOut(); // Çıkış yapılıyor
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                ); // Login ekranına yönlendirme yapılıyor
              },
            ),
          ],
        ),
      ),
      body: StatusListPage(),
    );
  }
}
