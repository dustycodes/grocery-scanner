//
//  SectionCell.swift
//  GroceryApp
//
//  Created by Dusty Argyle on 4/9/16.
//  Copyright © 2016 Dusty Argyle. All rights reserved.
//

import UIKit

class SectionCell: UICollectionViewCell {
    var titleView: UILabel = UILabel()
    var imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect)
    {
        super.init(frame: CGRect())
        setUpScreen()
    }
    
    func setUpScreen()
    {
        imageView.drawRect(CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height*2/3))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        contentView.addSubview(imageView)
        
        titleView = UILabel(frame: CGRect(x: 0, y: imageView.frame.size.height, width: frame.size.width, height: frame.size.height/3))
        titleView.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        titleView.textAlignment = .Center
        contentView.addSubview(titleView)
    }
    
    override func layoutSubviews()
    {
        self.titleView.frame = self.bounds
        titleView.backgroundColor = UIColor.lightGrayColor()
        titleView.textAlignment = .Center
        self.imageView.frame = self.bounds
    }
    
    override func prepareForReuse()
    {
        titleView.text = ""
        imageView.image = UIImage()
    }
    
    func draw(section: Section)
    {
        titleView.text = section.name
        imageView.image = section.image
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}