//
//  GridView.swift
//  AStar
//
//  Created by Dalton Claybrook on 4/27/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

class GridView: UIView {
    override var frame: CGRect { didSet { updateView() } }
    override var bounds: CGRect { didSet { updateView() } }
    
    var columns = 10 { didSet { resetAllViews() } }
    var rows = 10 { didSet { resetAllViews() } }
    var tileSpacing: CGFloat = 2.0 { didSet { updateView() } }
    var tileColor = UIColor.white
    
    private var tileViews = [UIView]()
    private let pathLayerView = UIView()
    private let pathLayer = CAShapeLayer()
    private var currentNodePath: [NodeRef]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPathLayer()
        resetAllViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPathLayer()
        resetAllViews()
    }
    
    //MARK: Public
    
    func colorTileView(_ color: UIColor, atNode node: Node) {
        getTileView(atNode: node).backgroundColor = color
    }
    
    func colorTileView(_ color: UIColor, atLocation location: CGPoint) {
        tileViews.forEach { view in
            guard view.frame.contains(location) else { return }
            view.backgroundColor = color
        }
    }
    
    func colorAllTiles(_ color: UIColor) {
        tileViews.forEach { $0.backgroundColor = color }
    }
    
    func clearPath() {
        pathLayer.path = nil
    }
    
    func drawPath(withNodes nodes: [NodeRef]) {
        guard nodes.count >= 2 else { return }
        currentNodePath = nodes
        
        var nodesCopy = nodes
        let first = nodesCopy.removeFirst()
        let path = UIBezierPath()
        path.move(to: centerOfTile(atNode: first.node))
        nodesCopy.forEach { path.addLine(to: self.centerOfTile(atNode: $0.node)) }
        pathLayer.path = path.cgPath
    }
    
    func tileLocationOfTap(at point: CGPoint) -> Node? {
        guard let index = tileViews.enumerated().filter({ offset, tileView in
            return tileView.frame.contains(point)
        }).first?.offset else { return nil }
        
        return getLocationOfTile(atIndex: index)
    }
    
    //MARK: Private
    
    private func setupPathLayer() {
        addSubview(pathLayerView)
        pathLayerView.constrainEdgesToSuperview()
        pathLayerView.backgroundColor = .clear
        pathLayerView.layer.addSublayer(pathLayer)
        pathLayer.fillColor = nil
        pathLayer.strokeColor = UIColor.black.cgColor
        pathLayer.lineWidth = 2.0
    }
    
    private func resetAllViews() {
        tileViews.forEach { $0.removeFromSuperview() }
        tileViews = []
        
        for _ in (0..<columns * rows) {
            let tileView = UIView(frame: .zero)
            tileView.backgroundColor = tileColor
            addSubview(tileView)
            tileViews.append(tileView)
        }
        
        bringSubview(toFront: pathLayerView)
        updateView()
    }
    
    private func updateView() {
        guard tileViews.count > 0 else { return }
        
        let tileWidth = (bounds.width - (tileSpacing * CGFloat(columns + 1))) / CGFloat(columns)
        let tileHeight = (bounds.height - (tileSpacing * CGFloat(rows + 1))) / CGFloat(rows)
        
        for y in (0..<rows) {
            for x in (0..<columns) {
                let xOffset = CGFloat(x) * (tileWidth + tileSpacing) + tileSpacing
                let yOffset = CGFloat(y) * (tileHeight + tileSpacing) + tileSpacing
                let tileView = getTileView(atNode: Node(x: x, y: y))
                tileView.frame = CGRect(x: xOffset, y: yOffset, width: tileWidth, height: tileHeight)
            }
        }
        
        if let pathNodes = currentNodePath {
            drawPath(withNodes: pathNodes)
        }
    }
    
    private func getTileView(atNode node: Node) -> UIView {
        let idx = node.y * columns + node.x
        return tileViews[idx]
    }
    
    private func getLocationOfTile(atIndex index: Int) -> Node {
        let x = index % columns
        let y = index / columns
        return Node(x: x, y: y)
    }
    
    private func centerOfTile(atNode node: Node) -> CGPoint {
        return getTileView(atNode: node).center
    }
}
