//
//  Frame.swift
//  SwiftUI
//
//  Created by Alsey Coleman Miller on 4/22/19.
//

public struct Frame: Equatable, Hashable {
    
    public var origin: Point
    
    public var size: Size
    
    public init(origin: Point, size: Size) {
        
        self.origin = origin
        self.size = size
    }
}

public extension Frame {
    
    static var zero: Frame { return Frame(origin: .zero, size: .zero) }
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
