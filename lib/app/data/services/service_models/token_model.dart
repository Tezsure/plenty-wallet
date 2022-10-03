class TokenModel {
  final String tokenName;
  final double price;
  final double balance;
  final String imagePath;

  TokenModel({
    required this.tokenName,
    required this.price,
    this.balance = 0,
    required this.imagePath,
  });
}
