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
    
    case touch(Touch)
    //case mouse(ScreenInputEvent, CGPoint)
    //case mouseWheel(CGSize)
    //case window(WindowEvent)
}
/*
internal extension Event {
    
    init?(_ sdlEvent: inout SDL_Event) {
        
        let eventType = SDL_EventType(rawValue: sdlEvent.type)
        switch eventType {
        case SDL_QUIT,
             SDL_APP_TERMINATING:
            self = .quit
        case SDL_APP_LOWMEMORY:
            self = .lowMemory
        case SDL_FINGERDOWN,
             SDL_FINGERUP,
             SDL_FINGERMOTION:
            self = .touch(Touch(&sdlEvent.tfinger))
        case SDL_MOUSEBUTTONDOWN,
             SDL_MOUSEBUTTONUP,
             SDL_MOUSEMOTION:
            
            // dont translate touch screen events.
            guard sdlEvent.button.which != Uint32(bitPattern: -1)
                else { return nil }
            
            let screenEvent: ScreenInputEvent
            
            switch eventType {
            case SDL_MOUSEBUTTONDOWN: screenEvent = .down
            case SDL_MOUSEBUTTONUP: screenEvent = .up
            case SDL_MOUSEMOTION: screenEvent = .motion
            default: return nil
            }
            
            let screenLocation = CGPoint(x: CGFloat(sdlEvent.button.x),
                                         y: CGFloat(sdlEvent.button.y))
            
            self.data = .mouse(screenEvent, screenLocation)
            
        case SDL_MOUSEWHEEL:
            
            sdlEvent.wheel.
            
            let translation = CGSize(width: CGFloat(sdlEvent.wheel.x),
                                     height: CGFloat(sdlEvent.wheel.y))
            
            self.data = .mouseWheel(translation)
            
        case SDL_WINDOWEVENT:
            
            let sdlWindowEvent = SDL_WindowEventID(rawValue: SDL_WindowEventID.RawValue(sdlEvent.window.event))
            
            let windowEvent: WindowEvent
            let window = UInt(sdlEvent.window.windowID)
            
            switch sdlWindowEvent {
            case SDL_WINDOWEVENT_SIZE_CHANGED: windowEvent = .sizeChange(window: window)
            case SDL_WINDOWEVENT_FOCUS_GAINED,
                 SDL_WINDOWEVENT_FOCUS_LOST: windowEvent = .focusChange(window: window)
            default: return nil
            }
            
            self.data = .window(windowEvent)
            
        default:
            return nil
        }
    }
}
*/
public struct Touch {
    
    public let timestamp: UInt
    public let movement: Movement
    public let device: Int
    
    /**< Normalized in the range 0...1 */
    public var x: Float
    
    /**< Normalized in the range 0...1 */
    public var y: Float
    
    /**< Normalized in the range -1...1 */
    public var dx: Float
    
    /**< Normalized in the range -1...1 */
    public var dy: Float
    
    /**< Normalized in the range 0...1 */
    public var pressure: Float
}

internal extension Touch {
    
    init(_ sdlEvent: inout SDL_TouchFingerEvent) {
        
        self.timestamp = UInt(sdlEvent.timestamp)
        
        let eventType = SDL_EventType(rawValue: sdlEvent.type)
        switch eventType {
        case SDL_FINGERDOWN:
            movement = .down
        case SDL_FINGERUP:
            movement = .up
        case SDL_FINGERMOTION:
            movement = .motion
        default:
            fatalError()
        }
        
        self.device = Int(sdlEvent.touchId)
        self.pressure = sdlEvent.pressure
        self.x = sdlEvent.x
        self.y = sdlEvent.y
        self.dx = sdlEvent.dx
        self.dy = sdlEvent.dy
    }
}

public extension Touch {
    
    enum Movement {
        case up
        case down
        case motion
    }
}

public enum MouseEvent {
    
    case button(MouseButtonEvent)
    
}

public struct MouseButtonEvent {
    
    public let timestamp: UInt
    public let movement: Movement
    public let device: UInt
    public let window: UInt
    public let button: UInt8
}

internal extension MouseButtonEvent {
    
    init(_ sdlEvent: inout SDL_MouseButtonEvent) {
        
        self.timestamp = UInt(sdlEvent.timestamp)
        
        let eventType = SDL_EventType(rawValue: sdlEvent.type)
        switch eventType {
        case SDL_MOUSEBUTTONUP:
            movement = .down
        case SDL_MOUSEBUTTONDOWN:
            movement = .up
        default:
            fatalError()
        }
        
        self.device = UInt(sdlEvent.which)
        self.window = UInt(sdlEvent.windowID)
        self.button = sdlEvent.button
    }
}

public extension MouseButtonEvent {
    
    enum Movement {
        case up
        case down
    }
}

internal final class EventEnvironment {
    
    init() { }
    
    var application: Application { return .shared }
    
    private(set) var eventQueue = [Event]()
    
    func recieveEvent(_ sdlEvent: inout SDL_Event) {
        //guard let event = Event(&sdlEvent) else { return }
        //eventQueue.append(event)
    }
    
    func dispatchEvents() {
        
        for event in eventQueue {
            handleEvent(event)
        }
        
        eventQueue.removeAll()
    }
    
    func handleEvent(_ event: Event) {
        
        
    }
}
