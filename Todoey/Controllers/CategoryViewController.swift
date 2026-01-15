//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Antonio Hernández Santander on 13/01/26.
//  Copyright © 2026 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name 

        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC  = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            let newCategory = Category(context: self.context)
            newCategory.name  = textField.text!

            self.categories.append(newCategory)
            self.saveCategory()
        }

        alert.addAction(action)
        alert.addTextField { field in
            textField = field
            field.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Data Manipulation Methods
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("ERROR: Failed to save data to context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("ERROR: Failed to load categories: \(error)")
        }
        
        tableView.reloadData()
    }
}
