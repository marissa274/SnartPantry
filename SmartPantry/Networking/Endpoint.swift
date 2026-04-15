import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let requiresAuth: Bool
}

extension Endpoint {
    static let register = Endpoint(path: "/smartpantry/register", method: .post, requiresAuth: false)
    static let login = Endpoint(path: "/smartpantry/login", method: .post, requiresAuth: false)
    static let me = Endpoint(path: "/smartpantry/login", method: .get, requiresAuth: true)
    static let ai = Endpoint(path: "/smartpantry/ai", method: .post, requiresAuth: true)
    static let recipes = Endpoint(path: "/smartpantry/recipes", method: .get, requiresAuth: true)
    static let addRecipe = Endpoint(path: "/smartpantry/recipes", method: .post, requiresAuth: true)

    static func recipe(id: String) -> Endpoint {
        Endpoint(path: "/smartpantry/recipes/\(id)", method: .get, requiresAuth: true)
    }

    static func deleteRecipe(id: String) -> Endpoint {
        Endpoint(path: "/smartpantry/recipes/\(id)", method: .delete, requiresAuth: true)
    }
}
