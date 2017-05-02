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
    var startNode: NodeRef {
        return grid.nodeRef(atNode: .zero)!
    }
    var goalNode: NodeRef {
        let node = Node(x: grid.width-1, y: grid.height-1)
        return grid.nodeRef(atNode: node)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetGridView()
    }
    
    //MARK: Actions
    
    @IBAction func gridViewTapGestureRecognized(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: gridView)
        guard let node = gridView.tileLocationOfTap(at: location),
            let nodeRef = grid.nodeRef(atNode: node) else { return }
        
        nodeRef.isBlocked = !nodeRef.isBlocked
        let color: UIColor = nodeRef.isBlocked ? .lightGray : .white
        gridView.colorTileView(color, atNode: nodeRef.node)
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
        gridView.colorTileView(.green, atNode: startNode.node)
        gridView.colorTileView(.red, atNode: goalNode.node)
    }
}
