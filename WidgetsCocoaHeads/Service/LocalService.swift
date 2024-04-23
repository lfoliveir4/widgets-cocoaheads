import Foundation

final class LocalService {
    func load<T: Decodable>(
        _ forResource: String,
        ofType: T.Type
    ) async throws -> T {
        guard let path = Bundle.main.path(forResource: forResource, ofType: "json") else {
            fatalError("Resource file not found")
        }

        let data = try Data(contentsOf: URL(fileURLWithPath: path))

        return try JSONDecoder().decode(T.self, from: data)
    }
}
