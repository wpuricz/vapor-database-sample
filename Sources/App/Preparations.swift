import Vapor

func loadPreparations(drop:Droplet) {
    drop.preparations.append(Player.self)
    drop.preparations.append(Team.self)
	
}