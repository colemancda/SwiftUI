//
//  WeakReference.swift
//  SwiftUI
//
//  Created by Alsey Coleman Miller on 4/21/19.
//

import Foundation

internal final class WeakReference<Value: AnyObject> {
    
    weak var value: Value?
    
    init(_ value: Value) {
        
        self.value = value
    }
}

/// An array that keeps weak references.
internal struct WeakArray <Element: AnyObject> {
    
    private var storage = [WeakReference<Element>]()
    
    internal mutating func values() -> [Element] {
        
        purgedReleased()
        return strongReferences
    }
    
    private var strongReferences: [Element] {
        
        return storage.compactMap { $0.value }
    }
    
    internal mutating func append(_ element: Element) {
        
        purgedReleased()
        storage.append(WeakReference(element))
    }
    
    /// purge released objects
    private mutating func purgedReleased() {
        
        storage = storage.filter({ $0.value != nil })
    }
    
    public init(elements: [Element]) {
        
        self.storage = elements.map { WeakReference($0) }
    }
}

extension WeakArray: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: Element...) {
        
        self.init(elements: elements)
    }
}
