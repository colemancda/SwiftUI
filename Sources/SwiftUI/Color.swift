//
//  Color.swift
//  SwiftUI
//
//  Created by Alsey Coleman Miller on 4/22/19.
//

public struct Color: Equatable, Hashable {
    
    public var red: UInt8
    
    public var green: UInt8
    
    public var blue: UInt8
    
    public var alpha: UInt8
    
    public init(red: UInt8,
                green: UInt8,
                blue: UInt8,
                alpha: UInt8 = .max) {
        
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
}

public extension Color {
    
    static func random(alpha: UInt8 = .max) -> Color {
        
        return Color(
            red: .random(in: .min ... .max),
            green: .random(in: .min ... .max),
            blue: .random(in: .min ... .max),
            alpha: alpha
        )
    }
}

public extension Color {
    
    static var clear: Color { return Color(red: 0, green: 0, blue: 0, alpha: 0) }
    
    static var black: Color { return Color(red: 0, green: 0, blue: 0) }
    
    static var white: Color { return Color(red: .max, green: .max, blue: .max) }
    
    static var red: Color { return Color(red: .max, green: 0, blue: 0) }
    
    static var green: Color { return Color(red: 0, green: .max, blue: 0) }
    
    static var blue: Color { return Color(red: 0, green: 0, blue: .max) }
}
