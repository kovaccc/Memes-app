const String imagePath = 'assets/images';

abstract class ImageAssets {
  static const String aliImage = '$imagePath/ali_image.jpeg';
  static const String imageFileName = '$imagePath/meme1.jpeg';
  static const String memeExampleImage = '$imagePath/meme-example.jpg';
  static const String targetMarketMeme = '$imagePath/target-market-meme.png';
  static const String tysonImage = '$imagePath/tyson.jpeg';
  static const String woodImage = '$imagePath/wood.jpeg';

  static const List<String> assetPaths = [
    woodImage,
    imageFileName,
    memeExampleImage,
    tysonImage,
    targetMarketMeme,
    aliImage,
  ];
}
