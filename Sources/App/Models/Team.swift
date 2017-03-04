import Vapor
import Fluent
import Foundation

final class Team: Model {
    static let tableName = "teams"
    
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

extension Team: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(Team.tableName) { team in
            team.id()
            team.string("name")
        }
    }

    static func revert(_ database: Database) throws {
        try database.delete(Team.tableName)
    }
}

extension Team {
    func players() throws -> Children<Player> {
        return try children()
    }
//    func players() throws -> [Player] {
//        return try children(nil, Player.self).all()
//    }
}
