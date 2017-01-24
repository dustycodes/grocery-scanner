//
//  NewSectionView.swift
//  GroceryApp
//
//  Created by Dusty Argyle on 4/9/16.
//  Copyright © 2016 Dusty Argyle. All rights reserved.
//

import UIKit



class NewSectionView: UIView {
    //Private vars
    private var _section: Section = Section()
    private var _nameField: UITextField = UITextField(frame: CGRectZero)
    private var _descriptionField: UITextView = UITextView(frame: CGRectZero)
    private var _image: UIImage?
    
    //Public vars & accessors
    var delegate: AddSectionDelegate?
    var immediateDelegate: PhotoPickerDelegate?
    var section: Section {
        get {
            return _section
        }
        set {
            _section = newValue
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
            section.image = newValue
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
        
        let nameLabel: UILabel = UILabel (frame: CGRect(x: 0, y: 70, width: frame.width, height: 20))
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.text = "Name"
        nameLabel.textAlignment = .Center
        _nameField = UITextField(frame: CGRect(x: 10, y: 75 + nameLabel.frame.height, width: frame.width-20, height: 35))
        _nameField.backgroundColor = UIColor.whiteColor()
        if(_section.name != "") {
            _nameField.text = _section.name
        }
        
        let descriptionLabel: UILabel = UILabel (frame: CGRect(x: 0, y: 80+_nameField.frame.height + nameLabel.frame.height, width: frame.width, height: 20))
        descriptionLabel.textColor = UIColor.whiteColor()
        descriptionLabel.textAlignment = .Center
        descriptionLabel.text = "Description"
        _descriptionField = UITextView(frame: CGRect(x: 10, y: 85+_nameField.frame.height + nameLabel.frame.height + descriptionLabel.frame.height, width: frame.width-20, height: 50))
        _descriptionField.backgroundColor = UIColor.whiteColor()
        if(_section.description != "") {
            _descriptionField.text = _section.description
        }
        
        let imageView = UIImageView(frame: CGRect(x: 20, y: 95+_nameField.frame.height + nameLabel.frame.height + descriptionLabel.frame.height + _descriptionField.frame.height, width: frame.width-40, height: 200))
        imageView.image = _section.image
        
        let imageButton = UIButton(frame: CGRect(x: 10, y: frame.height-110, width: frame.width-20, height: 50))
        imageButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        imageButton.backgroundColor = UIColor.lightGrayColor()
        if(_image != nil) {
            imageButton.setTitle("Change Image", forState: UIControlState.Normal)
        }
        else {
            imageButton.setTitle("Add Image", forState: UIControlState.Normal)
        }
        
        let createButton = UIButton(frame: CGRect(x: 10, y: frame.height-55, width: frame.width-20, height: 50))
        createButton.setTitle("Create", forState: UIControlState.Normal)
        createButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        createButton.backgroundColor = UIColor.lightGrayColor()
        
        // Set up delegates
        imageButton.addTarget(self, action: "selectImage:", forControlEvents: UIControlEvents.TouchUpInside)
        createButton.addTarget(self, action: "addSection:", forControlEvents: UIControlEvents.TouchUpInside)
        
        addSubview(nameLabel)
        addSubview(_nameField)
        addSubview(descriptionLabel)
        addSubview(_descriptionField)
        addSubview(imageButton)
        addSubview(createButton)
        addSubview(imageView)
    }
    
    //Delegate
    func addSection(button: UIButton) {
        if(_nameField.text != nil) {
            _section.name = _nameField.text!
        }
        if(_descriptionField.text != nil) {
            _section.description = _descriptionField.text!
        }
        
        delegate?.addSection(_section)
    }
    
    func selectImage(button: UIButton) {
        if(_nameField.text != nil) {
            _section.name = _nameField.text!
        }
        if(_descriptionField.text != nil) {
            _section.description = _descriptionField.text!
        }
        
        immediateDelegate?.showImageController()
    }
}
