//
//  View.swift
//  SwiftUI
//
//  Created by Alsey Coleman Miller on 4/21/19.
//

import CSDL2
import SDL

/// View
open class View {
    
    // MARK: - Properties
    
    public var frame: Frame {
        didSet { setNeedsDisplay() }
    }
    
    public private(set) var subviews = [View]()
    
    public private(set) weak var superview: View?
    
    internal var _window: Window?
    
    public var window: Window? {
        
        return _window ?? superview?.window
    }
    
    public var backgroundColor: Color = .white {
        didSet { setNeedsDisplay() }
    }
    
    public var alpha: Float = 1.0 {
        didSet {
            assert(alpha >= 0.0 && alpha <= 1.0, "Invalid alpha \(alpha)")
            setNeedsDisplay()
        }
    }
    
    public var isHidden: Bool {
        return alpha == 0.0
    }
    
    internal private(set) var textureCache = TextureCache()
    
    // MARK: - Initialization
    
    public init(frame: Frame = .zero) {
        self.frame = frame
    }
    
    // MARK: - Methods
    
    public func addSubview(_ view: View) {
        
        self.subviews.append(view)
        view.superview = self
    }
    
    public func removeFromSuperview() {
        
        guard let superview = self.superview,
            let index = superview.subviews.firstIndex(where: { $0 === self })
            else { return }
        
        superview.subviews.remove(at: index)
    }
    
    public func setNeedsDisplay() {
        
        guard let window = self.window
            else { return } // no attached to window
        
        window.needsDisplay = true
    }
    
    open func canvasSize(for window: Window) -> Size {
        
        return Size(
            width: Int(Float(frame.size.width) * window.scale),
            height: Int(Float(frame.size.height) * window.scale)
        )
    }
    
    internal var shouldRender: Bool {
        
        return isHidden == false
            && alpha > 0
            && frame.size.width >= 1
            && frame.size.height >= 1 // must be at least 1x1
    }
    
    internal final func render(in rect: SDL_Rect, for window: Window) throws {
        
        assert(shouldRender, "Should not render")
        
        let renderer = window.renderer
        
        // draw background texture
        if backgroundColor == .clear {
            self.textureCache.backgroundColor = nil // optimization
        } else {
            let backgroundTexture: Texture
            if let (color, cachedTexture) = textureCache.backgroundColor,
                color == backgroundColor {
                backgroundTexture = cachedTexture
            } else {
                backgroundTexture = try Texture(color: backgroundColor, renderer: renderer)
                self.textureCache.backgroundColor = (backgroundColor, backgroundTexture)
            }
            
            try renderer.render(backgroundTexture, alpha: alpha, in: rect, for: window)
        }
        
        // reuse cached drawable texture if view hasn't been resized.
        if let drawable = self as? DrawableView {
            
            let canvasSize = self.canvasSize(for: window)
            let drawableTexture: Texture
            
            if let cachedTexture = self.textureCache.drawable,
                cachedTexture.attributes.width == canvasSize.width,
                cachedTexture.attributes.height == canvasSize.height {
                drawableTexture = cachedTexture
            } else {
                drawableTexture = try Texture(width: canvasSize.width,
                                              height: canvasSize.height,
                                              renderer: renderer)
                self.textureCache.drawable = drawableTexture
            }
            
            drawable.draw(with: drawableTexture)
            
            try renderer.render(drawableTexture, alpha: alpha, in: rect, for: window)
        }
    }
}

extension SDLRenderer {
    
    func render(_ texture: Texture, alpha: Float, in rect: SDL_Rect, for window: Window) throws {
        
        try texture.texture.setAlphaModulation(UInt8(alpha * 255))
        try copy(texture.texture, destination: rect)
    }
}

// MARK: - Responder

extension View: Responder {
    
    open func event(_ event: Event) {
        
        subviews.forEach {
            $0.event(event)
        }
    }
}

// MARK: - Supporting Types

public protocol DrawableView: class {
    
    func draw(with texture: Texture)
    
    func canvasSize(for window: Window) -> Size
}

internal extension View {
    
    struct TextureCache {
        
        // 1x1 layer for background color texture
        var backgroundColor: (color: Color, texture: Texture)?
        
        // for draw operations, native size of view
        var drawable: Texture?
    }
}
