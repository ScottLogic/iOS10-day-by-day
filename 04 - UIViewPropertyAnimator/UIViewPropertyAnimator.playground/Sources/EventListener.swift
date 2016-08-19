import Foundation

public class EventListener: NSObject {
    public var eventFired: (() -> ())?
    
    public func handleEvent() {
        eventFired?()
    }
}
