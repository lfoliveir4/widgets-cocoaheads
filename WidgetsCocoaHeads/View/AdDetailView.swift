import SwiftUI

public struct AdDetailView: View {
    @ObservedObject var viewModel: AdDetailViewModel
    let adId: String

    init(adId: String) {
        self.adId = adId
        self.viewModel = AdDetailViewModel()
    }

    public var body: some View {
        ScrollView {
            if let ad = viewModel.ad {
                AsyncImage(
                    url: URL(string: ad.imageURL)
                ) { image in
                    image.image?.resizable()
                }
                .scaledToFit()

                VStack {
                    Text(ad.title)
                        .font(.title)
                        .padding(.bottom, 20)

                    Text(ad.description)
                        .font(.headline)
                        .padding(.bottom, 20)
                        .multilineTextAlignment(.center)

                    Text("R$ \(ad.price)")
                        .font(.title)
                        .bold()
                        .padding(.bottom, 20)

                    Button {
                        print("Clicked")
                    } label: {
                        Text("Comprar")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .foregroundStyle(.white)
                }
                .padding()
            } else {
                ProgressView()
            }

            Spacer()
        }
        .task {
            await viewModel.fetch(adId: adId)
        }
    }
}



//#Preview {
//    AdDetailView(
//        adId: "2",
//        ad: .init(
//        adId: "2",
//        title: "Meu anúncio",
//        imageURL: "https://cdn.planoeplano.com.br/2022/08/04/18/03/3959a8a4f8ea052b7d21d377fe2d01bffb66878b-thumbnail.jpg",
//        description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
//        price: 32000
//    ))
//}
