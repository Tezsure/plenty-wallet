class AppConstant {
  static const String defaultUrl = 'https://dapps-naan.netlify.app/';
  static List<Dapp> dapps = [
    Dapp(
        name: "Ctez",
        url: "https://ctez.app/",
        description: "Ctez description here",
        image: "assets/dapps/ctez.png"),
    Dapp(
      name: "FxHash",
      description: "Fxhash description here",
      url: "https://www.fxhash.xyz/",
      image: "assets/dapps/fxhash.png",
    ),
    Dapp(
      name: "Kolibri",
      description: "Kolibri description here",
      url: "https://kolibri.finance/",
      image: "assets/dapps/kolibri.png",
    ),
    Dapp(
      name: "Objkt",
      description: "Objkt description here",
      url: "https://objkt.com/",
      image: "assets/dapps/objkt.png",
    ),
    Dapp(
      name: "Plenty Defi",
      description: "Plenty description here",
      url: "https://plentydefi.com/",
      image: "assets/dapps/plenty.png",
    ),
    Dapp(
      name: "Quipuswap",
      description: "Quipu description here",
      url: "https://quipuswap.com/",
      image: "assets/dapps/quipu.png",
    ),
    Dapp(
      name: "Sirius",
      description: "Sirius description here",
      url: "https://tzkt.io/KT1TxqZ8QtKvLu3V3JH7Gx58n7Co8pgtpQU5/dex/",
      image: "assets/dapps/sirius.png",
    ),
    Dapp(
      name: "Teia",
      description: "Teia description here",
      url: "https://teia.art/",
      image: "assets/dapps/teia.png",
    ),
    Dapp(
      name: "Tezos Domains",
      description: "Tezos domaians description here",
      url: "https://tezos.domains/",
      image: "assets/dapps/tezos_domain.png",
    ),
    Dapp(
      name: "Tezotapia",
      description: "Tezotapia description here",
      url: "https://tezotopia.com/",
      image: "assets/dapps/tezotapia.png",
    ),
    Dapp(
      name: "Versum",
      description: "Versum description here",
      url: "https://versum.xyz/",
      image: "assets/dapps/versum.png",
    ),
    Dapp(
      name: "Youves",
      description: "Youves description here",
      url: "https://youves.com/",
      image: "assets/dapps/youves.png",
    ),
  ];
}

class Dapp {
  String name;
  String url;
  String description;
  String image;

  Dapp(
      {required this.name,
      required this.url,
      required this.description,
      required this.image});
}
