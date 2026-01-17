//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Antonio Hernández Santander on 13/01/26.
//  Copyright © 2026 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let realm = try! Realm()
    // var categories = [Category]() // CORE DATA
    var categories: Results<Category>? //  REALM (deprecated!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].colorHex)
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC  = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            // let newCategory = Category(context: self.context) // CORE DATA
            let newCategory = Category() // REALM (deprecated!)
            newCategory.name  = textField.text!
            
            // self.categories.append(newCategory) // CORE DATA
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        alert.addTextField { field in
            textField = field
            field.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Data Manipulation Methods
    
    // REALM(deprecated) saveData()
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("ERROR: Failed to save data to context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    // CORE DATA loadData()//
    /* func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
     do {
     categories = try context.fetch(request)
     } catch {
     print("ERROR: Failed to load categories: \(error)")
     }
     tableView.reloadData()
     } */
    
    
    // REALM (deprecated!) loadData()
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    
    //MARK: - Delete Data
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
}
