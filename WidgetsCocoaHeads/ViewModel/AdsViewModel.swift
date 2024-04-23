import SwiftUI

final class AdsViewModel: ObservableObject {
    private let service: LocalService
    @Published var ads: [Ad] = []

    init(service: LocalService = LocalService()) {
        self.service = service
    }

    func fetch() async {
        do {
            let model = try await service.load("ads", ofType: AdsModel.self)
            ads = model.ads
        } catch {
            debugPrint(error)
        }
    }
}
