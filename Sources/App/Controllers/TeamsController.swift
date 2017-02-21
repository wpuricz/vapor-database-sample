import Vapor
import HTTP

final class TeamController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return try Team.all().makeNode().converted(to: JSON.self)
    }

    func create(request: Request) throws -> ResponseRepresentable {
        var team = try request.team()
        try team.save()
        return team
    }

    func show(request: Request, team: Team) throws -> ResponseRepresentable {
        return team
    }

    func delete(request: Request, team: Team) throws -> ResponseRepresentable {
        try team.delete()
        return JSON([:])
    }

    func clear(request: Request) throws -> ResponseRepresentable {
        try Team.query().delete()
        return JSON([])
    }

    func update(request: Request, team: Team) throws -> ResponseRepresentable {
        let new = try request.team()
        var team = team
        
        try team.save()
        return team
    }

    func replace(request: Request, team: Team) throws -> ResponseRepresentable {
        try team.delete()
        return try create(request: request)
    }

    func makeResource() -> Resource<Team> {
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
    func team() throws -> Team {
        guard let json = json else { throw Abort.badRequest }
        return try Team(node: json)
    }
}
