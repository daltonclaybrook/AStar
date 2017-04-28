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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGrid()
    }
    
    //MARK: Actions
    
    @IBAction func gridViewTapGestureRecognized(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: gridView)
        let nodeLocation = gridView.tileLocationOfTap(at: location)
        gridView.colorTileView(.lightGray, atX: nodeLocation.x, y: nodeLocation.y)
    }
    
    //MARK: Private
    
    private func configureGrid() {
        gridView.colorTileView(.green, atX: 0, y: 0)
        gridView.colorTileView(.red, atX: gridView.columns-1, y: gridView.rows-1)
    }
}
