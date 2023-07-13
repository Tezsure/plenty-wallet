import 'package:plenty_wallet/models/tokens_model.dart';

class MockData {
  static const Map<String, String> walletInfo = {
    "What is a Secret Phrase?":
        "A secret phrase, also known as a seed phrase or recovery phrase, is a set of words that acts as a backup for your cryptocurrency wallet. If you lose access to your device or forget your password, you can use the secret phrase to restore your funds. It's important to keep your secret phrase safe and secure as it gives control over your funds to whoever has access to it.",
    "What is a Private Key?":
        "A private key is a unique code that is used to access and manage funds in a cryptocurrency account. It's generated from a secret phrase and is required to perform transactions, transfer funds, and access the assets stored in your account. Keep your private key safe and secure, as anyone with access to it can control and use your funds without your permission.",
    "What's the difference between a Secret Phrase and a Private Key?":
        "The secret phrase and private key are related to your cryptocurrency account. The secret phrase is used to create the private key, and it helps you access your funds if you lose your device or forget your password. The private key, on the other hand, is used to control and use your funds. It's important to keep both your secret phrase and private key safe and not share them with anyone.",
    "What is a Public Key?":
        "A public key is a unique code generated from your private key. It's used to receive funds from other users and is often represented as a string of numbers and letters. A public key can be safely shared with others and is used to identify your wallet for incoming transactions. The public key and private key work together to ensure the secure transfer of funds within a cryptocurrency network.",
    "Can I switch from my existing wallet app like Temple, Kukai, Airgap, etc.?":
        "Yes, you can switch from your existing wallet or use multiple wallet apps at the same time by using the same secret phrase or private key. You can import your private key into Plenty Wallet by locating the 12 word (or 24 word) recovery phrase in the settings menu of your current wallet app.",
    "How do I protect against losing access to my funds?":
        "To protect your funds, you should keep your secret phrase and private key safe and secure, store multiple backups of your secret phrase (preferably encrypted) in different locations, regularly transfer your funds to new accounts, and stay informed about best practices for keeping your cryptocurrency and NFTs secure.",
    "What is a Watch Address?":
        "A watch address is a public address for a cryptocurrency account that you can monitor without having access to the private key that controls it. You can use a watch address to keep track of payments and NFTs received from other users, but you can't use it to make transactions or move funds from the address.",
  };

  static const Map<String, String> watchAddress = {
    "What is a watch address?":
        "A watch address is like adding someone to your friends list on social media. It lets you see all their online activity but you can't post anything on their account. Similarly, adding a watch address to your wallet lets you see all the transactions happening with that address, but you can't make any transactions from it. This is useful because all transactions on the blockchain are public, so you can see your friend's NFTs and collectibles just by knowing their watch address.",
    "What is Tezos domain address?":
        "A Tezos domain address, also called a \"TZ domain,\" is a name that is easier to remember and share than a long string of characters that represent a Tezos wallet address. For example, instead of using tz1Uox91evyMrCvQ5dabegEDCekNiKMdz12K, you can create an alias like \"john.tez\". This name can replace the long string of characters to represent the address. You can register a Tezos domain address on https://tezos.domains",
    "What is a tz1 or tz2 address?":
        "In Tezos, a tz1 or tz2 address is a type of address used to represent a user's account ID. It's like having a username that everyone can see. You can use these addresses to send and receive Tezos tokens, delegate tokens for staking, and interact with smart contracts on the Tezos blockchain. So, it's an important way to identify your account and do things with your Tezos tokens.",
    "Can I add a Tezos address from my Nano Ledger as a watch address?":
        "Yes! You can add your Ledger account as a watch address in naan. This means you can see your NFTs, collectibles, and transaction history without connecting your Ledger device or entering your private key. It's like looking at your account balance without having to log in. You can also add other cold storage addresses as watch addresses. But remember, you can't send or receive cryptocurrency from the account.",
  };

  static const Map<String, String> naanInfoStory = {
    "Importing wallet": "assets/home_page/info_story/story_1.svg",
    "Add funds": "assets/home_page/info_story/story_2.svg",
    "Receiving funds": "assets/home_page/info_story/story_3.svg",
    "Liquidity Baking": "assets/home_page/info_story/story_4.svg",
  };

  List<TokensModel> listOfTokens = [
    TokensModel(
        symbol: "XTZ", name: "Tezos", balance: "1345.67", priceChange: "12.50"),
    TokensModel(
        symbol: "AXS",
        name: "Axie Infinity",
        balance: "349.25",
        priceChange: "250"),
    TokensModel(
        symbol: "XRP",
        name: "Ripple",
        balance: "1428.25",
        priceChange: "12.50"),
  ];

  List<HeadlineModel> tezosHeadlineList = [
    HeadlineModel(
      "Are Planets with Oceans Common in and they are in danger of becoming a new age game",
      "",
    ),
    HeadlineModel(
      "Stunning New Hubble Images RevealAre Planets with Oceans Common in and they are in danger of ",
      "",
    ),
    HeadlineModel(
      "Stunning New Hubble Images RevealAre Planets with Oceans Common in and they are in danger of ",
      "",
    ),
    HeadlineModel(
      "Are Planets with Oceans Common in and they are in danger of becoming a new age game",
      "",
    ),
  ];
}

class HeadlineModel {
  String desc;
  String url;

  HeadlineModel(this.desc, this.url);
}
