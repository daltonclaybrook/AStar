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
        
        let nodes = [
            Node(x: 3, y: 4),
            Node(x: 3, y: 5),
            Node(x: 3, y: 6),
            Node(x: 4, y: 5),
            Node(x: 5, y: 4),
            Node(x: 6, y: 5),
            Node(x: 7, y: 5)
        ]
        gridView.drawPath(withNodes: nodes)
    }
    
    //MARK: Private
}
