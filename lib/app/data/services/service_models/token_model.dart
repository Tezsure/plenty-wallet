class TokenModel {
  final String tokenName;
  final double price;
  final double balance;
  final String imagePath;
  bool isPinned;
  bool isHidden;
  bool isSelected;

  TokenModel({
    required this.tokenName,
    required this.price,
    this.balance = 0,
    required this.imagePath,
    this.isPinned = false,
    this.isHidden = false,
    this.isSelected = false,
  });
}
