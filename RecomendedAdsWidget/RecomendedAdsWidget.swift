import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> AdsEntry {
        .init(date: Date(), ads: [])
    }

    func snapshot(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> AdsEntry {
        .init(date: Date(), ads: [])
    }
    
    func timeline(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> Timeline<AdsEntry> {
        let currentDate = Date()

        do {
            let ads = try await fetch()
            let entry: AdsEntry = .init(date: currentDate, ads: ads)
            return Timeline(entries: [entry], policy: .atEnd)
        } catch {
            let entry: AdsEntry = .init(date: currentDate, ads: [])
            return Timeline(entries: [entry], policy: .never)
        }
    }

    func fetch() async throws -> [Ad] {
        guard let url = Bundle.main.url(forResource: "recommended-ads", withExtension: "json") else {
            throw NSError(
                domain: "IntentAppError",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "JSON not found"]
            )
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([Ad].self, from: data)
    }
}

struct AdsEntry: TimelineEntry {
    let date: Date
    let ads: [Ad]
}

struct Ad: Decodable {
    let id: String
    let imageURL: String
    let title: String
}

struct RecomendedAdsWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Recomendados para você")

            HStack {
                ForEach(entry.ads, id: \.id) { ad in
                    Link(
                        destination: URL(string: "cch://com.cocoaheads/detail?adId=\(ad.id)")!
                    ) {
                        VStack {
                            if let url = URL(string: ad.imageURL),
                               let imageData = try? Data(contentsOf: url),
                               let uiImage = UIImage(data: imageData) {

                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                            }

                            Text(ad.title)
                        }
                    }
                }
            }
        }
    }
}

struct RecomendedAdsWidget: Widget {
    let kind: String = "RecomendedAdsWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
            provider: Provider()
        ) { entry in
            RecomendedAdsWidgetEntryView(entry: entry)
                .containerBackground(.fill.secondary, for: .widget)
        }
    }
}

#Preview(as: .systemMedium) {
    RecomendedAdsWidget()
} timeline: {
    AdsEntry(
        date: .now,
        ads: [
            .init(
                id: "0",
                imageURL: "https://m.media-amazon.com/images/I/41fMEuRY6oL._AC_UF1000,1000_QL80_.jpg",
                  title: "iPhone 15 Pro Max"),
            .init(
                id: "1",
                  imageURL: "https://m.media-amazon.com/images/I/41fMEuRY6oL._AC_UF1000,1000_QL80_.jpg",
                  title: "iPhone 15 Pro Max")
        ]
    )
}
