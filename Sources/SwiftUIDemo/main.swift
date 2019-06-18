import Foundation
import SwiftUI

Application.shared.didLaunch = {
    
    let window = try Window(title: "Demo", frame: (x: .centered, y: .centered, width: 600, height: 480))
    window.view.backgroundColor = .white
    let subview = View(frame: Frame(origin: Point(x: 20, y: 20),
                                    size: Size(width: 100, height: 100)))
    subview.backgroundColor = .red
    window.view.addSubview(subview)
    let subview2 = View(frame: Frame(origin: Point(x: 10, y: 10),
                                     size: Size(width: 80, height: 80)))
    subview2.backgroundColor = .blue
    subview2.alpha = 0.60
    subview.addSubview(subview2)
    
    if #available(OSX 10.12, *) {
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            subview2.backgroundColor = subview2.backgroundColor == .blue ? .green : .blue
        }
    }
    
    return window
}

do { try Application.shared.run() }
catch {
    print("Error:", error)
    exit(EXIT_FAILURE)
}
