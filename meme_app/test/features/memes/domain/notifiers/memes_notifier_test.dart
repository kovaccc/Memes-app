import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:q_architecture/q_architecture.dart';
import 'package:state_notifier_test/state_notifier_test.dart';

import 'package:meme_app/features/memes/domain/entities/meme.dart';
import 'package:meme_app/features/memes/domain/notifiers/memes_notifier.dart';

//ignore: prefer-match-file-name


void main() {
  
  late ProviderContainer providerContainer;

  setUp(() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  });

  ProviderContainer getProviderContainer() => ProviderContainer(overrides: [
    memesNotifierProvider.overrideWith((ref) =>
      MemesNotifier(ref)),
  ]);

  
}
