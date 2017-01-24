//
//  NewItemViewController.swift
//  GroceryApp
//
//  Created by Dusty Argyle on 4/9/16.
//  Copyright © 2016 Dusty Argyle. All rights reserved.
//

import UIKit

class NewItemViewController: UIViewController, AddItemDelegate, PhotoPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var delegate: AddItemDelegate?
    var newItemView: NewItemView {
        return view as! NewItemView
    }
    
    //private vars
    private var _item: Item = Item()
    
    //View methods
    override func loadView() {
        super.loadView()
        
        view = NewItemView()
        newItemView.delegate = self
        newItemView.immediateDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Accessors
    var item: Item {
        get { return _item }
        set {
            _item = newValue
            newItemView.item = newValue
        }
    }
    
    //Delegate methods
    func addItem(item: Item) {
        delegate?.addItem(item)
    }
    
    func showImageController() {
        let imagePickerController: UIImagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var image: UIImage
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            image = possibleImage
        }
        else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            image = possibleImage
        }
        else {
            return
        }
        
        //we have the image in image
        newItemView.image = image
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}