import Foundation

/// Model representing a digital signature
struct Signature: Codable, Identifiable {
    let id: UUID
    let name: String
    let createdDate: Date
    let data: Data
    
    init(name: String, data: Data) {
        self.id = UUID()
        self.name = name
        self.createdDate = Date()
        self.data = data
    }
}
