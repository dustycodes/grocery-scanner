//
//  ViewController.swift
//  GroceryApp
//
//  Created by Dusty Argyle on 4/7/16.
//  Copyright © 2016 Dusty Argyle. All rights reserved.
//

import UIKit

class SectionCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, AddSectionDelegate, GroceryListDelegate, AddItemFromScannerDelegate, DeleteSectionDelegate, ModifySectionDelegate {
    
    //declare the necessary components for the collection view
    private var collectionView: UICollectionView!
    private var layout: UICollectionViewFlowLayout?
    private var modify: Bool = false
    private var oldName: String = ""
    
    //data
    private var _inventory: Inventory = Inventory()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        _inventory.saveThings()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout = UICollectionViewFlowLayout()
        layout!.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        layout!.itemSize = CGSize(width: self.view.frame.width/5, height: self.view.frame.height/5)
        
        //set up everything for the collection view
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-50), collectionViewLayout: layout!)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(SectionCell.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionView.self))
        
        let groceryListButton = UIButton(frame: CGRect(x: 0, y: self.view.frame.height-50, width: self.view.frame.width/2, height: 50))
        groceryListButton.backgroundColor = UIColor.lightGrayColor()
        groceryListButton.setTitle("Grocery List", forState: UIControlState.Normal)
        groceryListButton.addTarget(self, action: "switchToGroceryListViewController", forControlEvents: UIControlEvents.TouchUpInside)
        
        collectionView.backgroundColor = UIColor.blackColor()
        self.title = "Sections"
        
        let addButton = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: "clickAddSection:")
        self.navigationItem.rightBarButtonItem = addButton
        
        //add the collection view to the subview
        view.addSubview(collectionView)
        view.addSubview(groceryListButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //UICollectionViewDataSource protocol
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return _inventory.sectionsCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: SectionCell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(UICollectionView.self), forIndexPath: indexPath) as! SectionCell

        let section = _inventory.getSectionWithIndex(indexPath.item)
        
        cell.draw(section!)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let itemCollectionViewController: ItemCollectionViewController = ItemCollectionViewController()
        let section: Section = _inventory.getSectionWithIndex(indexPath.item)!
        
        itemCollectionViewController.section = section
        itemCollectionViewController.delegate = self
        itemCollectionViewController.deleteSectionDelegate = self
        itemCollectionViewController.modifySectionDelegate = self
        navigationController?.pushViewController(itemCollectionViewController, animated: true)
    }

    // Button Methods
    func clickAddSection(button: UIButton) {
        let newSectionViewController: NewSectionViewController = NewSectionViewController()
        newSectionViewController.delegate = self
        
        navigationController?.pushViewController(newSectionViewController, animated: true)
    }
    
    //Delegate methods
    func addSection(section: Section) {
        if(modify) {
            _inventory.removeSection(oldName)
            _inventory.addSection(section)
            modify = false
            navigationController?.popViewControllerAnimated(true)
        }
        else if(_inventory.addSection(section)) {
            collectionView.reloadData()
            _inventory.saveThings()
            navigationController?.popToRootViewControllerAnimated(true)
        }
        else {
            let alertController = UIAlertController(title: "Failed To Add Section", message: "There is already a section called \(section.name)", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func addToGroceryList(item: Item) {
        _inventory.addToGroceryList(item)
    }
    
    func removeFromGroceryList(item: Item) {
        _inventory.removeFromGroceryList(item)
    }
    
    func switchToGroceryListViewController() {
        navigationController?.popToRootViewControllerAnimated(true)
        
        let groceryListViewController: GroceryListViewController = GroceryListViewController()
        groceryListViewController.delegate = self
        groceryListViewController.inventory = _inventory
        navigationController?.pushViewController(groceryListViewController, animated: true)
    }
    
    func switchToScannerViewController(section: Section) {
        navigationController?.popToRootViewControllerAnimated(true)
        
        let scannerViewController: ScannerViewController = ScannerViewController()
        scannerViewController.delegate = self
        scannerViewController.section = section
        navigationController?.pushViewController(scannerViewController, animated: true)
    }

    
    func addItemFromScanner(item: Item, section: Section) {
        let itemCollectionViewController: ItemCollectionViewController = ItemCollectionViewController()
        
        itemCollectionViewController.section = section
        itemCollectionViewController.delegate = self
        navigationController?.pushViewController(itemCollectionViewController, animated: true)
        
        let newItemViewController: NewItemViewController = NewItemViewController()
        newItemViewController.delegate = itemCollectionViewController
        newItemViewController.item = item
        
        navigationController?.pushViewController(newItemViewController, animated: true)
    }
    
    func modifySection(section: Section) {
        navigationController?.popViewControllerAnimated(true)
        let newSectionViewController: NewSectionViewController = NewSectionViewController()
        newSectionViewController.section = section
        newSectionViewController.delegate = self
        modify = true
        oldName = section.name
        
        navigationController?.pushViewController(newSectionViewController, animated: true)
    }
    func deleteSection(section: Section) {
        _inventory.removeSection(section.name)
        collectionView.reloadData()
        navigationController?.popViewControllerAnimated(true)
    }
}

