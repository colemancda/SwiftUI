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
    
    public var subviews = [View]()
    
    public var backgroundColor: Color = .white
    
    internal let layerCache = LayerCache()
    
    // MARK: - Initialization
    
    public init(frame: Frame = .zero) {
        
        self.frame = frame
    }
}

internal final class LayerCache {
    
    internal init() { }
    
    // 1x1 layer for background color texture
    var backgroundColorLayer: Layer?
    
    var drawableLayer: Layer?
}

internal extension Layer {
    
    convenience init(color: Color, renderer: SDLRenderer) throws {
        
        try self.init(width: 1, height: 1, scale: 1, renderer: renderer)
        self.texture
    }
}

protocol Drawable {
    
    func draw(with layer: Layer)
}
