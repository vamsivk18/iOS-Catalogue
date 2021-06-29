//
//  CategoryViewController.swift
//  Todolist
//
//  Created by Vamsi Krishna on 22/03/21.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeViewController {
    let realm = try! Realm()
    
    
    var category : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        loadItems()
        tableView.rowHeight = 80
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       navigationController?.navigationBar.backgroundColor = UIColor(hexString: "1D9BF6")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.count ?? 1
    }
    
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
    //        cell.delegate = self
    //        return cell
    //    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView,cellForRowAt: indexPath)
        cell.backgroundColor = UIColor(hexString: (category?[indexPath.row].color)!) ?? UIColor.white
        cell.textLabel?.text = category?[indexPath.row].name ?? "No categories added"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        let indexPath = tableView.indexPathForSelectedRow
        destinationVC.itemCategory = category?[indexPath!.row]
    }
    
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        var newCategory = UITextField()
        let alert = UIAlertController(title: "Enter New Category", message: "", preferredStyle: .alert)
        alert.addTextField { (category) in
            category.autocapitalizationType = .sentences
            category.placeholder = "Category"
            newCategory = category
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            print("Category cancelled")
        }
        let addCategory = UIAlertAction(title: "Add Category", style: .default) { (addCat) in
            let addCategory = Category()
            addCategory.name = newCategory.text!
            addCategory.color = UIColor.randomFlat().hexValue()
            self.saveItems(category:addCategory)
        }
        alert.addAction(cancel)
        alert.addAction(addCategory)
        present(alert, animated: true) {
        }
    }
    
    
    func allowMultipleLines(_ cell:UITableViewCell){
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
    }
    
    func saveItems(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving data \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(){
        category = realm.objects(Category.self)
    }
    
    override func updateModel(at indexPath: IndexPath) {
        do{
            try self.realm.write{
                self.realm.delete((self.category?[indexPath.row])!)
            }
        } catch {
            print("Cannot delete")
        }
    }
}
