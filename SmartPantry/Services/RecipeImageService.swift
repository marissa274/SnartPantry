import Foundation

final class RecipeImageService {
    private let apiKey = "TON_PEXELS_API_KEY"

    func fetchImageURL(for recipeTitle: String) async throws -> String? {
        let query = recipeTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? recipeTitle
        let urlString = "https://api.pexels.com/v1/search?query=\(query)&per_page=1&orientation=landscape&locale=fr-FR"

        guard let url = URL(string: urlString) else { return nil }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(PexelsSearchResponse.self, from: data)

        return decoded.photos.first?.src.large
    }
}
