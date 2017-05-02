//
//  Node.swift
//  AStar
//
//  Created by Dalton Claybrook on 4/25/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import Foundation

struct Node {
    let x: Int
    let y: Int
    
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

class NodeRef {
    let node: Node
    var isBlocked = false
    
    var neighbors = WeakArray<NodeRef>()
    var unblockedNeighbors: WeakArray<NodeRef> {
        return generateUnblockedNeighbors()
    }
    
    init(x: Int, y: Int) {
        node = Node(x: x, y: y)
    }
    
    //MARK: Private
    
    private func generateUnblockedNeighbors() -> WeakArray<NodeRef> {
        let unblocked = neighbors.filter { !$0.isBlocked }
        let blocked = neighbors.filter { $0.isBlocked }
        
        var outNodes = [NodeRef]()
        for neighbor in unblocked {
            var nodeIsUnblocked = true
            if neighbor.node.x != node.x && neighbor.node.y != node.y {
                // corner
                nodeIsUnblocked = !blocked.contains {
                    abs(neighbor.node.x - $0.node.x) <= 1 &&
                        abs(neighbor.node.y - $0.node.y) <= 1
                }
            }
            
            if nodeIsUnblocked {
                outNodes.append(neighbor)
            }
        }
        return WeakArray(outNodes)
    }
}

extension NodeRef: Hashable {
    var hashValue: Int {
        return node.hashValue
    }
    static func ==(lhs: NodeRef, rhs: NodeRef) -> Bool {
        return lhs.node == rhs.node
    }
}

extension NodeRef: CustomStringConvertible {
    var description: String {
        return "x: \(node.x), y: \(node.y)"
    }
}
