import Vapor
import Fluent

func loadPreparations(drop:Droplet) {
    drop.preparations.append(Role.self)
    drop.preparations.append(User.self)
    drop.preparations.append(Player.self)
    drop.preparations.append(Team.self)
    drop.preparations.append(Pivot<User,Role>.self)
	
}
