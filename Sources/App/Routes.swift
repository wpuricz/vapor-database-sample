import Routing
import Vapor
import HTTP

func configureRoutes<T : Routing.RouteBuilder>(router: T) where T.Value == HTTP.Responder {
    router.resource("teams", TeamController())
}
