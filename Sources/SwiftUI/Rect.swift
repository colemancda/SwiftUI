//
//  Frame.swift
//  SwiftUI
//
//  Created by Alsey Coleman Miller on 4/22/19.
//

public struct Rect: Equatable, Hashable {
    
    public var origin: Point
    
    public var size: Size
    
    public init(origin: Point, size: Size) {
        
        self.origin = origin
        self.size = size
    }
}

public extension Rect {
    
    static var zero: Rect { return Rect(origin: .zero, size: .zero) }
    
    var minX: Int { return self.origin.x + min(self.size.width, 0) }
    var maxX: Int { return self.origin.x + max(self.size.width, 0) }
    
    var minY: Int { return self.origin.y + min(self.size.height, 0) }
    var maxY: Int { return self.origin.y + max(self.size.height, 0) }
}

public struct Point: Equatable, Hashable {
    
    public var x: Int
    
    public var y: Int
    
    public init(x: Int, y: Int) {
        
        self.x = x
        self.y = y
    }
}

public extension Point {
    
    static var zero: Point { return Point(x: 0, y: 0) }
}

public struct Size: Equatable, Hashable {
    
    public var width: Int
    
    public var height: Int
    
    public init(width: Int, height: Int) {
        
        self.width = width
        self.height = height
    }
}

public extension Size {
    
    static var zero: Size { return Size(width: 0, height: 0) }
}
