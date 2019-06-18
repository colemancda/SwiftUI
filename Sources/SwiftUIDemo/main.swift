import Foundation
import SwiftUI

Application.shared.didLaunch = {
    
    let window = try Window(title: "Demo", frame: (x: .centered, y: .centered, width: 600, height: 480))
    window.view.backgroundColor = .white
    let subview = View(frame: Rect(origin: Point(x: 20, y: 20),
                                    size: Size(width: 100, height: 100)))
    subview.backgroundColor = .red
    window.view.addSubview(subview)
    let subview2 = Button(frame: Rect(origin: Point(x: 10, y: 10),
                                      size: Size(width: 80, height: 80)))
    subview2.backgroundColor = .white
    subview2.alpha = 0.60
    subview.addSubview(subview2)
    
    class Button: View, Responder {
        
        func event(_ event: Event) {
            
            switch event {
            case let .mouse(.button(buttonEvent)):
                switch buttonEvent.action {
                case .down:
                    self.backgroundColor = .green
                case .up:
                    self.backgroundColor = .blue
                }
            default:
                return
            }
        }
    }
    
    return window
}

do { try Application.shared.run() }
catch {
    print("Error:", error)
    exit(EXIT_FAILURE)
}
