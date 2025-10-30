import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AkunPage extends StatefulWidget {
  @override
  _AkunPageState createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  String nama = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  String formatUsername(String name) {
    return name.split(' ').map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : '').join(' ');
  }

  void loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = formatUsername(prefs.getString('nama') ?? 'Habib');
      email = prefs.getString('email') ?? 'muhamadhabib2902@gmail.com';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Akun Saya'),
        backgroundColor: Colors.teal.shade500,
        
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.teal.shade500,
                child: Text(
                  nama.isNotEmpty ? nama[0].toUpperCase() : 'H',
                  style: TextStyle(fontSize: 40, color: Colors.black87),
                ),
              ),
              SizedBox(height: 20),
              Text(
                nama,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 4),
              Text(
                email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/edit-akun');
                },
                icon: Icon(Icons.edit,color: Colors.black,),
                label: Text('Edit Akun',style: TextStyle(color: Colors.black),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade500,
                  minimumSize: Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
