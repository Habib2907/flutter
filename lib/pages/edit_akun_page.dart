import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditAkunPage extends StatefulWidget {
  @override
  _EditAkunPageState createState() => _EditAkunPageState();
}

class _EditAkunPageState extends State<EditAkunPage> {
  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController(text: 'Habib');
  final emailController = TextEditingController(text: 'muhamadhabib2902@gmail.com');

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      namaController.text = prefs.getString('nama') ?? namaController.text;
      emailController.text = prefs.getString('email') ?? emailController.text;
    });
  }

  String formatUsername(String name) {
    return name.split(' ').map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : '').join(' ');
  }

  void simpan() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final formattedNama = formatUsername(namaController.text);
      await prefs.setString('nama', formattedNama);
      await prefs.setString('email', emailController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data akun berhasil disimpan')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Akun'),
        backgroundColor: Colors.teal.shade500,
       
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.teal.shade500,
                child: Text('H', style: TextStyle(fontSize: 32, color: Colors.black)),
              ),
              SizedBox(height: 24),
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || !value.contains('@') || !value.contains('.')) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: simpan,
                child: Text('Simpan', style: TextStyle(color: Colors.black),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade500,
                  minimumSize: Size(double.infinity, 48),
                  
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
