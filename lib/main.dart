import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lovely_dog_app/breed_list_page.dart';
import 'package:lovely_dog_app/dog_api.dart';
import 'package:lovely_dog_app/dog_image_page.dart';

void main() {
  runApp(MainApp(dogApi: DogApi(client: Client())));
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
    required this.dogApi,
  });

  final DogApi dogApi;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        if (settings.name == DogImagePage.routeName) {
          return MaterialPageRoute(
            builder: (context) => DogImagePage(
              dogApi: dogApi,
              breed: settings.arguments as String,
            ),
          );
        }
        return null;
      },
      home: BreedListPage(dogApi: dogApi),
    );
  }
}
