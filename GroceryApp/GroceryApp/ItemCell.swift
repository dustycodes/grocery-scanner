//
//  ItemCell.swift
//  GroceryApp
//
//  Created by Dusty Argyle on 4/9/16.
//  Copyright © 2016 Dusty Argyle. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    //let paintingView: UIView = UIView()
    var titleView: UILabel = UILabel()
    
    override init(frame: CGRect)
    {
        super.init(frame: CGRect())
        setUpScreen()
    }
    
    func setUpScreen()
    {
        titleView.drawRect(self.frame)
        addSubview(titleView)
    }
    
    override func layoutSubviews()
    {
        self.titleView.frame = self.bounds
        titleView.backgroundColor = UIColor.lightGrayColor()
        titleView.textAlignment = .Center
    }
    
    //this will get called when a cell is about to be reused, not every cell in a collection view is unique,
    //rather they will be reused numerous times to save resources. So make sure to clear out the old paiting
    //and replace it with the new painting that you want
    override func prepareForReuse()
    {
        //paintingView.setPainting(Painting())
        titleView.text = ""
    }
    
    func draw(item: Item)
    {
        titleView.text = item.name
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}