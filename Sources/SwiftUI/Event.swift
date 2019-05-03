//
//  Event.swift
//  SwiftUI
//
//  Created by Alsey Coleman Miller on 4/21/19.
//

import Foundation
import CSDL2
import SDL

public enum Event {
    
    case mouse(Mouse)
    case touch
    case keyboard
    //case window(WindowEvent)
}

public extension Event {
    
    enum Mouse {
        
        case button(Button)
        case motion(Motion)
        case wheel(Wheel)
    }
}

public extension Event.Mouse {
    
    struct Button {
        
        public let type: ButtonType
        
        public let action: ButtonAction
        
        public let location: Point
    }
    
    enum ButtonType {
        
        case left
        case middle
        case right
        case x1
        case x2
    }
    
    enum ButtonAction {
        
        case up
        case down
    }
}

public extension Event.Mouse {
    
    struct Motion {
        
        public let location: Point
        
        public let delta: Size
    }
}

public extension Event.Mouse {
    
    struct Wheel {
        
        public let delta: Size
        
        public let direction: Direction
    }
}

public extension Event.Mouse.Wheel {
    
    enum Direction {
        
        case normal
        case flipped
    }
}
