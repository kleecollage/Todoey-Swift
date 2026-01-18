//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let realm = try! Realm()
    // var itemArray = [Item]() // CORE DATA
    var todoItems: Results<Item>? // REALM(deprecated!)
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // print(dataFilePath!)
        // let newItem = Item(context: context)
        
        // Random data for init //
        /* newItem.title = "Find Mike"
        newItem.done = true
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy eggs"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy demogorgon"
        itemArray.append(newItem3) */
        
        // NSCode to encode and decode more specific data types //
        // loadItems()
        
        // USER defaults to percist data //
        /* if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        } */
    }
    
    
    //MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let darkValue = CGFloat(indexPath.row)/CGFloat(todoItems?.count ?? 1)
        // let bgColor = FlatOrangeDark().darken(byPercentage: darkValue)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            if let colour = UIColor(hexString: selectedCategory?.colorHex).darken(byPercentage: darkValue) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(backgroundColor: colour, returnFlat: true)
            }
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    // REALM(deprecated!)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    // realm.delete(item) // REALM delete
                    item.done = !item.done
                }
            } catch {
                print("ERROR: Faliled to save donde status, \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // CORE DATA
    /* override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        // item.setValue("Completed", forKey: "title") // UPDATE core data
        
        // context.delete(itemArray[indexPath.row]) // DELETE core data first!!
        // itemArray.remove(at: indexPath.row) // DELETE selected item
        
        item.done = !itemArray[indexPath.row]?.done
        
        saveItems() // Always save the context state either you are creating, uptading or deleting
        
        tableView.deselectRow(at: indexPath, animated: true)
    } */
    
    
    //MARK: - Add New Items
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            // REALM(deprecated!) saveData
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("ERROR: Saving new item, \(error)")
                }
            }
            self.tableView.reloadData()
            
            // CORE DATA
            /* let newItem = Item(context: self.context)
            let newItem = Item() // Realm
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems() */
        }

        alert.addAction(action)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }


    //MARK: - Model Manipulation Methods
    
    // CORE DATA/ENCODER saveData() //
    /* func saveItems() {
        // let encoder = PropertyListEncoder() // ENCODER
        do {
            // let data = try encoder.encode(self.itemArray) // ENCODER
            // try data.write(to: self.dataFilePath!) // ENCODER
            try context.save() // CORE DATA
        } catch {
            print("ERROR: \(error)")
        }
        
        tableView.reloadData()
     } */
    
    // REALM(deprecated!) loadData()//
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    // CORE DATA loadData() //
    /* func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        // let request: NSFetchRequest<Item> = Item.fetchRequest() // we pass this constant as default parameter
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("ERROR: Failed to fetching data from context: \(error)")
        }
        tableView.reloadData()
    } */
    
    // DECODE DATA loadData() //
    /* func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("ERROR: Failed to decode item: \(error)")
            }
        }
    } */
    
    // DELETE method
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("ERROR: Failed to delete item, \(error.localizedDescription)")
            }
        }
    }
}


//MARK: - Searchbar Delegate Methods

extension TodoListViewController: UISearchBarDelegate {
    
    // REALM(deprecated!)
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    // CORE DATA //
    /* func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // print(searchBar.text!)
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) // QUERY
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] // ORDER BY
        
        loadItems(with: request, predicate: predicate)
    } */
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // cursor and keyboard go away                
            }
        }
    }
    
    
}

