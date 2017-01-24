//
//  ItemView.swift
//  GroceryApp
//
//  Created by Dusty Argyle on 4/10/16.
//  Copyright © 2016 Dusty Argyle. All rights reserved.
//

import UIKit

class ItemView: UIView {
    //Private vars
    private var _item: Item = Item()
    private var _nameField: UITextField = UITextField(frame: CGRectZero)
    private var _descriptionField: UITextView = UITextView(frame: CGRectZero)
    private var _image: UIImage?
    private var _quantity: UILabel = UILabel(frame: CGRectZero)
    
    //Public vars & accessors
    var delegate: GroceryListDelegate?
    var deleteDelegate: DeleteItemDelegate?
    var modifyDelegate: ModifyItemDelegate?
    var isInGroceryList: Bool = false


    var item: Item {
        get {
            return _item
        }
        set {
            _item = newValue
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    var image: UIImage {
        get {
            if(_image == nil) {
                _image = UIImage()
            }
            return _image!
        }
        set {
            _image = newValue
            _item.image = newValue
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    //Constructors
    override init(frame: CGRect) {
        super.init(frame: CGRect())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //View Methods
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
    }
    
    // View methods
    override func layoutSubviews() {
        //clear subviews
        subviews.forEach({ $0.removeFromSuperview() })
        
        let start_height = self.bounds.height/30
        
        let description = UILabel(frame: CGRect(x: 0, y: start_height, width: frame.width, height: 150))
        description.textAlignment = .Center
        description.textColor = UIColor.whiteColor()
        description.text = _item.description
        
        let imageView = UIImageView(frame: CGRect(x: 20, y: start_height + description.bounds.height, width: frame.width-40, height: 200))
        imageView.image = _item.image
        
        _quantity = UILabel(frame: CGRect(x: frame.width/2-25, y: start_height + description.bounds.height + imageView.bounds.height, width: 50, height: 50))
        _quantity.textAlignment = .Center
        _quantity.textColor = UIColor.whiteColor()
        _quantity.text = String(_item.quantity)
        
        let subtractButton = UIButton(frame: CGRect(x: 20, y:  start_height + description.bounds.height + imageView.bounds.height, width: 50, height: 50))
        subtractButton.setTitle("-", forState: UIControlState.Normal)
        subtractButton.backgroundColor = UIColor.lightGrayColor()
        subtractButton.addTarget(self, action: "subtractQuantityPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let addButton = UIButton(frame: CGRect(x: frame.width - 70, y:  start_height + description.bounds.height + imageView.bounds.height, width: 50, height: 50))
        addButton.setTitle("+", forState: UIControlState.Normal)
        addButton.backgroundColor = UIColor.lightGrayColor()
        addButton.addTarget(self, action: "addQuantityPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let quantityLabel = UILabel(frame: CGRect(x: frame.width/2-50, y: start_height + description.bounds.height + imageView.bounds.height + _quantity.bounds.height - 20, width: 100, height: 50))
        quantityLabel.textAlignment = .Center
        quantityLabel.textColor = UIColor.whiteColor()
        quantityLabel.text = String("Quantity")
        
        addSubview(description)
        addSubview(imageView)
        addSubview(_quantity)
        addSubview(quantityLabel)
        addSubview(subtractButton)
        addSubview(addButton)
        
        // Modify/Delete stuff
        
        if(!isInGroceryList) {
            let modifyListButton = UIButton(frame: CGRect(x: 0, y: frame.height-50, width: frame.width/2, height: 50))
            modifyListButton.backgroundColor = UIColor.lightGrayColor()
            modifyListButton.setTitle("Modify", forState: UIControlState.Normal)
            modifyListButton.addTarget(self, action: "modifyItem", forControlEvents: UIControlEvents.TouchUpInside)
            let deleteButton = UIButton(frame: CGRect(x: modifyListButton.frame.width, y: frame.height-50,  width: frame.width/2, height: 50))
            deleteButton.backgroundColor = UIColor.lightGrayColor()
            deleteButton.setTitle("Delete", forState: UIControlState.Normal)
            deleteButton.addTarget(self, action: "deleteItem", forControlEvents: UIControlEvents.TouchUpInside)
            addSubview(modifyListButton)
            addSubview(deleteButton)
        }
    }
    
    func addQuantityPressed(button: UIButton) {
        if(_item.quantity >= 0) {
            delegate?.removeFromGroceryList(_item)
        }
        _item.quantity = _item.quantity + 1
        _quantity.text = String(_item.quantity)
    }
    
    func subtractQuantityPressed(button: UIButton) {
        if(_item.quantity <= 1) {
            delegate?.addToGroceryList(_item)
        }
        _item.quantity = _item.quantity - 1
        if(_item.quantity < 1) {
            _item.quantity = 0
        }
        _quantity.text = String(_item.quantity)
    }
    func deleteItem() {
        deleteDelegate?.deleteItem(_item)
    }
    func modifyItem() {
        modifyDelegate?.modifyItem(_item)
    }
}
