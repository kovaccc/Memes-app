import 'package:equatable/equatable.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class MemesState extends Equatable {
  final FaceDetector? faceDetector;
  final List<String>? memesFiles;
  final bool canFaceDetectorProcess;
  final bool isFaceDetectorBusy;

  const MemesState({
    required this.faceDetector,
    this.canFaceDetectorProcess = true,
    this.isFaceDetectorBusy = false,
    this.memesFiles,
  });

  MemesState copyWith({
    FaceDetector? faceDetector,
    bool? canFaceDetectorProcess,
    bool? isFaceDetectorBusy,
    List<String>? memesFiles,
  }) {
    return MemesState(
      faceDetector: faceDetector ?? this.faceDetector,
      canFaceDetectorProcess:
          canFaceDetectorProcess ?? this.canFaceDetectorProcess,
      isFaceDetectorBusy: isFaceDetectorBusy ?? this.isFaceDetectorBusy,
      memesFiles: memesFiles ?? this.memesFiles,
    );
  }

  @override
  List<Object?> get props => [
        faceDetector,
        canFaceDetectorProcess,
        isFaceDetectorBusy,
        memesFiles,
      ];
}
