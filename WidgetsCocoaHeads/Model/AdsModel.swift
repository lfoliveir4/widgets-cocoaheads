struct AdsModel: Decodable {
    let ads: [Ad]
}

struct Ad: Decodable {
    let adId: String
    let title: String
    let imageURL: String
    let description: String
    let price: Int
}
