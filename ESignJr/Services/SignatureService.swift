import Foundation

/// Service for managing digital signatures
class SignatureService {
    static let shared = SignatureService()
    
    private let userDefaults = UserDefaults.standard
    private let signaturesKey = "stored_signatures"
    
    private init() {}
    
    /// Save a signature
    func saveSignature(_ signature: Signature) throws {
        var signatures = try getSignatures()
        signatures.append(signature)
        let encoder = JSONEncoder()
        let data = try encoder.encode(signatures)
        userDefaults.set(data, forKey: signaturesKey)
    }
    
    /// Retrieve all stored signatures
    func getSignatures() throws -> [Signature] {
        guard let data = userDefaults.data(forKey: signaturesKey) else {
            return []
        }
        let decoder = JSONDecoder()
        return try decoder.decode([Signature].self, from: data)
    }
    
    /// Delete a signature
    func deleteSignature(_ id: UUID) throws {
        var signatures = try getSignatures()
        signatures.removeAll { $0.id == id }
        let encoder = JSONEncoder()
        let data = try encoder.encode(signatures)
        userDefaults.set(data, forKey: signaturesKey)
    }
}
