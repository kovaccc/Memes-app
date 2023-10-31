import 'package:either_dart/either.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meme_app/common/data/generic_error_resolver.dart';
import 'package:meme_app/common/presentation/image_assets.dart';
import 'package:q_architecture/q_architecture.dart';

final imagesRepositoryProvider = Provider<ImagesRepository>(
  (
    ref,
  ) =>
      ImagesRepositoryImpl(),
);

abstract class ImagesRepository {
  EitherFailureOr<List<String>> getImageAssets();
}

class ImagesRepositoryImpl
    with ErrorToFailureMixin
    implements ImagesRepository {
  ImagesRepositoryImpl();

  @override
  EitherFailureOr<List<String>> getImageAssets() => execute(
        () async => const Right(ImageAssets.assetPaths),
        errorResolver: const GenericErrorResolver(),
      );
}
