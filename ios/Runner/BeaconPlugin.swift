import Foundation
import BeaconCore
import BeaconBlockchainTezos
import BeaconClientWallet
import BeaconTransportP2PMatrix


class BeaconController {
    private static var address: String = ""
    
    private var client: Beacon.WalletClient?
    //    private var address:String?
    private var awaitingRequest: BeaconRequest<Tezos>? = nil
    @Published private(set) var beaconRequest: String? = nil
    //   var onNewRequest: (Any) -> ()?
    
    func startBeacon(address: String, onInitCompleted: @escaping ((Bool)->())) {
        BeaconController.address = address
        do {
            Beacon.WalletClient.create(
                with: .init(
                    name: "Naan",
                    blockchains: [Tezos.factory],
                    connections: [try Transport.P2P.Matrix.connection()]
                )
            ) { result in
                switch result {
                case let .success(client):
                    self.client = client
                    print("Beacon client created")
                    //               self.listenForRequests()
                    self.checkForPeers()
                    onInitCompleted(true)
                    break
                    //                self.listenForBeaconMessages()
                case .failure(_):
                    onInitCompleted(false)
                    break
                }
            }
        } catch {
            print("Could not create Beacon client, got error: \(error)")
        }
    }
    
    private func createTezosAccount(publicKey: String,address: String,network: Tezos.Network) throws -> Tezos.Account {
        try Tezos.Account(
            publicKey: publicKey,
            address: address,
            network: network
        )
    }
    
    func addPeer(id: String, name: String, publicKey: String, relayServer: String, version: String) {
        let peer = Beacon.P2PPeer(id: id, name: name, publicKey: publicKey, relayServer: relayServer, version: version, icon: nil, appURL: nil)
        self.client?.add([.p2p(peer)]) { result in
            switch result {
            case .success(_):
                print("Peer added")
                break
            case let .failure(error):
                print("Could not add the peer, got error: \(error)")
                break
            }
        }
    }
    
    
    private func checkForPeers() {
        
    }
    
    
    var allPeers: [Beacon.P2PPeer] = []
    
    func resumeListing(){
        self.allPeers.forEach {
            peer in
            self.client?.add([.p2p(peer)]) { result in
                switch result {
                case .success(_):
                    print("Peer added")
                    break
                case let .failure(error):
                    print("Could not add the peer, got error: \(error)")
                    break
                }
            }
        }
        self.allPeers = []
    }
    
    
    func listenForRequests(onMessage: @escaping ((Data)->())) {
        client?.connect { result in
            switch result {
            case .success(_):
                print("Beacon client connected")
                self.client?.listen(onRequest: {result in self.onBeaconRequest(result: result, onMessage: onMessage)})
            case let .failure(error):
                print("Error while connecting for messages \(error)")
            }
        }
    }
    
    private func onBeaconRequest(result: Result<BeaconRequest<Tezos>, Beacon.Error>,onMessage: @escaping ((Data)->())) {
        switch result {
        case let .success(request):
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            let data = try? encoder.encode(request)
            
            DispatchQueue.main.async {
                self.beaconRequest = data.flatMap { String(data: $0, encoding: .utf8) }
                self.awaitingRequest = request
                onMessage(data!)
            }
        case let .failure(error):
            print("Error while processing incoming messages: \(error)")
            break
        }
    }
    
    func sendResponse(isGranted: String, txHash: String, accountAddress: String) {
        guard let request = awaitingRequest else {
            return
        }
        
        beaconRequest = nil
        awaitingRequest = nil
        
        client?.respond(with: response(from: request,isGranted: isGranted,txHash: txHash,accountAddress: accountAddress)) { result in
            switch result {
            case .success(_):
                print("Sent the response")
            case let .failure(error):
                print("Failed to send the response, got error: \(error)")
            }
        }
    }
    
    private func response(from request: BeaconRequest<Tezos>,isGranted: String, txHash: String, accountAddress: String) -> BeaconResponse<Tezos> {
        //        if isGranted == "0" {
        //            switch request {
        //            case let .blockchain(blockchain):
        //                switch blockchain {
        //                default:
        //                    return .error(ErrorBeaconResponse(from: blockchain, errorType: .aborted))
        //                }
        //            }
        //
        //        }else{
        switch request {
        case let .permission(content):
            if isGranted == "0" {
                return .error(ErrorBeaconResponse(from: content,errorType: .aborted))
            }
            return .permission(
                try! PermissionTezosResponse(from: content, account: createTezosAccount(publicKey: txHash, address: accountAddress, network: content.network))
            )
        case let .blockchain(blockchain):
            switch blockchain {
            case let .operation(operation):
                return .blockchain(.operation(OperationTezosResponse(from: operation, transactionHash: txHash)))
            case let .signPayload(content):
                return .blockchain(.signPayload(SignPayloadTezosResponse(from: content, signature: txHash)))
            default:
                return .error(ErrorBeaconResponse(from: blockchain, errorType: .aborted))
            }
        }
        //        }
        
    }
    
    
}
extension BeaconRequest: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        if let tezosRequest = self as? BeaconRequest<Tezos> {
            switch tezosRequest {
            case let .permission(content):
                try content.encode(to: encoder)
            case let .blockchain(blockchain):
                switch blockchain {
                case let .operation(content):
                    try content.encode(to: encoder)
                case let .signPayload(content):
                    try content.encode(to: encoder)
                case let .broadcast(content):
                    try content.encode(to: encoder)
                }
            }
        } else {
            throw Error.unsupportedBlockchain
        }
    }
    
    enum Error: Swift.Error {
        case unsupportedBlockchain
    }
    
//    public func encode(to encoder: Encoder) throws {
//        switch self {
//        case let .permission(content):
//            try content.encode(to: encoder)
//        case let .blockchain(blockchain):
//            switch blockchain {
//            case let .operation(content):
//                try content.encode(to: encoder)
//            case let .signPayload(content):
//                try content.encode(to: encoder)
//            case let .broadcast(content):
//                try content.encode(to: encoder)
//            }
//        }
//    }
}
