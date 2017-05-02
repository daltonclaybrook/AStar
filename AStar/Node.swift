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
        let (blocked, unblocked) = neighbors.filterSplit { $0.isBlocked }
        let blockedNodes = blocked.map { $0.node }
        let (unblockedCorners, unblockedSides) = unblocked.filterSplit { $0.node.x != node.x && $0.node.y != node.y }
        var outNodes = unblockedSides
        
        outNodes += unblockedCorners.flatMap { cornerRef -> NodeRef? in
            let corner = cornerRef.node
            return !blockedNodes.contains {
                abs(corner.x - $0.x) <= 1 && abs(corner.y - $0.y) <= 1
            } ? cornerRef : nil
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

extension Collection {
    func filterSplit(predicate: (Iterator.Element) -> Bool) -> (pass: [Iterator.Element], fail: [Iterator.Element]) {
        var pass = Array<Iterator.Element>()
        var fail = Array<Iterator.Element>()
        for element in self {
            if predicate(element) {
                pass.append(element)
            } else {
                fail.append(element)
            }
        }
        return (pass, fail)
    }
}
