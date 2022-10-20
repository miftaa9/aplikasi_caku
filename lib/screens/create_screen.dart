import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:aplikasi_caku/database/database_instance.dart';

List<String> list = <String>['Makanan', 'Pakaian', 'Hiburan', 'Gaji'];

class CreateScreen extends StatefulWidget {
  const CreateScreen({Key? key}) : super(key: key);

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  DatabaseInstance databaseInstance = DatabaseInstance();
  TextEditingController nameController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  TextEditingController tanggalController = TextEditingController();
  TextEditingController ketController = TextEditingController();
  int _value = 1;
  String dropdownValue = list.first;

  @override
  void initState() {
    // implementasi initState
    databaseInstance.database();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Create"),
            backgroundColor: Color.fromARGB(255, 1, 100, 5),
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(15),
              ),
            )),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tanggal"),
                TextField(
                  controller: tanggalController,
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Kategori"),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Color.fromARGB(255, 1, 100, 5),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Tipe Transaksi"),
                ListTile(
                  title: Text("Pemasukan"),
                  leading: Radio(
                      groupValue: _value,
                      value: 1,
                      onChanged: (value) {
                        setState(() {
                          _value = int.parse(value.toString());
                        });
                      }),
                ),
                ListTile(
                  title: Text("Pengeluaran"),
                  leading: Radio(
                      groupValue: _value,
                      value: 2,
                      onChanged: (value) {
                        setState(() {
                          _value = int.parse(value.toString());
                        });
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Jumlah"),
                TextField(
                  controller: totalController,
                ),
                SizedBox(
                  height: 30,
                ),
                Text("Keterangan"),
                TextField(
                  controller: ketController,
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () async {
                      color: Colors.black;
                      int idInsert = await databaseInstance.insert({
                        'name': dropdownValue,
                        'type': _value,
                        'total': totalController.text,
                        'created_at': tanggalController.text,
                        'updated_at': ketController
                            .text, //sementara save keterangan disini
                      });
                      print("sudah masuk : " + idInsert.toString());
                      Navigator.pop(context);
                    },
                    child: Text("Simpan")),                    
              ],
            ),
          )),
        ));
  }
}
