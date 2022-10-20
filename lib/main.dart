import 'package:flutter/material.dart';
import 'package:aplikasi_caku/database/database_instance.dart';
import 'package:aplikasi_caku/models/transaksi_model.dart';
import 'package:aplikasi_caku/screens/create_screen.dart';
import 'package:aplikasi_caku/screens/update_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CaKu: Catatan Keuangan",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseInstance? databaseInstance;

  Future _refresh() async {
    setState(() {});
  }

  @override
  void initState() {
    databaseInstance = DatabaseInstance();
    initDatabase();
    super.initState();
  }

  Future initDatabase() async {
    await databaseInstance!.database();
    setState(() {});
  }

  showAlertDialog(BuildContext contex, int idTransaksi) {
    Widget okButton = TextButton(
      child: Text("Yakin"),
      onPressed: () {
        //delete disini
        databaseInstance!.hapus(idTransaksi);
        Navigator.of(contex, rootNavigator: true).pop();
        setState(() {});
      },
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text("Peringatan!"),
      content: Text("Apakah yakin ingin menghapus?"),
      actions: [okButton],
    );

    showDialog(
        context: contex,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home CaKu"),
        backgroundColor: Color.fromARGB(255, 1, 100, 5),
        elevation: 10.0,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => CreateScreen()))
                  .then((value) {
                setState(() {});
              });
            },
          )
        ],
      ),

      body: Container(
        color: Color.fromARGB(255, 211, 255, 212),
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: SafeArea(
              child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              FutureBuilder(
                  future: databaseInstance!.totalPemasukan(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("-");
                    } else {
                      if (snapshot.hasData) {
                        return Text(
                            "Total pemasukan : Rp. ${snapshot.data.toString()}");
                      } else {
                        return Text("");
                      }
                    }
                  }),
              SizedBox(
                height: 20,
              ),
              FutureBuilder(
                  future: databaseInstance!.totalPengeluaran(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("-");
                    } else {
                      if (snapshot.hasData) {
                        return Text(
                            "Total pengeluaran : Rp. ${snapshot.data.toString()}");
                      } else {
                        return Text("");
                      }
                    }
                  }),
              FutureBuilder<List<TransaksiModel>>(
                  future: databaseInstance!.getAll(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    } else {
                      if (snapshot.hasData) {
                        return Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  margin: EdgeInsets.only(
                                      top: 10, left: 10, right: 10),
                                  child: ListTile(
                                      title: Text(snapshot.data![index].name!),
                                      subtitle: Text(snapshot.data![index].createdAt.toString() + "\n" + snapshot.data![index].total!.toString() +
                                          "\n" + snapshot.data![index].updatedAt!.toString()),
                                      leading: snapshot.data![index].type == 1
                                          ? Icon(
                                              Icons.arrow_upward,
                                              color: Colors.green,
                                            )
                                          : Icon(
                                              Icons.arrow_downward,
                                              color: Colors.red,
                                            ),
                                      trailing: Wrap(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => UpdateScreen(
                                                    transaksiMmodel: snapshot.data![index],
                                                            )))
                                                    .then((value) {
                                                  setState(() {});
                                                });
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                color: Colors.grey,
                                              )),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                showAlertDialog(context,
                                                    snapshot.data![index].id!);
                                              },
                                              icon: Icon(Icons.delete,
                                                  color: Colors.red))
                                        ],
                                      )),
                                );
                              }),
                        );
                      } else {
                        return Text("Tidak ada data");
                      }
                    }
                  })
            ],
          )),
        ),
      ),
    );
  }
}
