
import 'package:flutter/material.dart';
import 'package:lovely_dog_app/dog_api.dart';

class DogImagePage extends StatelessWidget {
  static const routeName = "/dog_image";

  final DogApi dogApi;
  final String breed;

  const DogImagePage({
    Key? key,
    required this.dogApi,
    required this.breed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<String>(
            future: dogApi.getDogImage(breed),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              return Image.network(snapshot.data!);
            }),
      ),
    );
  }
}
