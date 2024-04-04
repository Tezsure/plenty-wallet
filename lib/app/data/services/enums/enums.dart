/// Account profile image type assests for local images and file is user choose image from gallery or take a photo
enum AccountProfileImageType {
  assets,
  file,
}

/// Import wallet data type defines the account import type which user trying to import
enum ImportWalletDataType {
  privateKey,
  watchAddress,
  mnemonic,
  tezDomain,
  none,
  ethPrivateKey,
}

/// Token Type fa1.2/fa2
enum TokenStandardType { fa1, fa2 }
