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
        try self.renderer.setDrawColor(red: 0x00, green: 0x00, blue: 0x00, alpha: 0xFF)
        
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
}
