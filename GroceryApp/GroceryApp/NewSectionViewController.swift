//
//  NewSectionViewController.swift
//  GroceryApp
//
//  Created by Dusty Argyle on 4/9/16.
//  Copyright © 2016 Dusty Argyle. All rights reserved.
//

import UIKit

class NewSectionViewController: UIViewController, AddSectionDelegate, PhotoPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var delegate: AddSectionDelegate?
    var newSectionView: NewSectionView {
        return view as! NewSectionView
    }
    
    //private vars
    private var _section: Section = Section()
    
    //View methods
    override func loadView() {
        super.loadView()
        
        view = NewSectionView()
        self.title = "New Section"
        newSectionView.delegate = self
        newSectionView.immediateDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Accessors
    var section: Section {
        get { return _section }
        set {
            _section = newValue
            newSectionView.section = newValue
        }
    }
    
    //Delegate methods
    func addSection(section: Section) {
        delegate?.addSection(section)
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
        newSectionView.image = image
        newSectionView.setNeedsDisplay()
        newSectionView.setNeedsLayout()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
