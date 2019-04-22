import Foundation
import SwiftUI

do { try Application.shared.run() }
catch {
    print("Error:", error)
    exit(EXIT_FAILURE)
}
