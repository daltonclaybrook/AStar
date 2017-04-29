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
    var unblockedNeighbors: WeakArray<Node> {
        return generateUnblockedNeighbors()
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
    
    //MARK: Private
    
    private func generateUnblockedNeighbors() -> WeakArray<Node> {
        let unblocked = neighbors.filter { !$0.isBlocked }
        let blocked = neighbors.filter { $0.isBlocked }
        
        var outNodes = [Node]()
        for neighbor in unblocked {
            var nodeIsUnblocked = true
            if neighbor.x != x && neighbor.y != y {
                // corner
                nodeIsUnblocked = !blocked.contains {
                    abs(neighbor.x - $0.x) <= 1 &&
                        abs(neighbor.y - $0.y) <= 1
                }
            }
            
            if nodeIsUnblocked {
                outNodes.append(neighbor)
            }
        }
        return WeakArray(outNodes)
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
