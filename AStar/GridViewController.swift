//
//  GridViewController.swift
//  AStar
//
//  Created by Dalton Claybrook on 4/27/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

class GridViewController: UIViewController {
    
    @IBOutlet var gridView: GridView!
    let grid = Grid(width: 10, height: 10)
    var startNode: Node {
        return grid.node(atX: 0, y: 0)!
    }
    var goalNode: Node {
        return grid.node(atX: grid.width-1, y: grid.height-1)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetGridView()
    }
    
    //MARK: Actions
    
    @IBAction func gridViewTapGestureRecognized(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: gridView)
        guard let nodeLocation = gridView.tileLocationOfTap(at: location),
            let node = grid.node(atX: nodeLocation.x, y: nodeLocation.y) else { return }
        
        node.isBlocked = !node.isBlocked
        let color: UIColor = node.isBlocked ? .lightGray : .white
        gridView.colorTileView(color, atX: node.x, y: node.y)
    }
    
    @IBAction func findPathButtonPressed(_ sender: Any) {
        guard let pathNodes = Path.findPath(from: startNode, to: goalNode) else {
            gridView.clearPath()
            return
        }
        gridView.drawPath(withNodes: pathNodes)
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        grid.gridNodes.forEach { $0.isBlocked = false }
        resetGridView()
    }
    
    //MARK: Private
    
    private func resetGridView() {
        gridView.clearPath()
        let startNode = self.startNode
        let goalNode = self.goalNode
        
        gridView.colorAllTiles(.white)
        gridView.colorTileView(.green, atX: startNode.x, y: startNode.y)
        gridView.colorTileView(.red, atX: goalNode.x, y: goalNode.y)
    }
}
