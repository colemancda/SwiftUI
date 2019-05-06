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
}

internal extension View {
    
    final class TextureCache {
        
        fileprivate init() { }
        
        // 1x1 layer for background color texture
        var backgroundColor: Texture?
        
        // for draw operations, native size of view
        var drawable: Texture?
    }
}

open class DrawableView: View {
    
    open func draw(with texture: Texture) {
        assertionFailure("Should override in subclass \(DrawableView.self)")
    }
    
    open func canvasSize(for window: Window) -> Size {
        return window.nativeSize
    }
}
