import 'package:meme_app/features/memes/data/images_repository.dart';
import 'package:q_architecture/base_state_notifier.dart';

final imagesNotifierProvider =
    BaseStateNotifierProvider<ImagesNotifier, List<String>>(
  (ref) =>
      ImagesNotifier(ref.watch(imagesRepositoryProvider), ref)..loadImages(),
);

class ImagesNotifier extends BaseStateNotifier<List<String>> {
  final ImagesRepository _imagesRepository;

  ImagesNotifier(this._imagesRepository, super.ref);

  void loadImages() => execute(_imagesRepository.getImageAssets());
}
