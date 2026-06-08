import Foundation
struct PowerModel: Codable {
    let domain: String
    let status: String
    let pc_online: Bool
    let power_state: String
    let smart_plug_connected: Bool
    let automation_enabled: Bool
    let confidence: Double
}
