import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:meme_app/features/memes/data/repositories/memes_repository.dart';
import 'package:meme_app/common/data/api_client.dart';

//ignore: prefer-match-file-name

class MockApiClient extends Mock implements ApiClient {} 

void main() {
  late ApiClient apiClient;
  
  late MemesRepository memesRepository;
  setUp(() {
    apiClient = MockApiClient();
    
    memesRepository = MemesRepositoryImpl(apiClient, );
  });

    
    
    group('images', () {
      test('executes success flow', () async {
        // final value = memesRepository.images;
        //expect(value, equals(smth));
      });

      test('executes failure flow', () async {
        // final value = memesRepository.images;
        //expect(value, equals(smth));
      });
    });
    

}
