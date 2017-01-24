//
//  ViewController.swift
//  GroceryApp
//
//  Created by Dusty Argyle on 4/7/16.
//  Copyright © 2016 Dusty Argyle. All rights reserved.
//

import UIKit

class GroceryListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, GroceryListDelegate {
    
    //declare the necessary components for the collection view
    private var collectionView: UICollectionView!
    private var layout: UICollectionViewFlowLayout?
    
    //data
    private var _inventory: Inventory?
    
    var delegate: GroceryListDelegate?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        collectionView.setNeedsDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout = UICollectionViewFlowLayout()
        layout!.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        layout!.itemSize = CGSize(width: self.view.frame.width/5, height: self.view.frame.height/5)
        
        //set up everything for the collection view
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout!)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(ItemCell.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionView.self))
        
        collectionView.backgroundColor = UIColor.blackColor()
        self.title = "Your Grocery List"
        
        //add the collection view to the subview
        view.addSubview(collectionView)
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
        return _inventory!.groceryListItemsCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ItemCell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(UICollectionView.self), forIndexPath: indexPath) as! ItemCell
        
        let item = _inventory!.getItemFromGroceryList(indexPath.item)
        
        cell.draw(item)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let itemViewController: ItemViewController = ItemViewController()
        itemViewController.delegate = self
        
        itemViewController.isInGroceryList = true
        itemViewController.item = (_inventory?.getItemFromGroceryList(indexPath.item))!
        navigationController?.pushViewController(itemViewController, animated: true)
    }
    
    // Button Methods
    
    //Delegate methods
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
        delegate?.switchToScannerViewController(section)
    }
    
    //Accessors
    var inventory: Inventory {
        get {
            return _inventory!
        }
        set {
            _inventory = newValue
            //collectionView.setNeedsDisplay()
        }
    }
}

