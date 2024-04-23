import SwiftUI

struct AdView: View {
    let ad: Ad

    init(ad: Ad) {
        self.ad = ad
    }

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: ad.imageURL)!) { image in
                image.image?.resizable()
            }
            .frame(width: 150, height: 120)

            VStack(alignment: .leading, spacing: 5) {
                Text(ad.title)

                Text("R$ \(ad.price)")
            }
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            RoundedRectangle(
                cornerRadius: 8,
                style: .continuous
            ).stroke(Color.gray, lineWidth: 0.5)
        )
        .padding()
    }
}

#Preview {
    AdView(ad: .init(
        adId: "1",
        title: "Carrinho ",
        imageURL: "https://fotos-jornaldocarro-estadao.nyc3.cdn.digitaloceanspaces.com/wp-content/uploads/2022/10/31123549/BMW-Serie-3-2023-1.jpeg",
        description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
        price: 14000
    )
    )
}
