//
//  Path.swift
//  AStar
//
//  Created by Dalton Claybrook on 4/24/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import Foundation

struct Path {
    static func findPath(from start: NodeRef, to goal: NodeRef) -> [NodeRef]? {
        var closedSet = [NodeRef]()
        var openSet = [start]
        var cameFrom = [NodeRef: NodeRef]()
        var gScore = [ start: 0.0 ]
        var fScore = [ start: heuristicCostEstimate(from: start.node, to: goal.node)]
        
        while !openSet.isEmpty {
            let current = openSet.enumerated().sorted { node1, node2 in fScore[node1.element]! < fScore[node2.element]! }.first!
            if current.element == goal {
                return reconstructPath(cameFrom: cameFrom, node: current.element)
            }
            
            openSet.remove(at: current.offset)
            closedSet.append(current.element)
            for neighbor in current.element.unblockedNeighbors {
                if closedSet.contains(neighbor) {
                    continue
                }
                
                let tentativeGScore = gScore[current.element]! + current.element.node.distanceTo(node: neighbor.node)
                if !openSet.contains(neighbor) {
                    openSet.append(neighbor)
                }
                
                if let neighborGScore = gScore[neighbor], tentativeGScore >= neighborGScore {
                    continue
                }
                
                cameFrom[neighbor] = current.element
                gScore[neighbor] = tentativeGScore
                fScore[neighbor] = tentativeGScore + heuristicCostEstimate(from: neighbor.node, to: goal.node)
            }
        }
        
        return nil
    }
    
    //MARK: Private
    
    private static func heuristicCostEstimate(from: Node, to: Node) -> Double {
        let xDiagonal = Double(abs(from.x - to.x))
        let yDiagonal = Double(abs(from.y - to.y))
        let minDiagonal = min(xDiagonal, yDiagonal)
        let straight = max(xDiagonal, yDiagonal) - minDiagonal
        
        // srt(2) is the distance between two adjacent diagonal tiles
        return sqrt(2) * minDiagonal + straight
    }
    
    private static func reconstructPath(cameFrom: [NodeRef: NodeRef], node: NodeRef) -> [NodeRef] {
        var path = [node]
        var current = node
        while cameFrom[current] != nil {
            current = cameFrom[current]!
            path.insert(current, at: 0)
        }
        return path
    }
}
