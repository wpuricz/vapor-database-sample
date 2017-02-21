import Vapor
import HTTP

final class RoleController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return try Role.all().makeNode().converted(to: JSON.self)
    }

    func create(request: Request) throws -> ResponseRepresentable {
        var role = try request.role()
        try role.save()
        return role
    }

    func show(request: Request, role: Role) throws -> ResponseRepresentable {
        return role
    }

    func delete(request: Request, role: Role) throws -> ResponseRepresentable {
        try role.delete()
        return JSON([:])
    }

    func clear(request: Request) throws -> ResponseRepresentable {
        try Role.query().delete()
        return JSON([])
    }

    func update(request: Request, role: Role) throws -> ResponseRepresentable {
        let new = try request.role()
        var role = role
        
        try role.save()
        return role
    }

    func replace(request: Request, role: Role) throws -> ResponseRepresentable {
        try role.delete()
        return try create(request: request)
    }

    func makeResource() -> Resource<Role> {
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
    func role() throws -> Role {
        guard let json = json else { throw Abort.badRequest }
        return try Role(node: json)
    }
}
