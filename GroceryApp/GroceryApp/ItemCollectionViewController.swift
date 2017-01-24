//
//  SectionViewController.swift
//  GroceryApp
//
//  Created by Dusty Argyle on 4/9/16.
//  Copyright © 2016 Dusty Argyle. All rights reserved.
//

import UIKit

class ItemCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AddItemDelegate, GroceryListDelegate, DeleteItemDelegate, ModifyItemDelegate {
    private var _section: Section = Section()
    
    //View methods
    private var collectionView: UICollectionView!
    private var layout: UICollectionViewFlowLayout?
    private var modify: Bool = false
    private var oldIteme: String = ""
    //data    
    var delegate: GroceryListDelegate?
    var modifySectionDelegate: ModifySectionDelegate?
    var deleteSectionDelegate: DeleteSectionDelegate?
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout = UICollectionViewFlowLayout()
        layout!.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        layout!.itemSize = CGSize(width: self.view.frame.width/5, height: self.view.frame.height/5)
        
        //set up everything for the collection view self.view.frame
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-50), collectionViewLayout: layout!)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(ItemCell.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionView.self))
        
        collectionView.backgroundColor = UIColor(patternImage: _section.image)
        
        let addButton = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ItemCollectionViewController.clickAddItem(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        
        let groceryListButton = UIButton(frame: CGRect(x: 0, y: self.view.frame.height-50, width: self.view.frame.width/2, height: 50))
        groceryListButton.backgroundColor = UIColor.lightGrayColor()
        groceryListButton.setTitle("Grocery List", forState: UIControlState.Normal)
        groceryListButton.addTarget(self, action: "switchToGroceryListViewController:", forControlEvents: UIControlEvents.TouchUpInside)
        let scannerButton = UIButton(frame: CGRect(x: groceryListButton.frame.width, y: self.view.frame.height-50, width: self.view.frame.width/2, height: 50))
        scannerButton.backgroundColor = UIColor.lightGrayColor()
        scannerButton.setTitle("Scanner", forState: UIControlState.Normal)
        scannerButton.addTarget(self, action: "switchToScannerViewController", forControlEvents: UIControlEvents.TouchUpInside)
        let deleteButton = UIButton(frame: CGRect(x: 0, y: self.view.frame.height-100, width: self.view.frame.width/2, height: 50))
        deleteButton.backgroundColor = UIColor.lightGrayColor()
        deleteButton.setTitle("Delete", forState: UIControlState.Normal)
        deleteButton.addTarget(self, action: "deleteSection", forControlEvents: UIControlEvents.TouchUpInside)
        let modifyButton = UIButton(frame: CGRect(x: groceryListButton.frame.width, y: self.view.frame.height-100, width: self.view.frame.width/2, height: 50))
        modifyButton.backgroundColor = UIColor.lightGrayColor()
        modifyButton.setTitle("Modify", forState: UIControlState.Normal)
        modifyButton.addTarget(self, action: "modifySection", forControlEvents: UIControlEvents.TouchUpInside)
        

        self.title = "Items in \(section.name)"
        //add the collection view to the subview
        view.addSubview(collectionView)
        view.addSubview(groceryListButton)
        view.addSubview(scannerButton)
        view.addSubview(deleteButton)
        view.addSubview(modifyButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func switchToScannerViewController() {
        switchToScannerViewController(_section)
    }
    
    //UICollectionViewDataSource protocol
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return _section.itemsCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ItemCell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(UICollectionView.self), forIndexPath: indexPath) as! ItemCell
        
        let item = _section.getItemWithIndex(indexPath.item)
        
        cell.draw(item!)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let itemViewController: ItemViewController = ItemViewController()
        let item: Item = _section.getItemWithIndex(indexPath.item)!
        
        itemViewController.item = item
        itemViewController.title = item.name
        itemViewController.delegate = self
        itemViewController.deleteDelegate = self
        itemViewController.modifyDelegate = self
    
        navigationController?.pushViewController(itemViewController, animated: true)
    }
    
    //Accessors
    var section: Section {
        get { return _section }
        set {
            _section = newValue
        }
    }
    
    // Button Methods
    func clickAddItem(button: UIButton) {
        let newItemViewController: NewItemViewController = NewItemViewController()
        newItemViewController.delegate = self
        
        navigationController?.pushViewController(newItemViewController, animated: true)
    }
    
    // Delegate methods
    func addItem(item: Item) {
        if(modify) {
            _section.removeItem(oldIteme)
            _section.addItem(item)
            modify = false
            navigationController?.popViewControllerAnimated(true)
        }
        else if(_section.addItem(item)) {
            collectionView.reloadData()
            addToGroceryList(item)
            navigationController?.popViewControllerAnimated(true)
        }
        else {
            let alertController = UIAlertController(title: "Failed To Add Item", message: "There is already a item called \(item.name)", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func switchToGroceryListViewController(button: UIButton) {
        delegate?.switchToGroceryListViewController()
    }
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
        delegate?.switchToScannerViewController(self.section)
    }
    func deleteItem(item: Item) {
        section.removeItem(item)
        collectionView.reloadData()
        navigationController?.popViewControllerAnimated(true)
    }
    func modifyItem(item: Item) {
        navigationController?.popViewControllerAnimated(true)
        let newItemViewController: NewItemViewController = NewItemViewController()
        newItemViewController.item = item
        newItemViewController.delegate = self
        modify = true
        oldIteme = item.name
        
        navigationController?.pushViewController(newItemViewController, animated: true)
    }
    func deleteSection() {
        deleteSectionDelegate?.deleteSection(_section)
    }
    func modifySection() {
        modifySectionDelegate?.modifySection(_section)
    }
}
