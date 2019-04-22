//
//  View.swift
//  SwiftUI
//
//  Created by Alsey Coleman Miller on 4/21/19.
//

import SDL

/// View
public struct View {
    
    // MARK: - Properties
    
    public var frame: Frame
    
    public var subviews: [View]
    
    public var backgroundColor: Color
    
    public var draw: (() -> ())?
    
    // MARK: - Initialization
    
    public init(frame: Frame,
                subviews: [View] = [],
                backgroundColor: Color = .white) {
        
        self.frame = frame
        self.subviews = subviews
        self.backgroundColor = backgroundColor
    }
}
