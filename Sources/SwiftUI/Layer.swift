//
//  Layer.swift
//  SwiftUI
//
//  Created by Alsey Coleman Miller on 4/20/19.
//

import SDL

public final class Texture {
    
    internal static var format: SDLPixelFormat.Format { return .argb8888 }  // SDL_PIXELFORMAT_ARGB8888
    
    public var width: Int {
        return attributes.width
    }
    
    public var height: Int {
        return attributes.height
    }
    
    internal let texture: SDLTexture
    
    internal let attributes: SDLTexture.Attributes
    
    internal init(width: Int,
                  height: Int,
                  renderer: SDLRenderer) throws {
        
        self.texture = try SDLTexture(
            renderer: renderer,
            format: Texture.format,
            access: .streaming,
            width: width,
            height: height
        )
        
        try self.texture.setBlendMode([.alpha])
        self.attributes = try texture.attributes()
    }
    
    internal init(color: Color,
                  renderer: SDLRenderer) throws {
        
        let width = 1
        let height = 1
        let surface = try SDLSurface(
            rgb: (0,0,0,0),
            size: (width: width, height: height),
            depth: 32
        )
        try surface.fill(color:
            SDLColor(
                format: SDLPixelFormat(format: .argb8888),
                red: color.red,
                green: color.green,
                blue: color.blue,
                alpha: color.alpha
            )
        )
        self.texture = try SDLTexture(
            renderer: renderer,
            surface: surface
        )
        
        try self.texture.setBlendMode([.alpha])
        self.attributes = try texture.attributes()
    }
    
    public func withUnsafeMutableBytes <Result> (_ body: (_ pointer: UnsafeMutableRawPointer, _ pitch: Int) throws -> Result) throws -> Result? {
        
        assert(try! texture.attributes().access == .streaming)
        
        return try texture.withUnsafeMutableBytes(body)
    }
}
