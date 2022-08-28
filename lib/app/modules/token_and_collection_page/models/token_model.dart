class TokenModel {
  final String tokenName;
  final double price;
  final double balance;

  TokenModel({required this.tokenName, required this.price, this.balance = 0});
}
