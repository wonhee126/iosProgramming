import Foundation

class BikeStationLoader {
    static func loadMultipleBikeStations(completion: @escaping ([Location]?) -> Void) {
        let urlString = "http://openapi.seoul.go.kr:8088/56644e54646a776839374c75797672/json/bikeList/1/1000"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print("Request error: \(error!)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let bikeData = try decoder.decode(RentBikeStatus.self, from: data)
                completion(bikeData.rentBikeStatus.row)
            } catch {
                print("Failed to decode bike data: \(error)")
                completion(nil)
            }
        }

        task.resume()
    }
}

struct RentBikeStatus: Codable {
    let rentBikeStatus: BikeListData
}

struct BikeListData: Codable {
    let list_total_count: Int
    let RESULT: Result
    let row: [Location]
}

struct Result: Codable {
    let CODE: String
    let MESSAGE: String
}


