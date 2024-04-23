import SwiftUI

final class AdDetailViewModel: ObservableObject {
    private let service: LocalService
    @Published var ad: AdDetailModel?

    init(service: LocalService = LocalService()) {
        self.service = service
    }

    func fetch(adId: String) async {
        do {
            let model = try await service.load("ad-\(adId)", ofType: AdDetailModel.self)
            ad = model
        } catch {
            debugPrint(error)
        }
    }
}
