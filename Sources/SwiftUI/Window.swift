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
    
    public var size: (width: Int, height: Int) {
        return window.size
    }
    
    public var lowMemory: (() -> ()) = { }
    
    public var view: View
    
    // MARK: - Initialization
    
    public init(title: String = "",
                frame: (x: SDLWindow.Position,
                        y: SDLWindow.Position,
                        width: Int,
                        height: Int)) throws {
        
        self.window = try SDLWindow(title: title,
                                    frame: frame,
                                    options: [.allowRetina, .opengl, .resizable, .shown])
        
        self.renderer = try SDLRenderer(window: window, options: [.accelerated])
        try self.renderer.setDrawColor((0x00, 0x00, 0x00, 0xFF))
        
        self.view = View(frame:
            Frame(origin: .zero,
                  size: Size(
                    width: frame.width,
                    height: frame.height
                )
            )
        )
        
        // inform app
        Application.shared.windowCreated(self)
    }
    
    // MARK: - Methods
    
    public func run() {
        
        
    }
}
