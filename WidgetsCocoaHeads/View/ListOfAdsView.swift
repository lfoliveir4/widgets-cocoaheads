import SwiftUI

struct ListOfAdsView: View {
    @StateObject var viewModel = AdsViewModel()
    @State var selectedAdId: String?
    let deeplinkManager = DeeplinkManager()

    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(viewModel.ads, id: \.adId) { ad in
                    NavigationLink(
                        destination: AdDetailView(
                            adId: ad.adId
                        ),
                        tag: ad.adId,
                        selection: $selectedAdId
                    ) {
                        AdView(ad: ad)
                            .onTapGesture {
                                selectedAdId = ad.adId
                            }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Anúncios")
        }
        .frame(alignment: .leading)
        .task {
            await viewModel.fetch()
        }
        .onOpenURL { url in
            let deeplinkTarget = deeplinkManager.manage(url)
            switch deeplinkTarget {
            case .home:
                break
            case .detail(let queryItem):
                selectedAdId = queryItem
            }
        }
    }
}

#Preview {
    ListOfAdsView(viewModel: .init(service: LocalService()))
}
