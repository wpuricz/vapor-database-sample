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


//let teamController: TeamController = TeamController()
//teamController.addRoutes(drop: drop)

let playerController: PlayerController = PlayerController()
playerController.addRoutes(drop: drop)

let userController: UserController = UserController()
userController.addRoutes(drop: drop)

// Testing getting children, players from teams
// TODO: Fix issue
drop.get("children") { request in
    let team = try Team.find(1)!
    let players = try team.children(nil, Player.self).all()
    return try JSON(node:players)
}


configureRoutes(router: drop)
loadPreparations(drop: drop)
drop.run()
