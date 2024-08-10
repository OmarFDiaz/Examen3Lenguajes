import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examen3/firebase_crud.dart';
import 'package:examen3/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  final votinglist = FirebaseFirestore.instance.collection('od_voting');
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('vote!'),
      ),
      body: FutureBuilder(
        future: votinglist.get(), 
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }
            final query = snapshot.data;

            final list = query!.docs;

            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
              final albums = list[index];
              final data = albums.data();
              return ListTile(
                title: Text(data['nombre_album'] + ' - ' + data['nombre_banda']),
                subtitle: Text(data['anio_lanzamiento']),
                trailing: Text(data['votes'].toString()),
                
                onTap: () {
                  FirebaseCrud().update(list[index].id, data['votes'] + 1);
                },
              );

             },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            final test = {
              'nombre_album': 'The New Abnormal',
              'nombre_banda': 'The Strokes',
              'anio_lanzamiento': '2020',
              'votes': 0,
            };
            FirebaseCrud().create(test);
          },
          tooltip: 'vote',
          child: const Icon(Icons.add),
          ),
        );
  }
}



