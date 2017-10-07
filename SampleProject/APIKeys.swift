import Foundation

private let minimumKeyLength = 2

// Mark: - API Keys

struct APIKeys {
    let defaultHTTPHeaders: [String: String] = [:]
    
    fileprivate struct SharedKeys {
        static var instance = APIKeys()
    }
    
    static var sharedKeys: APIKeys {
        get {
            return SharedKeys.instance
        }
        
        set (newSharedKeys) {
            SharedKeys.instance = newSharedKeys
        }
    }
    
    // MARK: Initializers
    init() {

    }
}
