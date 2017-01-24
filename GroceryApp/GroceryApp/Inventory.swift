//
//  Inventory.swift
//  GroceryApp
//
//  Created by Dusty Argyle on 4/9/16.
//  Copyright © 2016 Dusty Argyle. All rights reserved.
//

import Foundation

class Inventory {
    // - Singleton The singleton, there should only be one collection of games
    class var sharedInstance: Inventory {
        struct Static {
            static var instance: Inventory?
        }
        
        if (Static.instance == nil) {
            Static.instance = Inventory()
        }
        
        return Static.instance!
    }
    
    init() {
        //saveThings()      //uncomment to clear out saved data
        loadThings()
    }

    private var _sectionIdentifiers: [Int:String] = [:]
    private var _sections: [String:Section] = [:]
    private var _groceryListIdentifiers: [Int:String] = [:]
    private var _groceryList: [String:Item] = [:]
    
    // Accessors
    func getSectionWithIndex(sectionIndex: Int) -> Section? {
        let sectionName: String = _sectionIdentifiers[sectionIndex]!
        return getSectionWithName(sectionName)
    }
    
    func getSectionWithName(sectionName: String) -> Section {
        let section: Section = _sections[sectionName]!
        return section
    }
    
    func addSection(section: Section) -> Bool {
        if(_sections.keys.contains(section.name)) {
            return false
        }
        
        _sections[section.name] = section
        _sectionIdentifiers[_sections.count-1] = section.name
        return true
    }
    
    func removeSection(section: Section) -> Bool {
        return removeSection(section.name)
    }
    
    func removeSection(name: String) -> Bool {
        _sections.removeValueForKey(name)
        
        for key in _sectionIdentifiers.keys{
            if(_sectionIdentifiers[key] == name) {
                _sectionIdentifiers.removeValueForKey(key)
                _sections.removeValueForKey(name)
            }
        }
        
        let values = _sectionIdentifiers.values
        _sectionIdentifiers.removeAll()
        var index = 0
        for value in values {
            _sectionIdentifiers[index] = value
            index = index + 1
        }
        return true
    }
    
    var sectionsCount: Int {
        get {
            return _sections.keys.count
        }
    }
    
    var groceryListItemsCount: Int {
        get {
            return _groceryListIdentifiers.keys.count
        }
    }
    
    func addToGroceryList(item: Item) {
        if(!_groceryList.keys.contains(item.name)) {
            _groceryListIdentifiers[_groceryListIdentifiers.count] = item.name
            _groceryList[item.name] = item
        }
    }
    
    func removeFromGroceryList(item: Item) {
        for key in _groceryListIdentifiers.keys {
            if(_groceryListIdentifiers[key] == item.name) {
                _groceryListIdentifiers.removeValueForKey(key)
                _groceryList.removeValueForKey(item.name)
                break
            }
        }
        
        let values = _groceryListIdentifiers.values
        _groceryListIdentifiers.removeAll()
        var index = 0
        for value in values {
            _groceryListIdentifiers[index] = value
            index = index + 1
        }
    }
    
    func getItemFromGroceryList(groceryListIndex: Int) -> Item {
        let item: Item = _groceryList[_groceryListIdentifiers[groceryListIndex]!]!
        return item
    }
    
    func saveThings() {
        let file = "sections.txt"
        
        var text: String = "{ \"sections\": ["
        for section in _sections.values {
            text += section.getJSON()
            text += ", "
        }
        text = text.substringToIndex(text.endIndex.predecessor().predecessor())
        text += "] }"
        
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent(file);
            
            print(text)
            
            //writing
            do {
                try text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
            }
            catch {/* error handling here */}
        }
    }
    
    func loadThings() {
        let file = "sections.txt"
        
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent(file)
            
            //reading
            do {
                let fileContent = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
                if let data = fileContent.dataUsingEncoding(NSUTF8StringEncoding) {
                    do {
                        let json =  try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
                        let sectionsJSON: NSArray = NSArray(array: (json?["sections"])! as! [AnyObject])
                        for sectionJSON in sectionsJSON {
                            print(sectionJSON)
                            let section: Section = Section(section: sectionJSON as! NSDictionary)
                            _sections[section.name] = section
                            _sectionIdentifiers[_sectionIdentifiers.count] = section.name
                            
                            for item in section.groceryListItems() {
                                addToGroceryList(item)
                            }
                        }
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
            catch {/* error handling here */}
        }
    }
}
