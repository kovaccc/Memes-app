import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meme_app/common/data/generic_error_resolver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:q_architecture/q_architecture.dart';

final fileRepositoryProvider = Provider<FileRepository>(
  (
    ref,
  ) =>
      FileRepositoryImpl(),
);

abstract class FileRepository {
  EitherFailureOr<File> createFileFromAsset(String asset);
}

class FileRepositoryImpl with ErrorToFailureMixin implements FileRepository {
  FileRepositoryImpl();

  @override
  EitherFailureOr<File> createFileFromAsset(String asset) => execute(
        () async {
          final byteData = await rootBundle.load(asset);
          final file = File('${(await getTemporaryDirectory()).path}/$asset');
          await file.create(recursive: true);
          await file.writeAsBytes(byteData.buffer
              .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
          return Right(file);
        },
        errorResolver: const GenericErrorResolver(),
      );
}
