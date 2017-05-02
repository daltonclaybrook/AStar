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
    let gridNodes: [NodeRef]
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        gridNodes = Grid.createGridNodes(forWidth: width, height: height)
    }
    
    //MARK: Public
    
    func nodeRef(atNode node: Node) -> NodeRef? {
        return gridNodes.at(x: node.x, y: node.y, width: width)
    }
    
    //MARK: Private
    
    private static func createGridNodes(forWidth width: Int, height: Int) -> [NodeRef] {
        var nodes = [NodeRef]()
        for y in (0..<height) {
            for x in (0..<width) {
                nodes.append(NodeRef(x: x, y: y))
            }
        }
        for idx in (0..<nodes.count) {
            let node = nodes[idx]
            nodes[idx].neighbors = neighbors(forNode: node, inNodes: nodes, width: width, height: height)
        }
        return nodes
    }
    
    private static func neighbors(forNode nodeRef: NodeRef, inNodes allNodes: [NodeRef], width: Int, height: Int) -> WeakArray<NodeRef> {
        let neighborPrototypes = [
            nodeRef.node.offsetBy(x: 1, y: 0),
            nodeRef.node.offsetBy(x: 1, y: 1),
            nodeRef.node.offsetBy(x: 0, y: 1),
            nodeRef.node.offsetBy(x: -1, y: 1),
            nodeRef.node.offsetBy(x: -1, y: 0),
            nodeRef.node.offsetBy(x: -1, y: -1),
            nodeRef.node.offsetBy(x: 0, y: -1),
            nodeRef.node.offsetBy(x: 1, y: -1)
            ]
            .filter { $0.x >= 0 && $0.x < width && $0.y >= 0 && $0.y < height }
        
        let neighborNodes = neighborPrototypes.flatMap {
            allNodes.at(x: $0.x, y: $0.y, width: width)
        }
        return WeakArray(neighborNodes)
    }
}

extension Array where Element == NodeRef {
    func at(x: Int, y: Int, width: Int) -> NodeRef? {
        let idx = y * width + x
        guard idx >= 0 && idx < count else { return nil }
        return self[idx]
    }
}
