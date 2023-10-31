import 'dart:io';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:meme_app/features/memes/data/file_repository.dart';
import 'package:meme_app/features/memes/domain/entities/memes_state.dart';
import 'package:q_architecture/base_state_notifier.dart';

final memesNotifierProvider =
    BaseStateNotifierProvider<MemesNotifier, MemesState>((ref) => MemesNotifier(
          ref,
          ref.watch(fileRepositoryProvider),
        )..initFaceDetector());

class MemesNotifier extends BaseStateNotifier<MemesState> {
  final FileRepository _fileRepository;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );

  MemesNotifier(super.ref, this._fileRepository);

  void initFaceDetector() {
    state = BaseState.data(MemesState(
      faceDetector: _faceDetector,
    ));
  }

  Future<void> filterMemes(List<String> imageAssetPaths) async {
    showGlobalLoading();
    final memesState = _getMemesDataState();
    final memes = await _findMemes(imageAssetPaths);
    state = BaseState.data(memesState.copyWith(memesFiles: memes));
    clearGlobalLoading();
  }

  @override
  void dispose() {
    final memesState = _getMemesDataState();
    memesState.faceDetector?.close();
    state = BaseState.data(memesState.copyWith(canFaceDetectorProcess: false));
    super.dispose();
  }

  Future<List<String>> _findMemes(List<String> imageAssetPaths) async {
    final memes = <String>[];
    for (final image in imageAssetPaths) {
      final file = (await _fileRepository.createFileFromAsset(image))
          .fold((left) => null, (right) => right);
      final isMeme = await _hasFaces(InputImage.fromFile(file ?? File('')));
      if (isMeme) {
        memes.add(image);
      }
    }
    return memes;
  }

  Future<List<Face>?> _detectFaces(InputImage inputImage) async {
    var memesState = _getMemesDataState();
    if (!memesState.canFaceDetectorProcess || memesState.isFaceDetectorBusy) {
      return [];
    }
    state = BaseState.data(memesState.copyWith(isFaceDetectorBusy: true));
    memesState = _getMemesDataState();
    final faces = await memesState.faceDetector?.processImage(inputImage);
    String text = 'Faces found: ${faces?.length}\n\n';
    for (final face in (faces ?? [])) {
      text += 'face: ${face.boundingBox}\n\n';
    }
    state = BaseState.data(memesState.copyWith(isFaceDetectorBusy: false));
    return faces;
  }

  Future<bool> _hasFaces(InputImage inputImage) async {
    final faces = await _detectFaces(inputImage);
    return faces?.isNotEmpty ?? false;
  }

  MemesState _getMemesDataState() {
    return switch (state) {
          BaseData(data: final data) => data,
          _ => null,
        } ??
        MemesState(faceDetector: _faceDetector);
  }
}
