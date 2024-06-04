import Foundation

struct Location: Codable {
    let rackTotCnt: String
    let stationName: String
    let parkingBikeTotCnt: String
    let shared: String
    let stationLatitude: Double
    let stationLongitude: Double
    let stationId: String

    enum CodingKeys: String, CodingKey {
        case rackTotCnt
        case stationName
        case parkingBikeTotCnt
        case shared
        case stationLatitude
        case stationLongitude
        case stationId
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rackTotCnt = try container.decode(String.self, forKey: .rackTotCnt)
        stationName = try container.decode(String.self, forKey: .stationName)
        parkingBikeTotCnt = try container.decode(String.self, forKey: .parkingBikeTotCnt)
        shared = try container.decode(String.self, forKey: .shared)

        // 문자열을 Double로 변환
        let stationLatitudeString = try container.decode(String.self, forKey: .stationLatitude)
        let stationLongitudeString = try container.decode(String.self, forKey: .stationLongitude)
        stationLatitude = Double(stationLatitudeString) ?? 0.0
        stationLongitude = Double(stationLongitudeString) ?? 0.0
        
        stationId = try container.decode(String.self, forKey: .stationId)
    }
}
