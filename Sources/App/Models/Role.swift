import Vapor
import Fluent
import Foundation

final class Role: Model {
    static let tableName = "roles"
    
    var id: Node?
    var name: String
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name,
        ])
    }
}

extension Role: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(Role.tableName) { role in
            role.id()
            role.string("name")
        }
    }

    static func revert(_ database: Database) throws {
        try database.delete(Role.tableName)
    }
}

extension Role {
    
    func users() throws -> [User] {
        let users : Siblings<User> = try siblings()
        return try users.all()
    }
    
}
