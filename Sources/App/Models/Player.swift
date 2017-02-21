import Vapor
import Fluent
import Foundation

final class Player: Model {
    static let tableName = "players"
    
    var id: Node?
    var team_id: Node?
    var firstname: String
    var lastname: String
    var number: Int
    var position: String
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        team_id = try node.extract("team_id")
        firstname = try node.extract("firstname")
        lastname = try node.extract("lastname")
        number = try node.extract("number")
        position = try node.extract("position")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "team_id": team_id,
            "firstname": firstname,
            "lastname": lastname,
            "number": number,
            "position": position,
        ])
    }
}

extension Player: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(Player.tableName) { player in
            player.id()
            player.parent(Team.self, optional: false, unique: false, default: nil)
            player.string("firstName")
            player.string("lastname")
            player.int("number")
            player.string("position")
        }
    }

    static func revert(_ database: Database) throws {
        try database.delete(Player.tableName)
    }
}

extension Player {
    func team() throws -> Parent<Team> {
        return try parent(team_id)
    }
}
