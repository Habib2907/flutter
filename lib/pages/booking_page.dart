// lib/pages/booking_page.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedService;
  final List<String> _services = [
    'Ganti Oli',
    'Tune Up',
    'Servis Rem',
    'Servis AC',
    'Ganti Aki',
    'Lainnya (...)',
  ];

  final _manualServiceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  // Save booking to SharedPreferences as JSON list
  Future<void> _saveBooking() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('bookings') ?? '[]';
    final List bookings = json.decode(raw);
    final service = _selectedService == "Lainnya (...)"
        ? _manualServiceController.text.trim()
        : _selectedService!;

    final booking = {
      'date': _selectedDate!.toIso8601String(),
      'time': '${_selectedTime!.hour.toString().padLeft(2,'0')}:${_selectedTime!.minute.toString().padLeft(2,'0')}',
      'service': service,
      'createdAt': DateTime.now().toIso8601String(),
    };

    bookings.add(booking);
    await prefs.setString('bookings', json.encode(bookings));

    setState(() => _saving = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Booking berhasil disimpan')));
    Navigator.pop(context); // kembali ke home
  }

  // Optional: load bookings (example)
  Future<List<Map<String, dynamic>>> _loadBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('bookings') ?? '[]';
    final List list = json.decode(raw);
    final casted = list.cast<Map<String, dynamic>>();
    casted.sort((a, b) => DateTime.parse(b['createdAt']).compareTo(DateTime.parse(a['createdAt'])));
    return casted;
  }

  //Menghapus Daftar booking
  Future<void> _clearBookings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('bookings'); // hapus key 'bookings'
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Semua booking telah dihapus')));
  }

  Future<void> _deleteBooking(Map<String, dynamic> booking) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('bookings') ?? '[]';
    final List bookings = json.decode(raw);
    bookings.removeWhere((b) => b['createdAt'] == booking['createdAt']);
    await prefs.setString('bookings', json.encode(bookings));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Booking dihapus')),
    );
  }


  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(Duration(days: 365)),
    );

    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _getDayName(DateTime date) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return days[date.weekday - 1]; // weekday: 1 = Senin, 7 = Minggu
  }

  String _formatDateWithDay(DateTime d) {
    final dayName = _getDayName(d);
    return '$dayName, ${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';
  }

  @override
  void initState() {
    super.initState();
    _manualServiceController.addListener(() {
      setState(() {}); // update tampilan saat teks berubah
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Servis'),
        backgroundColor: Colors.teal.shade500,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Booking Servis',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                         
                        ),
                      ),
                      SizedBox(height: 18),

                      // Tanggal
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Tanggal',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 8),
                      InkWell(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? 'Pilih Tanggal'
                                    : _formatDateWithDay(_selectedDate!),

                                style: TextStyle(
                                  color: _selectedDate == null
                                      ? Colors.grey
                                      : Colors.black87,
                                ),
                              ),
                              Icon(Icons.calendar_today, color: Colors.black),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Waktu
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Waktu',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 8),
                      InkWell(
                        onTap: _pickTime,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedTime == null
                                    ? 'Pilih Waktu'
                                    : _selectedTime!.format(context),
                                style: TextStyle(
                                  color: _selectedTime == null
                                      ? Colors.grey
                                      : Colors.black87,
                                ),
                              ),
                              Icon(Icons.access_time, color: Colors.black),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Jenis Servis
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Jenis Servis',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedService,
                        items: _services
                            .map(
                              (s) => DropdownMenuItem(value: s, child: Text(s)),
                            )
                            .toList(),
                        onChanged: (val) {
                          setState(() => _selectedService = val);
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                        validator: (v) =>
                            v == null ? 'Pilih jenis servis' : null,
                      ),
                      SizedBox(height: 16),

                      // Tampilkan TextField jika "Lainnya" dipilih
                      if (_selectedService == 'Lainnya (...)') ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Masukkan Jenis Servis',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _manualServiceController,
                          maxLines: null,
                          minLines: 3,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: 'Contoh: Servis Karburator...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(
                                bottom: 50,
                                left: 15,
                              ), // sejajarkan ikon dengan teks multiline
                              child: Icon(Icons.edit, color: Colors.grey[700]),
                            ),
                          ),
                          validator: (v) {
                            if (_selectedService == 'Lainnya (...)' &&
                                (v == null || v.trim().isEmpty)) {
                              return 'Jenis servis wajib diisi';
                            }
                            return null;
                          },
                        ),
                      ],

                      SizedBox(height: 20),

                      // Tombol Booking
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saving
                              ? null
                              : () {
                                  // Manual validate date & time
                                  final dateValid = _selectedDate != null;
                                  final timeValid = _selectedTime != null;
                                  if (!dateValid || !timeValid) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Pilih tanggal dan waktu terlebih dahulu',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  if (_formKey.currentState!.validate()) {
                                    _saveBooking();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade500,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _saving
                              ? SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Booking',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 8),

                      // Optional: quick link to view bookings
                      TextButton(
                        onPressed: () async {
                          final initialList = await _loadBookings();
                          showDialog(
                            context: context,
                            builder: (context) => StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: Text('Daftar Booking', style: TextStyle(fontWeight: FontWeight.bold),),
                                  content: Container(
                                    width: double.maxFinite,
                                    child: initialList.isEmpty
                                        ? Text('Belum ada booking')
                                        : ListView.separated(
                                            shrinkWrap: true,
                                            itemBuilder: (context, i) {
                                              final b = initialList[i];
                                              final d = DateTime.parse(b['date']);
                                              return ListTile(
                                                dense: true,
                                                title: Text('${b['service']}',style: TextStyle(fontWeight: FontWeight.w500),),
                                                subtitle: Text(
                                                  '${_getDayName(d)}, ${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year} Jam, ${b['time']}',
                                                  style: TextStyle(color: Colors.blueGrey),
                                                ),
                                                trailing: IconButton(
                                                  icon: Icon(Icons.delete, color: Colors.red),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (_) => AlertDialog(
                                                        title: Text('Konfirmasi Hapus'),
                                                        content: Text('Apakah Anda yakin ingin menghapus booking ini?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () => Navigator.pop(context),
                                                            child: Text('Batal'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () async {
                                                              await _deleteBooking(b);
                                                              setState(() {
                                                                initialList.removeAt(i);
                                                              });
                                                              Navigator.pop(context);
                                                            },
                                                            child: Text('Hapus'),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            separatorBuilder: (context, index) => Divider(),
                                            itemCount: initialList.length,
                                          ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Tutup', style: TextStyle(color: Colors.black),),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: Text('Konfirmasi Hapus Semua'),
                                            content: Text('Apakah Anda yakin ingin menghapus semua booking?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: Text('Batal'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await _clearBookings();
                                                  setState(() {
                                                    initialList.clear();
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Hapus Semua'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Hapus Semua',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                        child: Text(
                          'Lihat booking sebelumnya',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
