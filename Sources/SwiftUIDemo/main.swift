import Foundation
import SwiftUI

Application.shared.didLaunch = {
    let window = try Window(title: "Demo", frame: (x: .centered, y: .centered, width: 600, height: 480))
    window.view.backgroundColor = .white
    return window
}

do { try Application.shared.run() }
catch {
    print("Error:", error)
    exit(EXIT_FAILURE)
}
