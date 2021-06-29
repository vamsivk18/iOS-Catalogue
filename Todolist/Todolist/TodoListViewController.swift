//
//  ViewController.swift
//  Todolist
//
//  Created by Vamsi Krishna on 18/03/21.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeViewController,UISearchBarDelegate {
    let realm = try! Realm()
    @IBOutlet weak var searchBar: UISearchBar!
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    var todoItems : Results<Item>?
    var itemCategory : Category? {
        didSet{
            loadItems()
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        tableView.separatorStyle = .none
        searchBar.delegate = self
        tableView.rowHeight = 80
        super.viewDidLoad()
        print(dataFilePath)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "\(itemCategory?.name ?? "Items")"
        navigationController?.navigationBar.backgroundColor = UIColor(hexString : itemCategory!.color)
        searchBar.barTintColor = UIColor(hexString : itemCategory!.color)
        searchBar.setTextField(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        navigationController?.navigationBar.tintColor = ContrastColorOf(UIColor(hexString : itemCategory!.color)!, returnFlat: true)
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt : indexPath)
        let color = UIColor(hexString: itemCategory!.color)!.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count))
        cell.backgroundColor = color
        cell.textLabel?.textColor = ContrastColorOf(color!, returnFlat: true)
        cell.textLabel?.text = todoItems?[indexPath.row].title ?? "No Item added in this Category"
        cell.accessoryType = todoItems?[indexPath.row].done ?? false ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write{
                    item.done = !item.done
                }
            }catch {
                print("Error saving done status")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        var newItem = UITextField()
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        alert.addTextField { (message) in
            message.placeholder = "Add New ToDo Item"
            message.autocapitalizationType = .sentences
            newItem = message
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) in
            print("Cancelled")
        }
        let addItem = UIAlertAction(title: "Add Item", style: .default) { (_) in
            if let newCategory = self.itemCategory{
                if newItem.text == ""{
                    newItem.placeholder = "Enter Something"
                }
                else{
                do{
                    try self.realm.write {
                        let addItem = Item()
                        addItem.title = newItem.text!
                        addItem.date = Date()
                        newCategory.items.append(addItem)
                    }
                } catch {
                    print("Saving failed")
                }
                self.tableView.reloadData()
                }
            }
        }
        alert.addAction(cancel)
        alert.addAction(addItem)
        present(alert, animated: true) {
        }
    }
    
    func loadItems(){
        todoItems = itemCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }

    
    
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
            if searchBar.text?.count == 0 {
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
                loadItems()
                tableView.reloadData()
            }
                tableView.reloadData()
        }
    
    override func updateModel(at indexPath: IndexPath) {
        do{
            try self.realm.write{
                self.realm.delete((self.todoItems?[indexPath.row])!)
            }
        } catch {
            print("Cannot delete")
        }
    }
    
}

extension UISearchBar {
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    func setTextField(color: UIColor) {
        guard let textField = getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default: textField.backgroundColor = color
        @unknown default: break
        }
    }
}

