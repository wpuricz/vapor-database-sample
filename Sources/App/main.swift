import Vapor
import VaporPostgreSQL

let drop = Droplet(
    providers: [VaporPostgreSQL.Provider.self]
)
drop.preparations.append(Post.self)

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

// Route with raw DB connection
drop.get("version") { request in
	if let db = drop.database?.driver as? PostgreSQLDriver {
			let version = try db.raw("SELECT version()")
			return try JSON(node: version)
		}else{
			return "no db connection"
		}

}

drop.resource("posts", PostController())

// manually adding routes
let playerController: PlayerController = PlayerController()
playerController.addRoutes(drop: drop)

let teamController: TeamController = TeamController()
teamController.addRoutes(drop: drop)

let userController: UserController = UserController()
userController.addRoutes(drop: drop)

let roleController: RoleController = RoleController()
roleController.addRoutes(drop: drop)



configureRoutes(router: drop)
loadPreparations(drop: drop)
drop.run()
