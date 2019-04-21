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
    
    // MARK: - Initialization
    
    public init(title: String = "",
                frame: (x: SDLWindow.Position,
                        y: SDLWindow.Position,
                        width: Int,
                        height: Int)) throws {
        
        self.window = try SDLWindow(title: title,
                                    frame: frame,
                                    options: [.allowRetina, .opengl, .resizable])
        
        self.renderer = try SDLRenderer(window: window, options: [.accelerated])
        try self.renderer.setDrawColor((0x00, 0x00, 0x00, 0xFF))
        
        // inform app
        Application.shared.windowCreated(self)
    }
    
    // MARK: - Methods
    
    public func run() {
        
        
    }
}
