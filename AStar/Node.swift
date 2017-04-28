//
//  Node.swift
//  AStar
//
//  Created by Dalton Claybrook on 4/25/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import Foundation

class Node {
    let x: Int
    let y: Int
    var isBlocked = false
    var neighbors = WeakArray<Node>()
    var unblockedNeighbors: [Node] {
        return neighbors.filter { !$0.isBlocked }
    }
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    static var zero: Node {
        return Node(x: 0, y: 0)
    }
    
    func distanceTo(node: Node) -> Double {
        return sqrt(pow(Double(node.x - x), 2.0) + pow(Double(node.y - y), 2.0))
    }
    
    func offsetBy(x: Int, y: Int) -> Node {
        return Node(x: self.x + x, y: self.y + y)
    }
}

extension Node: Hashable {
    var hashValue: Int {
        return (x << 8) ^ y
    }
    static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

extension Node: CustomStringConvertible {
    var description: String {
        return "x: \(x), y: \(y)"
    }
}
