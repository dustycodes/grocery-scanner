//
//  NewItemViewController.swift
//  GroceryApp
//
//  Created by Dusty Argyle on 4/9/16.
//  Copyright © 2016 Dusty Argyle. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController, GroceryListDelegate, DeleteItemDelegate, ModifyItemDelegate {
    var itemView: ItemView {
        return view as! ItemView
    }
    
    //private vars
    private var _item: Item = Item()
    
    //public vars
    var delegate: GroceryListDelegate?
    var deleteDelegate: DeleteItemDelegate?
    var modifyDelegate: ModifyItemDelegate?
    var isInGroceryList: Bool = false
    
    //View methods
    override func loadView() {
        super.loadView()
        view = ItemView()
        itemView.item = _item
        itemView.isInGroceryList = isInGroceryList
        self.title = _item.name
        itemView.delegate = self
        itemView.deleteDelegate = self
        itemView.modifyDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Accessors
    var item: Item {
        get { return _item }
        set {
            _item = newValue
        }
    }
    
    //Delegates
    func addToGroceryList(item: Item) {
        delegate?.addToGroceryList(item)
    }
    
    func removeFromGroceryList(item: Item) {
        delegate?.removeFromGroceryList(item)
    }
    
    func switchToGroceryListViewController() {
        delegate?.switchToGroceryListViewController()
    }
    
    func switchToScannerViewController(section: Section) {
        delegate?.switchToScannerViewController(section)
    }
    func deleteItem(item: Item) {
        deleteDelegate?.deleteItem(item)
    }
    func modifyItem(item: Item) {
        modifyDelegate?.modifyItem(item)
    }
}