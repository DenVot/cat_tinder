import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../states/cat_state.dart';
import 'package:provider/provider.dart';

class LikedCatsScreen extends StatelessWidget {
  const LikedCatsScreen({super.key});

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final catState = Provider.of<CatState>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Лайкнутые котики'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: catState.selectedBreed,
              hint: const Text('Выберите породу'),
              items:
                  catState.uniqueBreeds.map((breed) {
                    return DropdownMenuItem<String>(
                      value: breed,
                      child: Text(breed),
                    );
                  }).toList(),
              onChanged: (value) {
                catState.setSelectedBreed(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: catState.filteredCats.length,
              itemBuilder: (context, index) {
                final cat = catState.filteredCats[index];
                final formattedDate =
                    cat.likedAt != null
                        ? _formatDate(cat.likedAt!)
                        : 'Неизвестно';
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: CachedNetworkImage(
                      imageUrl: cat.url,
                      placeholder:
                          (context, url) => const CircularProgressIndicator(),
                      errorWidget:
                          (context, url, error) => const Icon(
                            Icons.error,
                            size: 40,
                            color: Colors.grey,
                          ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(cat.breedName),
                  subtitle: Text('Дата лайка: $formattedDate'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => catState.removeLikedCat(cat),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
