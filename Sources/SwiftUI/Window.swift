//
//  Window.swift
//  SwiftUI
//
//  Created by Alsey Coleman Miller on 4/20/19.
//

import SDL

public final class Window {
    
    // MARK: - Properties
    
    internal let window: SDLWindow
    
    internal let renderer: SDLRenderer
    
    public var identifier: UInt {
        return window.identifier
    }
    
    public var size: Size {
        let size = window.size
        return Size(width: size.width, height: size.height)
    }
    
    /// Size of a window’s underlying drawable in pixels.
    public var nativeSize: Size {
        let size = window.drawableSize
        return Size(width: size.width, height: size.height)
    }
    
    public var scale: Float { return Float(nativeSize.width) / Float(size.width) }
    
    public var view: View
    
    internal var needsDisplay = true
    
    internal var needsLayout = true
    
    // MARK: - Initialization
    
    public init(title: String = "",
                frame: (x: SDLWindow.Position,
                        y: SDLWindow.Position,
                        width: Int,
                        height: Int)) throws {
        
        self.window = try SDLWindow(
            title: title,
            frame: frame,
            options: [.allowRetina, .opengl, .resizable, .shown]
        )
        
        self.renderer = try SDLRenderer(window: window, options: [.accelerated])
        
        self.view = View(frame:
            Frame(
                origin: .zero,
                size: Size(
                    width: frame.width,
                    height: frame.height
                )
            )
        )
        
        // inform app
        Application.shared.windowCreated(self)
    }
    
    // MARK: - Method
    
    internal func sizeChanged() {
        
        self.view.frame = Frame(origin: .zero, size: size)
        self.needsLayout = true
        self.needsDisplay = true
    }
    
    internal func view(for point: Point) -> View? {
        
        // FIXME
        return nil
    }
}

// MARK: - Responder

extension Window: Responder {
    
    func event(_ event: Event) {
        
        switch event {
        case let .window(windowEvent):
            assert(self.identifier == windowEvent.window, "Event sent to wrong window")
            switch windowEvent.type {
            case .sizeChanged:
                sizeChanged()
            default:
                break
            }
        case let .mouse(mouseEvent):
            assert(self.identifier == mouseEvent.window, "Event sent to wrong window")
            if let location = mouseEvent.location,
                let view = self.view(for: location) {
                view.event(event)
            } else {
                self.view.event(event)
            }
        default:
            break
        }
    }
}
