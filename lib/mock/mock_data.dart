import 'package:naan_wallet/models/nft_token_model.dart';
import 'package:naan_wallet/models/tokens_model.dart';

class MockData {
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
