//
//  Delegates.swift
//  GroceryApp
//
//  Created by Dusty Argyle on 4/19/16.
//  Copyright © 2016 Dusty Argyle. All rights reserved.
//

import Foundation

protocol GroceryListDelegate {
    func addToGroceryList(item: Item)
    func removeFromGroceryList(item: Item)
    func switchToGroceryListViewController()
    func switchToScannerViewController(section: Section)
}

protocol PhotoPickerDelegate {
    func showImageController()
}

protocol AddItemDelegate {
    func addItem(item: Item)
}

protocol AddSectionDelegate {
    func addSection(section: Section)
}

protocol AddItemFromScannerDelegate {
    func addItemFromScanner(item: Item, section: Section)
}
protocol DeleteSectionDelegate {
    func deleteSection(section: Section)
}
protocol ModifySectionDelegate {
    func modifySection(section: Section)
}
protocol DeleteItemDelegate {
    func deleteItem(item: Item)
}
protocol ModifyItemDelegate {
    func modifyItem(item: Item)
}