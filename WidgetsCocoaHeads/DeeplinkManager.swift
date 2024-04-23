import Foundation

final class DeeplinkManager {
    enum DeeplinkTarget: Equatable {
        case home
        case detail(reference: String)
    }

    class DeeplinkConstants {
        static let scheme = "cch"
        static let host = "com.cocoaheads"
        static let detailPath = "/detail"
        static let query = "adId"
    }

    func manage(_ url: URL) -> DeeplinkTarget {
        guard url.scheme == DeeplinkConstants.scheme,
              url.host == DeeplinkConstants.host,
              url.path == DeeplinkConstants.detailPath,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems
        else { return .home }

        let query = queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }

        guard let id = query[DeeplinkConstants.query] else { return .home }

        return .detail(reference: id)
    }
}
