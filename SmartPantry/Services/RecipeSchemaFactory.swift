import Foundation

enum RecipeSchemaFactory {
    static let recipeSchema: [String: JSONValue] = [
        "type": .string("object"),
        "additionalProperties": .bool(false),
        "properties": .object([
            "title": .object([
                "type": .string("string")
            ]),
            "summary": .object([
                "type": .string("string")
            ]),
            "ingredients": .object([
                "type": .string("array"),
                "items": .object([
                    "type": .string("string")
                ])
            ]),
            "steps": .object([
                "type": .string("array"),
                "items": .object([
                    "type": .string("string")
                ])
            ]),
            "cook_time": .object([
                "type": .string("string")
            ]),
            "servings": .object([
                "type": .string("integer")
            ])
        ]),
        "required": .array([
            .string("title"),
            .string("summary"),
            .string("ingredients"),
            .string("steps"),
            .string("cook_time"),
            .string("servings")
        ])
    ]
}
