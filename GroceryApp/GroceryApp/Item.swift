//
//  Item.swift
//  GroceryApp
//
//  Created by Dusty Argyle on 4/9/16.
//  Copyright © 2016 Dusty Argyle. All rights reserved.
//

import Foundation
import UIKit

class Item {
    private var _name: String = ""
    private var _description: String = ""
    private var _image: UIImage = UIImage()
    private var _quantity: Int = 0
    private var _price: Float = 0.0
    
    init() {
        
    }
    
    init(name: String, description: String, image: UIImage) {
        _name = name
        _description = description
        _image = image
    }
    
    init(item: NSDictionary) {
        _name = (item["name"] as! NSString) as String
        _description = (item["description"] as! NSString) as String
        _quantity = (item["quantity"] as! NSInteger)
        
        loadImage()
    }
    
    // Accessors
    var name: String {
        get  { return _name }
        set {
            _name = newValue
        }
    }
    var description: String {
        get  { return _description }
        set {
            _description = newValue
        }
    }
    var image: UIImage {
        get { return _image }
        set {
            _image = newValue
        }
    }
    var quantity: Int {
        get { return _quantity }
        set {
            _quantity = newValue
        }
    }
    var price: Float {
        get { return _price }
        set {
            _price = newValue
        }
    }
    
    func getJSON() -> String {
        let json: String = "{ \"name\": \"\(_name)\", \"description\": \"\(_description)\", \"quantity\": \(_quantity), \"price\": \(_price)}"
        
        saveImage()
        return json
    }
    
    func saveImage() {
        if let data = UIImagePNGRepresentation(_image) {
            let filename = getDocumentsDirectory().stringByAppendingPathComponent("\(_name)-item.png")
            data.writeToFile(filename, atomically: true)
        }
    }
    
    func loadImage() {
        let filename = getDocumentsDirectory().stringByAppendingPathComponent("\(_name)-item.png")
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(filename) {
            _image = UIImage(contentsOfFile: filename)!
        }
        else  {
            _image = UIImage()
        }
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}