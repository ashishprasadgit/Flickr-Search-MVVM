import ReactiveCocoa
import ReactiveSwift
import ReachabilitySwift
import Moya
import enum Result.NoError

public typealias NoError = Result.NoError

func logPath() -> URL {
    let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    return docs.appendingPathComponent("logger.txt")
}

let logger = Logger(destination: logPath())

private let reachabilityManager = ReachabilityManager()

// An observable that completes when the app gets online (possibly completes immediately).
func connectedToInternetOrStubbing() -> SignalProducer<Bool, NoError> {
    let (reachable, _) = reachabilityManager!.reachableSignal
    return reachable.producer
}

func responseIsOK(_ response: Response) -> Bool {
    return response.statusCode == 200
}


func detectDevelopmentEnvironment() -> Bool {
    var developmentEnvironment = false
    #if DEBUG || (arch(i386) || arch(x86_64)) && os(iOS)
        developmentEnvironment = true
    #endif
    return developmentEnvironment
}

private class ReachabilityManager {
    private let reachability: Reachability

    let reachableSignal = Signal<Bool, NoError>.pipe()

    init?() {
        guard let r = Reachability() else {
            return nil
        }
        self.reachability = r

        do {
            try self.reachability.startNotifier()
        } catch {
            return nil
        }
        
        let (_, observer) = reachableSignal

        observer.send(value: self.reachability.isReachable)

        self.reachability.whenReachable = { _ in
            DispatchQueue.main.async { observer.send(value: true) }
        }

        self.reachability.whenUnreachable = { _ in
            DispatchQueue.main.async { observer.send(value: false) }
        }
    }

    deinit {
        reachability.stopNotifier()
    }
}
