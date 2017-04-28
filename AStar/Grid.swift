//
//  Grid.swift
//  AStar
//
//  Created by Dalton Claybrook on 4/28/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import Foundation

struct Grid {
    let width: Int
    let height: Int
    private let gridNodes: [Node]
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        gridNodes = Grid.createGridNodes(forWidth: width, height: height)
    }
    
    //MARK: Public
    
    func node(atX x: Int, y: Int) -> Node? {
        return gridNodes.at(x: x, y: y, width: width)
    }
    
    //MARK: Private
    
    private static func createGridNodes(forWidth width: Int, height: Int) -> [Node] {
        var nodes = [Node]()
        for y in (0..<height) {
            for x in (0..<width) {
                nodes.append(Node(x: x, y: y))
            }
        }
        for idx in (0..<nodes.count) {
            let node = nodes[idx]
            nodes[idx].neighbors = neighbors(forNode: node, inNodes: nodes, width: width, height: height)
        }
        return nodes
    }
    
    private static func neighbors(forNode node: Node, inNodes allNodes: [Node], width: Int, height: Int) -> WeakArray<Node> {
        let neighborPrototypes = [
            node.offsetBy(x: 1, y: 0),
            node.offsetBy(x: 1, y: 1),
            node.offsetBy(x: 0, y: 1),
            node.offsetBy(x: -1, y: 1),
            node.offsetBy(x: -1, y: 0),
            node.offsetBy(x: -1, y: -1),
            node.offsetBy(x: 0, y: -1),
            node.offsetBy(x: 1, y: -1)
            ]
            .filter { $0.x >= 0 && $0.x < width && $0.y >= 0 && $0.y < height }
        
        let neighborNodes = neighborPrototypes.flatMap {
            allNodes.at(x: $0.x, y: $0.y, width: width)
        }
        return WeakArray(neighborNodes)
    }
}

extension Array where Element == Node {
    func at(x: Int, y: Int, width: Int) -> Node? {
        let idx = y * width + x
        guard idx >= 0 && idx < count else { return nil }
        return self[idx]
    }
}
