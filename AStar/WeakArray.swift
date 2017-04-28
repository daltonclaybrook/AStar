//
//  WeakArray.swift
//  AStar
//
//  Created by Dalton Claybrook on 4/25/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

struct WeakArray<Element: AnyObject> {
    fileprivate var backing: [Weakable<Element>]
    
    init(_ array: [Element]) {
        backing = array.map { Weakable($0) }
    }
    
    mutating func cleanup() {
        backing = backing.flatMap { $0.element != nil ? $0 : nil }
    }
}

extension WeakArray: Collection {
    typealias Iterator = IndexingIterator<[Element]>
    typealias Index = Int
    
    private var flattened: [Element] {
        return backing.flatMap { $0.element }
    }
    
    func makeIterator() -> IndexingIterator<[Element]> {
        return IndexingIterator(_elements: flattened)
    }
    
    var startIndex: Int {
        return flattened.startIndex
    }
    
    var endIndex: Int {
        return flattened.endIndex
    }
    
    subscript(position: Int) -> Element {
        return flattened[position]
    }
    
    func index(after i: Int) -> Int {
        return flattened.index(after: i)
    }
}

extension WeakArray: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        backing = elements.map { Weakable($0) }
    }
}

struct Weakable<Element: AnyObject> {
    private(set) weak var element: Element?
    
    init(_ element: Element) {
        self.element = element
    }
}
