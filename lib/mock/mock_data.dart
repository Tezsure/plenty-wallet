import 'package:naan_wallet/models/nft_token_model.dart';
import 'package:naan_wallet/models/tokens_model.dart';

class MockData {
  static const List<String> secretPhrase = [
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

  static const Map<String, String> walletInfo = {
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

  List<NFTToken> listOfNFTTokens = [
    NFTToken(
      name: "LUCID DREAM",
      displayUri:
          "https://assets.objkt.media/file/assets-003/QmVtWBVqYXCbbZR8htLh5smEPGWDgxaJkAojxAMZGG5KVW/thumb400",
      description:
          "Fill in the token amount you wish to send. The flat value auto-populates. ",
      creators: [
        Creators(
          creatorAddress: "tz1TCAF7vUmYV5AinJrNhdEhzHds3hhEsxg5",
        ),
      ],
      holders: [
        Holders(
          holderAddress: "tz1TCAF7vUmYV5AinJrNhdEhzHds3hhEsxg5",
          quantity: 2,
        ),
      ],
      supply: 20,
      lowestAsk: 1000000,
      fa: Fa(name: "objkt.com"),
    ),
    NFTToken(
      name: "MISSION ACCOMPLISHED",
      displayUri:
          "https://assets.objkt.media/file/assets-003/QmVSiyzPFiSF62MKnoDFuonatzawHYhuEuzMC2Nk1Pix5D/thumb400",
      description:
          "Fill in the token amount you wish to send. The flat value auto-populates. ",
      creators: [
        Creators(
          creatorAddress: "tz1TCAF7vUmYV5AinJrNhdEhzHds3hhEsxg5",
        ),
      ],
      holders: [
        Holders(
          holderAddress: "tz1TCAF7vUmYV5AinJrNhdEhzHds3hhEsxg5",
          quantity: 2,
        ),
      ],
      supply: 20,
      lowestAsk: 1000000,
      fa: Fa(name: "objkt.com"),
    ),
    NFTToken(
      name: "ENCOUNTER",
      displayUri:
          "https://assets.objkt.media/file/assets-003/QmXiokwFsrMqRDdFLssX3HDAxd1yggK6vThnJwmf93dLn1/thumb400",
      description:
          "Fill in the token amount you wish to send. The flat value auto-populates. ",
      creators: [
        Creators(
          creatorAddress: "tz1TCAF7vUmYV5AinJrNhdEhzHds3hhEsxg5",
        ),
      ],
      holders: [
        Holders(
          holderAddress: "tz1TCAF7vUmYV5AinJrNhdEhzHds3hhEsxg5",
          quantity: 2,
        ),
      ],
      supply: 20,
      lowestAsk: 1000000,
      fa: Fa(name: "objkt.com"),
    ),
    NFTToken(
      name: "NIGHT SOULS",
      displayUri:
          "https://assets.objkt.media/file/assets-003/QmVwWmuc8Xhttgvv7LRDYKCEgpdMC7ZWbLiJoTqbLuyumr/thumb400",
      description:
          "Fill in the token amount you wish to send. The flat value auto-populates. ",
      creators: [
        Creators(
          creatorAddress: "tz1TCAF7vUmYV5AinJrNhdEhzHds3hhEsxg5",
        ),
      ],
      holders: [
        Holders(
          holderAddress: "tz1TCAF7vUmYV5AinJrNhdEhzHds3hhEsxg5",
          quantity: 2,
        ),
      ],
      supply: 20,
      lowestAsk: 1000000,
      fa: Fa(name: "objkt.com"),
    ),
    NFTToken(
      name: "SLEEPLESS NIGHT",
      displayUri:
          "https://assets.objkt.media/file/assets-003/QmcKbENyTuN9pBAPRzZbURJV5Vg31oXwLfbAwzJfGrRUTY/thumb400",
      description:
          "Fill in the token amount you wish to send. The flat value auto-populates. ",
      creators: [
        Creators(
          creatorAddress: "tz1TCAF7vUmYV5AinJrNhdEhzHds3hhEsxg5",
        ),
      ],
      holders: [
        Holders(
          holderAddress: "tz1TCAF7vUmYV5AinJrNhdEhzHds3hhEsxg5",
          quantity: 2,
        ),
      ],
      supply: 20,
      lowestAsk: 1000000,
      fa: Fa(name: "objkt.com"),
    ),
  ];
}

class HeadlineModel {
  String desc;
  String url;

  HeadlineModel(this.desc, this.url);
}
