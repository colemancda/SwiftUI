//
//  Layer.swift
//  SwiftUI
//
//  Created by Alsey Coleman Miller on 4/20/19.
//

import SDL

public final class Layer {
    
    // MARK: - Properties
    
    public let width: Int
    
    public let height: Int
    
    public let scale: Float
    
    internal let texture: SDLTexture
    
    internal weak var renderer: SDLRenderer?
    
    // MARK: - Initialization
    
    public init(width: Int, height: Int, scale: Float = 1.0, renderer: SDLRenderer) throws {
        
        self.width = width
        self.height = height
        self.scale = scale
        self.texture = try SDLTexture(
            renderer: renderer,
            format: .argb8888, // SDL_PIXELFORMAT_ARGB8888
            access: .streaming,
            width: Int(Float(width) * scale),
            height: Int(Float(height) * scale)
        )
        self.renderer = renderer
        
        try texture.setBlendMode([.alpha])
    }
    
    
}
