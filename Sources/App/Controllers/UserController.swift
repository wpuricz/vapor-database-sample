import Vapor
import HTTP
import Fluent

final class UserController: ResourceRepresentable {
    
    func addRoutes(drop: Droplet) {
        let routes = drop.grouped("users")
        routes.get(handler: index)
        routes.post(handler: create)
        routes.get(User.self, handler: show)
        routes.patch(User.self, handler: update)
        routes.delete(User.self, handler: delete)
        
        routes.post(User.self,"join",Role.self, handler: joinRole)
        routes.get(User.self,"roles", handler: rolesIndex)
        
    }
    
    func joinRole(request: Request, user: User, role: Role) throws -> ResponseRepresentable {
        var pivot = Pivot<User,Role>(user,role)
        try pivot.save()
        return user
    }
    
    func rolesIndex(request: Request, user: User) throws -> ResponseRepresentable {
        let roles = try user.roles()
        return try JSON(node: roles.makeNode())
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try User.all().makeNode().converted(to: JSON.self)
    }

    func create(request: Request) throws -> ResponseRepresentable {
        var user = try request.user()
        try user.save()
        return user
    }

    func show(request: Request, user: User) throws -> ResponseRepresentable {
        return user
    }

    func delete(request: Request, user: User) throws -> ResponseRepresentable {
        try user.delete()
        return JSON([:])
    }

    func clear(request: Request) throws -> ResponseRepresentable {
        try User.query().delete()
        return JSON([])
    }

    func update(request: Request, user: User) throws -> ResponseRepresentable {
        let new = try request.user()
        var user = user
        
        try user.save()
        return user
    }

    func replace(request: Request, user: User) throws -> ResponseRepresentable {
        try user.delete()
        return try create(request: request)
    }

    func makeResource() -> Resource<User> {
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
    func user() throws -> User {
        guard let json = json else { throw Abort.badRequest }
        return try User(node: json)
    }
}
