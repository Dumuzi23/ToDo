//
//  CategoryViewController.swift
//  toDo
//
//  Created by Tatsuya Amida on 2020/08/02.
//  Copyright © 2020 T.A. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = [Category]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    //MARK: - TableView Datasource Methods

    // 行数を指定するメソッド（必須）
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    // セルを作成し、tableViewに返すメソッド（必須）
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .default, reuseIdentifier: "CategoryCell")

        let category = categories[indexPath.row]

        cell.textLabel?.text = category.name

        return cell
    }

    //MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }

    //MARK: - Data Manipulation Methods

    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving category, \(error)")
        }

        self.tableView.reloadData()
    }

    func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()

        do {
            categories = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }

        tableView.reloadData()
    }

    //MARK: - Add New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // AlertのAdd Categoryボタンを押した時の動作
            let newCategory = Category(context: self.context)

            // textFieldのtextプロパティがnilになることは無いので、forced unwrapして良い
            newCategory.name = textField.text!

            self.categories.append(newCategory)

            self.saveCategories()
        }
        
        // Alertにテキストフィールドを追加
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new Category"
            textField = alertTextField
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

}
