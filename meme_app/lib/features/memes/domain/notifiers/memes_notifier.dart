import 'dart:io';

import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:loggy/loggy.dart';
import 'package:meme_app/common/presentation/image_assets.dart';
import 'package:meme_app/features/memes/domain/entities/memes_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:q_architecture/base_state_notifier.dart';

final memesNotifierProvider =
    BaseStateNotifierProvider<MemesNotifier, MemesState>((ref) => MemesNotifier(
          ref,
        )..initFaceDetector());

class MemesNotifier extends BaseStateNotifier<MemesState> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );

  MemesNotifier(super.ref);

  void initFaceDetector() {
    state = BaseState.data(MemesState(
      faceDetector: _faceDetector,
      allFiles: ImageAssets.assetPaths,
    ));
  }

  Future<void> processImages() async {
    showGlobalLoading();
    final memesState = switch (state) {
          BaseData(data: final data) => data,
          _ => null,
        } ??
        MemesState(faceDetector: _faceDetector);
    final images = memesState.allFiles ?? [];
    final memes = <String>[];
    for (final image in images) {
      final byteData = await rootBundle.load(image);

      final file = File('${(await getTemporaryDirectory()).path}/$image');
      await file.create(recursive: true);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      final isMeme = await _processImage(InputImage.fromFile(file));
      if (isMeme) {
        memes.add(image);
      }
    }
    state = BaseState.data(memesState.copyWith(memesFiles: memes));
    clearGlobalLoading();
  }

  @override
  void dispose() {
    final memesState = switch (state) {
      BaseData(data: final data) => data,
      _ => null,
    };
    memesState?.faceDetector?.close();
    if (memesState != null) {
      state =
          BaseState.data(memesState.copyWith(canFaceDetectorProcess: false));
    }
    super.dispose();
  }

  Future<bool> _processImage(InputImage inputImage) async {
    final memesState = switch (state) {
          BaseData(data: final data) => data,
          _ => null,
        } ??
        MemesState(faceDetector: _faceDetector);
    if (!memesState.canFaceDetectorProcess) return false;
    if (memesState.isFaceDetectorBusy) return false;
    state = BaseState.data(memesState.copyWith(isFaceDetectorBusy: true));
    final faces = await _faceDetector.processImage(inputImage);
    String text = 'Faces found: ${faces.length}\n\n';
    for (final face in faces) {
      text += 'face: ${face.boundingBox}\n\n';
    }
    logDebug('Faces result: $text');
    state = BaseState.data(memesState.copyWith(isFaceDetectorBusy: false));
    return faces.isNotEmpty;
  }
}
