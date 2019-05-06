//
//  Event.swift
//  SwiftUI
//
//  Created by Alsey Coleman Miller on 4/21/19.
//

import Foundation
import CSDL2
import SDL

public protocol EventProtocol {
    
    var timestamp: UInt { get }
}

public enum Event {
    
    case window(Window)
    case mouse(Mouse)
    //case touch
    //case keyboard
}

public extension Event {
    
    init?(rawValue: EventProtocol) {
        
        if let event = rawValue as? Event.Window {
            self = .window(event)
        } else if let event = rawValue as? Event.Mouse.Button {
            self = .mouse(.button(event))
        } else if let event = rawValue as? Event.Mouse.Motion {
            self = .mouse(.motion(event))
        } else if let event = rawValue as? Event.Mouse.Wheel {
            self = .mouse(.wheel(event))
        } else {
            return nil
        }
    }
    
    var rawValue: EventProtocol {
        
        switch self {
        case let .window(event):
            return event
        case let .mouse(.button(event)):
            return event
        case let .mouse(.motion(event)):
            return event
        case let .mouse(.wheel(event)):
            return event
        }
    }
}

public extension Event {
    
    enum Mouse {
        
        case button(Button)
        case motion(Motion)
        case wheel(Wheel)
    }
}

public extension Event.Mouse {
    
    struct Button: EventProtocol {
        
        public let timestamp: UInt
        
        public let location: Point
        
        public let button: ButtonType
        
        public let action: ButtonAction
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
    
    struct Motion: EventProtocol {
        
        public let timestamp: UInt
        
        public let location: Point
        
        public let delta: Size
    }
}

public extension Event.Mouse {
    
    struct Wheel: EventProtocol {
        
        public let timestamp: UInt
        
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

public extension Event {
    
    struct Window: EventProtocol {
        
        public let timestamp: UInt
        
        public let window: UInt
        
        public let type: EventType
    }
}

public extension Event.Window {
    
    enum EventType {
        
        /// window has been shown
        case shown
        
        /// window has been hidden
        case hidden
        
        /// window has been exposed and should be redrawn
        case exposed
        
        /// window has been moved
        case moved
        
        /// window size has changed, either as a result of an API call or through the system or user changing the window size
        case sizeChanged
        
        /// window has been minimized
        case minimized
        
        /// window has been maximized
        case maximized
        
        /// window has been restored to normal size and position
        case restored
        
        /// window has gained mouse focus
        case enter
        
        /// window has lost mouse focus
        case leave
        
        /// window has gained keyboard focus
        case focusGained
        
        /// window has lost keyboard focus
        case focusLost
        
        /// the window manager requests that the window be closed
        case close
        
        /// window is being offered a focus
        case takeFocus
        
        /// window had a hit test
        case hitTest
    }
}

// MARK: - SDL

internal extension Event {
    
    init?(_ sdlEvent: SDL_Event) {
        
        let eventType = SDL_EventType(rawValue: sdlEvent.type)
        
        switch eventType {
        case SDL_WINDOWEVENT:
            guard let event = Event.Window(sdlEvent.window)
                else { return nil }
            self = .window(event)
        case SDL_MOUSEBUTTONUP,
             SDL_MOUSEBUTTONDOWN:
            guard let event = Event.Mouse.Button(sdlEvent.button)
                else { return nil }
            self = .mouse(.button(event))
        case SDL_MOUSEWHEEL:
            guard let event = Event.Mouse.Wheel(sdlEvent.wheel)
                else { return nil }
            self = .mouse(.wheel(event))
        case SDL_MOUSEMOTION:
            guard let event = Event.Mouse.Motion(sdlEvent.motion)
                else { return nil }
            self = .mouse(.motion(event))
        default:
            return nil
        }
    }
}

internal extension Event.Window {
    
    init?(_ sdlEvent: SDL_WindowEvent) {
        
        self.timestamp = UInt(sdlEvent.timestamp)
        self.window = UInt(sdlEvent.windowID)
        let windowEvent = SDL_WindowEventID(rawValue: UInt32(sdlEvent.event))
        
        switch windowEvent {
        case SDL_WINDOWEVENT_SHOWN:
            self.type = .shown
        case SDL_WINDOWEVENT_HIDDEN:
            self.type = .hidden
        case SDL_WINDOWEVENT_EXPOSED:
            self.type = .exposed
        case SDL_WINDOWEVENT_MOVED:
            self.type = .moved
        case SDL_WINDOWEVENT_RESIZED:
            return nil
        case SDL_WINDOWEVENT_SIZE_CHANGED:
            self.type = .sizeChanged
        case SDL_WINDOWEVENT_MINIMIZED:
            self.type = .minimized
        case SDL_WINDOWEVENT_MAXIMIZED:
            self.type = .maximized
        case SDL_WINDOWEVENT_RESTORED:
            self.type = .restored
        case SDL_WINDOWEVENT_ENTER:
            self.type = .enter
        case SDL_WINDOWEVENT_LEAVE:
            self.type = .leave
        case SDL_WINDOWEVENT_FOCUS_GAINED:
            self.type = .focusGained
        case SDL_WINDOWEVENT_FOCUS_LOST:
            self.type = .focusLost
        case SDL_WINDOWEVENT_CLOSE:
            self.type = .close
        case SDL_WINDOWEVENT_HIT_TEST:
            self.type = .hitTest
        default:
            return nil
        }
    }
}

internal extension Event.Mouse.Button {
    
    init?(_ sdlEvent: SDL_MouseButtonEvent) {
        
        self.timestamp = UInt(sdlEvent.timestamp)
        self.location = Point(x: Int(sdlEvent.x), y: Int(sdlEvent.y))
        
        let eventType = SDL_EventType(rawValue: sdlEvent.type)
        
        switch eventType {
        case SDL_MOUSEBUTTONDOWN:
            self.action = .down
        case SDL_MOUSEBUTTONUP:
            self.action = .up
        default:
            return nil
        }
        
        switch Int32(sdlEvent.button) {
        case SDL_BUTTON_LEFT:
            self.button = .left
        case SDL_BUTTON_MIDDLE:
            self.button = .left
        case SDL_BUTTON_RIGHT:
            self.button = .right
        case SDL_BUTTON_X1:
            self.button = .x1
        case SDL_BUTTON_X2:
            self.button = .x2
        default:
            return nil
        }
    }
}

internal extension Event.Mouse.Wheel {
    
    init?(_ sdlEvent: SDL_MouseWheelEvent) {
        
        self.timestamp = UInt(sdlEvent.timestamp)
        self.delta = Size(width: Int(sdlEvent.x), height: Int(sdlEvent.y))
        
        switch SDL_MouseWheelDirection(rawValue: sdlEvent.direction) {
        case SDL_MOUSEWHEEL_NORMAL:
            self.direction = .normal
        case SDL_MOUSEWHEEL_FLIPPED:
            self.direction = .flipped
        default:
            return nil
        }
    }
}

internal extension Event.Mouse.Motion {
    
    init?(_ sdlEvent: SDL_MouseMotionEvent) {
        
        self.timestamp = UInt(sdlEvent.timestamp)
        self.location = Point(x: Int(sdlEvent.x), y: Int(sdlEvent.y))
        self.delta = Size(width: Int(sdlEvent.xrel), height: Int(sdlEvent.yrel))
    }
}
