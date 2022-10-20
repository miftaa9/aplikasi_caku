import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:aplikasi_caku/database/database_instance.dart';
import 'package:aplikasi_caku/models/transaksi_model.dart';

List<String> list = <String>['Makanan', 'Pakaian', 'Hiburan', 'Gaji'];

class UpdateScreen extends StatefulWidget {
  final TransaksiModel transaksiMmodel;
  const UpdateScreen({Key? key, required this.transaksiMmodel})
      : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  DatabaseInstance databaseInstance = DatabaseInstance();
  TextEditingController nameController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  TextEditingController tanggalController = TextEditingController();
  TextEditingController ketController = TextEditingController();
  String dropdownValue = list.first;
  int _value = 1;

  @override
  void initState() {
    // implementasi initState
    databaseInstance.database();
    tanggalController.text = widget.transaksiMmodel.createdAt!;
    ketController.text = widget.transaksiMmodel.updatedAt!;
    dropdownValue = widget.transaksiMmodel.name!;
    totalController.text = widget.transaksiMmodel.total!.toString();
    _value = widget.transaksiMmodel.type!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Update"),
          backgroundColor: Color.fromARGB(255, 1, 100, 5),
          elevation: 10.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ))),
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
                    int idInsert = await databaseInstance
                        .update(widget.transaksiMmodel.id!.toInt(), {
                      'name': dropdownValue,
                      'type': _value,
                      'total': totalController.text,
                      'created_at': tanggalController.text,
                      'updated_at': ketController.text,
                    });
                    // print("sudah masuk : " + idInsert.toString());
                    Navigator.pop(context);
                  },
                  child: Text("Simpan")),
            ],
          ),
        )),
      ),
    );
  }
}
