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
    private var currentNodePath: [Node]?
    
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
    
    func colorTileView(_ color: UIColor, atX x: Int, y: Int) {
        getTileView(atX: x, y: y).backgroundColor = color
    }
    
    func colorTileView(_ color: UIColor, atLocation location: CGPoint) {
        tileViews.forEach { view in
            guard view.frame.contains(location) else { return }
            view.backgroundColor = color
        }
    }
    
    func drawPath(withNodes nodes: [Node]) {
        guard nodes.count >= 2 else { return }
        currentNodePath = nodes
        
        var nodesCopy = nodes
        let first = nodesCopy.removeFirst()
        let path = UIBezierPath()
        path.move(to: centerOfTile(atX: first.x, y: first.y))
        nodesCopy.forEach { path.addLine(to: self.centerOfTile(atX: $0.x, y: $0.y)) }
        pathLayer.path = path.cgPath
    }
    
    func tileLocationOfTap(at point: CGPoint) -> (x: Int, y: Int) {
        guard let index = tileViews.enumerated().filter({ offset, tileView in
            return tileView.frame.contains(point)
        }).first?.offset else { return (0,0) }
        
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
                let tileView = getTileView(atX: x, y: y)
                tileView.frame = CGRect(x: xOffset, y: yOffset, width: tileWidth, height: tileHeight)
            }
        }
        
        if let pathNodes = currentNodePath {
            drawPath(withNodes: pathNodes)
        }
    }
    
    private func getTileView(atX x: Int, y: Int) -> UIView {
        let idx = y * columns + x
        return tileViews[idx]
    }
    
    private func getLocationOfTile(atIndex index: Int) -> (x: Int, y: Int) {
        let x = index % columns
        let y = index / columns
        return (x, y)
    }
    
    private func centerOfTile(atX x: Int, y: Int) -> CGPoint {
        return getTileView(atX: x, y: y).center
    }
}
