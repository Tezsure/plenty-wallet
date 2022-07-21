import 'package:get/get.dart';

class BackupWalletController extends GetxController {
  List<String> get secretPhrase => [
        'car',
        'approve',
        'human',
        'armed',
        'worry',
        'matter',
        'dynamic',
        'innocent',
        'food',
        'awake',
        'spare',
        'time'
      ];

  Map<String, String> get walletInfo => {
        "1. What is Secret Phrase?":
            "Secret Recovery Phrase is a unique 12-word phrase that is generated when you first set up MetaMask. Your funds are connected to that phrase. If you ever lose your password, your Secret Recovery Phrase allows you to recover your wallet and your funds. Write it down on paper and hide it somewhere, put it in a safety deposit box, or use a secure password manager. Some users even engrave their phrases into metal plates!",
        "2. Can I switch from my existing wallet app like Temple, Kukai, Airgap,etc.?":
            "Yes, you can. Every wallet uses a private key to secure its assets which you can import into Naan Wallet. Just look for the 12 word recovery phrase or mnemonic in the settings menu of your current wallet and then use that same 12 word phrase to sign into Coinbase Wallet.",
        "3. How do I protect against losing access to my funds?":
            "Yes, you can. Every wallet uses a private key to secure its assets which you can import into Naan Wallet. Just look for the 12 word recovery phrase or mnemonic in the settings menu of your current wallet and then use that same 12 word phrase to sign into Coinbase Wallet.",
        "4. What is a Private Key?":
            "A private key, which is typically a string of letters and numbers (and which is not to be shared with anyone). You can think of the private key as a password that unlocks the virtual vault that holds your money. As long as you — and only you — have access to your private key, your funds are safe and can be managed anywhere in the world with an internet connection.",
        "5. What is a Public Key?":
            "A string of letters and numbers that a wallet owner sends to people in order to receive cryptocurrencies or NFTs. Like sending someone your email address, a public key can be provided to others that wish to send you cryptocurrencies or NFTs. All public key addresses correspond to a private key that is used to authorize the owner of the public key to spend funds from that wallet address.",
        "6. What is a Watch Address?":
            "A Watch Address is basically the receiving address or wallet address. Importing any supported Cryptocurrency address will allow you to view the tokens and collectibles, as well as transactions associated with the said address. When importing your address, you cannot do any transactions with the wallet.",
      };
}
