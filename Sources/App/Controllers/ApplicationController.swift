import Vapor
import HTTP

extension Vapor.KeyAccessible where Key == HeaderKey, Value == String {
    
    var contentType: String? {
        get {
            return self["Content-Type"]
        }
        set {
            self["Content-Type"] = newValue
        }
    }
    
    var authorization: String? {
        get {
            return self["Authorization"]
        }
        set {
            self["Authorization"] = newValue
        }
    }
    
}

public enum ContentType: String {
    case html = "text/html"
    case json = "application/json"
}

open class ApplicationController {
    
    private var resourcefulName: String {
        let className = String(describing: type(of: self))
        return className.replacingOccurrences(of: "Controller", with: "").lowercased()
    }
    
    public func respond(to request: Request, with response: [ContentType : ResponseRepresentable]) -> ResponseRepresentable {
        let contentTypeValue = request.headers.contentType ?? ContentType.html.rawValue
        let contentType = ContentType(rawValue: contentTypeValue) ?? ContentType.html
        return response[contentType] ?? Response(status: .notFound)
    }
    
    public func render(_ path: String, _ context: NodeRepresentable? = nil) throws -> View {
        return try drop.view.make("\(resourcefulName)/\(path)", context ?? Node.null)
    }
    
    public func render(_ path: String, _ context: [String : NodeRepresentable]?) throws -> View {
        return try render(path, context?.makeNode())
    }
    
}

extension Resource {
    public convenience init(
        index: Multiple? = nil,
        show: Item? = nil,
        create: Multiple? = nil,
        replace: Item? = nil,
        update: Item? = nil,
        destroy: Item? = nil,
        clear: Multiple? = nil,
        aboutItem: Item? = nil,
        aboutMultiple: Multiple? = nil) {
        self.init(
            index: index,
            store: create,
            show: show,
            replace: replace,
            modify: update,
            destroy: destroy,
            clear: clear,
            aboutItem: aboutItem,
            aboutMultiple: aboutMultiple
        )
    }
}
