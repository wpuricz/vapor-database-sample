import Vapor
import HTTP

final class PlayerController: ResourceRepresentable {
    
    func addRoutes(drop:Droplet) {
        drop.get("players",Player.self,"team",handler: teamShow)
    }
    
    func teamShow(request: Request, player: Player) throws -> ResponseRepresentable {
        let parent = try player.team().get()
        return try JSON(node: parent?.makeNode())
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try Player.all().makeNode().converted(to: JSON.self)
    }

    func create(request: Request) throws -> ResponseRepresentable {
        var player = try request.player()
        try player.save()
        return player
    }

    func show(request: Request, player: Player) throws -> ResponseRepresentable {
        return player
    }

    func delete(request: Request, player: Player) throws -> ResponseRepresentable {
        try player.delete()
        return JSON([:])
    }

    func clear(request: Request) throws -> ResponseRepresentable {
        try Player.query().delete()
        return JSON([])
    }

    func update(request: Request, player: Player) throws -> ResponseRepresentable {
        let new = try request.player()
        var player = player
        
        try player.save()
        return player
    }

    func replace(request: Request, player: Player) throws -> ResponseRepresentable {
        try player.delete()
        return try create(request: request)
    }

    func makeResource() -> Resource<Player> {
        return Resource(
            index: index,
            store: create,
            show: show,
            replace: replace,
            modify: update,
            destroy: delete,
            clear: clear
        )
    }
}

extension Request {
    func player() throws -> Player {
        guard let json = json else { throw Abort.badRequest }
        return try Player(node: json)
    }
}
