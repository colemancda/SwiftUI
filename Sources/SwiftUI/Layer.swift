//
//  Layer.swift
//  SwiftUI
//
//  Created by Alsey Coleman Miller on 4/20/19.
//

import SDL

public final class Layer {
    
    // MARK: - Properties
    
    public var size: (width: Int, height: Int) {
        return (texture.width, texture.height)
    }
    
    public var scale: Float {
        return texture.scale
    }
    
    public var nativeSize: (width: Int, height: Int) {
        return texture.nativeSize
    }
    
    internal private(set) var texture: Texture
    
    internal let renderer: SDLRenderer
    
    // MARK: - Initialization
    
    public init(width: Int, height: Int, scale: Float = 1.0, renderer: SDLRenderer) throws {
        
        self.renderer = renderer
        self.texture = try Texture(width: width,
                                   height: height,
                                   scale: scale,
                                   renderer: renderer)
    }
    
    // MARK: - Methods
    
    public func setSize(width: Int, height: Int) throws {
        
        self.texture = try Texture(width: width,
                                   height: height,
                                   scale: scale,
                                   renderer: renderer)
    }
    
    public func setScale(_ scale: Float) throws {
        
        self.texture = try Texture(width: size.width,
                                   height: size.height,
                                   scale: scale,
                                   renderer: renderer)
    }
    
    public func withUnsafeMutableBytes <Result> (_ body: (_ pointer: UnsafeMutableRawPointer, _ pitch: Int) throws -> Result) throws -> Result? {
        
        return try texture.texture.withUnsafeMutableBytes(body)
    }
}

internal extension Layer {
    
    final class Texture {
        
        public let width: Int
        
        public let height: Int
        
        public let scale: Float
        
        public let nativeSize: (width: Int, height: Int)
        
        internal let texture: SDLTexture
        
        public init(width: Int,
                    height: Int,
                    scale: Float = 1.0,
                    renderer: SDLRenderer) throws {
            
            self.width = width
            self.height = height
            self.scale = scale
            let nativeSize = (width: Int(Float(width) * scale),
                              height: Int(Float(height) * scale))
            self.nativeSize = nativeSize
            self.texture = try SDLTexture(
                renderer: renderer,
                format: .argb8888, // SDL_PIXELFORMAT_ARGB8888
                access: .streaming,
                width: nativeSize.width,
                height: nativeSize.height
            )
            try texture.setBlendMode([.alpha])
        }
    }
}
