// ignore_for_file: always_use_package_imports
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meme_app/features/memes/domain/notifiers/images_notifier.dart';
import 'package:meme_app/features/memes/domain/notifiers/memes_notifier.dart';
import 'package:q_architecture/base_state_notifier.dart';

class MemesPage extends ConsumerWidget {
  static const routeName = '/login';

  const MemesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memesState = switch (ref.watch(memesNotifierProvider)) {
      BaseData(data: final data) => data,
      _ => null,
    };
    final imagesState = switch (ref.watch(imagesNotifierProvider)) {
      BaseData(data: final data) => data,
      _ => null,
    };
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'All Files',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (imagesState != null)
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: imagesState.length,
                  itemBuilder: (context, index) =>
                      Image.asset(imagesState[index]),
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              'Meme Files',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (memesState != null && memesState.memesFiles != null)
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: memesState.memesFiles?.length,
                  itemBuilder: (context, index) =>
                      Image.asset(memesState.memesFiles![index]),
                ),
              ),
            ElevatedButton(
              onPressed: () => ref
                  .read(memesNotifierProvider.notifier)
                  .filterMemes(imagesState ?? []),
              child: const Text(
                'Filter Memes',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
