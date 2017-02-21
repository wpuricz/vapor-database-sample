import Vapor
import Fluent
import Foundation

final class User: Model {
    static let tableName = "users"
    
    var id: Node?
    var username: String
    var email: String
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        username = try node.extract("username")
        email = try node.extract("email")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "username": username,
            "email": email,
        ])
    }
}

extension User: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(User.tableName) { user in
            user.id()
            user.string("username")
            user.string("email")
        }
    }

    static func revert(_ database: Database) throws {
        try database.delete(User.tableName)
    }
}

extension User {
    
    func roles() throws -> [Role] {
        let roles : Siblings<Role> = try siblings()
        return try roles.all()
    }

}
