//
//  View.swift
//  SwiftUI
//
//  Created by Alsey Coleman Miller on 4/21/19.
//

import SDL

/// View
open class View {
    
    // MARK: - Properties
    
    public var frame: Frame
    
    public private(set) var subviews = [View]()
    
    public private(set) weak var superView: View?
    
    public var backgroundColor: Color = .white
    
    internal let textureCache = TextureCache()
    
    // MARK: - Initialization
    
    public init(frame: Frame = .zero) {
        self.frame = frame
    }
    
    // MARK: - Methods
    
    public func addSubview(_ view: View) {
        
        self.subviews.append(view)
        view.superView = self
    }
    
    public func removeFromSuperview() {
        
        self.superView?.subviews.removeAll(where: { $0 === self })
    }
    
    open func canvasSize(for window: Window) -> Size {
        return Size(
            width: Int(Float(frame.size.width) * window.scale),
            height: Int(Float(frame.size.height) * window.scale)
        )
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
        var backgroundColor: Texture?
        
        // for draw operations, native size of view
        var drawable: Texture?
    }
}
