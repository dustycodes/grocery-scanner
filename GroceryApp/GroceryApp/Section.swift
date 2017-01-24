//
//  Section.swift
//  GroceryApp
//
//  Created by Dusty Argyle on 4/10/16.
//  Copyright © 2016 Dusty Argyle. All rights reserved.
//

import Foundation
import UIKit

class Section {
    private var _name: String = ""
    private var _description: String = ""
    private var _items: [String:Item] = [:]
    private var _itemIdentifiers: [Int:String] = [:]
    private var _image: UIImage = UIImage()
    
    //Constructors
    init() {
        
    }
    
    init(name: String, description: String) {
        _name = name
        _description = description
    }
    
    init(name: String, description: String, image: UIImage) {
        _name = name
        _description = description
        _image = image
    }
    
    init(section: NSDictionary) {
        _name = (section["name"] as! NSString) as String
        _description = (section["description"] as! NSString) as String
        let itemsJSON = section["items"] as! NSArray
        for itemJSON in itemsJSON {
            let item: Item = Item(item: itemJSON as! NSDictionary)
            addItem(item)
        }
        
        loadImage()
    }
    
    // Accessors
    var name: String {
        get { return _name }
        set {
            _name = newValue
        }
    }
    var items: [String:Item] {
        get { return _items }
        set {
            _items = newValue
        }
    }
    var image: UIImage {
        get { return _image }
        set {
            _image = newValue
        }
    }
    var description: String {
        get { return _description }
        set {
            _description = newValue
        }
    }
    func getItemWithIndex(itemIndex: Int) -> Item? {
        let itemName: String = _itemIdentifiers[itemIndex]!
        return getItemWithName(itemName)
    }
    func getItemWithName(itemName: String) -> Item {
        let item: Item = _items[itemName]!
        return item
    }
    func addItem(item: Item) -> Bool {
        if(_items.keys.contains(item.name)) {
            return false
        }
        
        _items[item.name] = item
        _itemIdentifiers[_items.count - 1] = item.name
        return true
    }
    func removeItem(item: Item) -> Bool {
        return removeItem(item.name)
    }
    func removeItem(name: String) -> Bool {
        for key in _itemIdentifiers.keys{
            if(_itemIdentifiers[key] == name) {
                _itemIdentifiers.removeValueForKey(key)
                _items.removeValueForKey(name)
            }
        }
        
        let values = _itemIdentifiers.values
        _itemIdentifiers.removeAll()
        var index = 0
        for value in values {
            _itemIdentifiers[index] = value
            index = index + 1
        }
        
        return true
    }
    var itemsCount: Int {
        get {
            return _items.keys.count
        }
    }
    func containsItem(item: Item) -> Bool {
        return _items.keys.contains(item.name)
    }
    
    func getJSON() -> String {
        var json: String = "{\"name\": \"\(_name)\", \"description\": \"\(_description)\","
        json = "\(json) \"items\": ["
        
        for item in _items.values {
            json = "\(json) \(item.getJSON()), "
        }
        json = json.substringToIndex(json.endIndex.predecessor().predecessor())
        json = "\(json)]}"
        
        saveImage()
        return json
    }
    
    func saveImage() {
        if let data = UIImagePNGRepresentation(_image) {
            let filename = getDocumentsDirectory().stringByAppendingPathComponent("\(_name)-section.png")
            data.writeToFile(filename, atomically: true)
        }
    }
    
    func loadImage() {
        let filename = getDocumentsDirectory().stringByAppendingPathComponent("\(_name)-section.png")
        
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
    
    func groceryListItems() -> [Item] {
        var gli: [Item] = []
        for item in _items.values {
            if(item.quantity < 1) {
                gli.append(item)
            }
        }
        return gli
    }
}