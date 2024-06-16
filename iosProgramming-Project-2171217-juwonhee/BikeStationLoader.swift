import Foundation

// 요청한 데이터는 JSON 형식으로 받아와서
// JSONDecoder를 사용하여 RentBikeStatus 구조체로 디코딩
// 디코딩된 데이터 중에서 자전거 대여소 정보(row)를 completion 핸들러를 통해 반환

class BikeStationLoader {
    static func loadMultipleBikeStations(completion: @escaping ([Location]?) -> Void) {
        let urlString = "http://openapi.seoul.go.kr:8088/56644e54646a776839374c75797672/json/bikeList/1/1000"
        
        guard let url = URL(string: urlString) else { // URL 객체 생성
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

// RentBikeStatus 구조체: API 응답의 최종 객체
// rentBikeStatus 프로퍼티는 BikeListData 구조체로 구성

struct RentBikeStatus: Codable {
    let rentBikeStatus: BikeListData
}

// 자전거 대여소 데이터를 담는 구조체
struct BikeListData: Codable {
    let list_total_count: Int
    let RESULT: Result
    let row: [Location] // 자전거 대여소 정보를 담고 있는 배열
}

// API 요청 결과의 코드와 메시지
struct Result: Codable {
    let CODE: String
    let MESSAGE: String
}


