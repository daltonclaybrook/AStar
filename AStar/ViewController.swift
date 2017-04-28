//
//  ViewController.swift
//  AStar
//
//  Created by Dalton Claybrook on 4/24/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let roomWidth = 10
    let roomHeight = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nodes = createAllRoomNodes()
        let fromNode = nodes.at(x: 1, y: 4, width: roomWidth)!
        let toNode = nodes.at(x: 9, y: 4, width: roomWidth)!
        let path = Path.findPath(from: fromNode, to: toNode)
        print("fin")
    }
    
    private func createAllRoomNodes() -> [Node] {
        var nodes = [Node]()
        
        for y in (0..<roomHeight) {
            for x in (0..<roomWidth) {
                nodes.append(Node(x: x, y: y))
            }
        }
        
        for idx in (0..<nodes.count) {
            let node = nodes[idx]
            nodes[idx].neighbors = neighbors(forNode: node, inNodes: nodes, width: roomWidth, height: roomHeight)
        }
        
        //Block
        nodes.at(x: 5, y: 2, width: roomWidth)?.isBlocked = true
        nodes.at(x: 5, y: 3, width: roomWidth)?.isBlocked = true
        nodes.at(x: 5, y: 4, width: roomWidth)?.isBlocked = true
        nodes.at(x: 5, y: 5, width: roomWidth)?.isBlocked = true
        nodes.at(x: 5, y: 6, width: roomWidth)?.isBlocked = true
        
        return nodes
    }
    
    private func neighbors(forNode node: Node, inNodes allNodes: [Node], width: Int, height: Int) -> WeakArray<Node> {
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
