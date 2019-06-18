//
//  Window.swift
//  SwiftUI
//
//  Created by Alsey Coleman Miller on 4/20/19.
//

import CSDL2
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
            Rect(
                origin: .zero,
                size: Size(
                    width: frame.width,
                    height: frame.height
                )
            )
        )
        self.view._window = self
        
        // inform app
        Application.shared.windowCreated(self)
    }
    
    // MARK: - Method
    
    internal func update() throws {
        
        if needsLayout {
            layoutIfNeeded()
            needsLayout = false
            needsDisplay = true
        }
        
        if needsDisplay {
            try render()
            needsDisplay = false
        }
    }
    
    internal func sizeChanged() {
        
        self.view.frame = Rect(origin: .zero, size: size)
        self.needsLayout = true
        self.needsDisplay = true
    }
    
    internal func layoutIfNeeded() {
        
        //viewController?.viewWillLayoutSubviews()
        //layoutSubviews()
        //subviews.forEach { $0.layoutIfNeeded() }
        //viewController?.viewDidLayoutSubviews()
    }
    
    internal func view(for point: Point) -> View? {
        
        // FIXME
        return nil
    }
    
    internal func render() throws {
        
        try renderer.setDrawColor(red: 0x00, green: 0x00, blue: 0x00, alpha: 0xFF)
        try renderer.clear()
        try render(view: view, origin: .zero)
        renderer.present()
    }
    
    internal func render(view: View, origin: Point) throws {
        
        guard view.shouldRender
            else { return }
        
        // add translation
        //context.translate(x: view.frame.x, y: view.frame.y)
        var relativeOrigin = origin
        relativeOrigin.x += Int(Float(view.frame.origin.x) * scale)
        relativeOrigin.y += Int(Float(view.frame.origin.y) * scale)
        
        // frame of view relative to SDL window
        let rect = SDL_Rect(x: Int32(relativeOrigin.x),
                            y: Int32(relativeOrigin.y),
                            w: Int32(Float(view.frame.size.width) * scale),
                            h: Int32(Float(view.frame.size.height) * scale))
        
        // render view
        try view.render(in: rect, for: self)
        
        // render subviews
        try view.subviews.forEach { try render(view: $0, origin: relativeOrigin) }
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
