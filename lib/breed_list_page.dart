import 'package:flutter/material.dart';
import 'package:lovely_dog_app/dog_api.dart';
import 'package:lovely_dog_app/dog_image_page.dart';

class BreedListPage extends StatelessWidget {
  const BreedListPage({
    super.key,
    required this.dogApi,
  });

  final DogApi dogApi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<String>>(
        future: dogApi.getBreedList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var breed = snapshot.data![index];
              return GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(
                  DogImagePage.routeName,
                  arguments: breed,
                ),
                child: ListTile(
                  title: Text(breed),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
