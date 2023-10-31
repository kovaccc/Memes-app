import 'package:equatable/equatable.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class MemesState extends Equatable {
  final FaceDetector? faceDetector;
  final TextRecognizer? textDetector;
  final List<String>? memesFiles;
  final bool canFaceDetectorProcess;
  final bool canTextDetectorProcess;
  final bool isFaceDetectorBusy;
  final bool isTextDetectorBusy;

  const MemesState({
    required this.faceDetector,
    required this.textDetector,
    this.canFaceDetectorProcess = true,
    this.canTextDetectorProcess = true,
    this.isFaceDetectorBusy = false,
    this.isTextDetectorBusy = false,
    this.memesFiles,
  });

  MemesState copyWith({
    FaceDetector? faceDetector,
    TextRecognizer? textDetector,
    bool? canFaceDetectorProcess,
    bool? canTextDetectorProcess,
    bool? isFaceDetectorBusy,
    bool? isTextDetectorBusy,
    List<String>? memesFiles,
  }) {
    return MemesState(
      faceDetector: faceDetector ?? this.faceDetector,
      textDetector: textDetector ?? this.textDetector,
      canFaceDetectorProcess:
          canFaceDetectorProcess ?? this.canFaceDetectorProcess,
      canTextDetectorProcess:
          canTextDetectorProcess ?? this.canTextDetectorProcess,
      isFaceDetectorBusy: isFaceDetectorBusy ?? this.isFaceDetectorBusy,
      isTextDetectorBusy: isTextDetectorBusy ?? this.isTextDetectorBusy,
      memesFiles: memesFiles ?? this.memesFiles,
    );
  }

  @override
  List<Object?> get props => [
        faceDetector,
        textDetector,
        canFaceDetectorProcess,
        canTextDetectorProcess,
        isFaceDetectorBusy,
        isTextDetectorBusy,
        memesFiles,
      ];
}
