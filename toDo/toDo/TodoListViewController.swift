//
//  ViewController.swift
//  toDo
//
//  Created by Tatsuya Amida on 2020/07/21.
//  Copyright © 2020 T.A. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        loadItems()

    }

    //MARK: Tableview Datasource Methods

    // 行数を指定するメソッド（必須）
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    // セルを作成し、tableViewに返すメソッド（必須）
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")

        let item = itemArray[indexPath.row]

        cell.textLabel?.text = item.title

        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }

    //MARK: Tableview Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // 選択したセルがチェックされていればチェックを外す。チェックされていなければチェックする。
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        saveItems()

        // セルが選択された後、選択状態が解除されるようにする
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: 新しいタスクの追加

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Today Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // AlertのAdd Itemボタンを押した時の動作
            let newItem = Item(context: self.context)
            
            // textFieldのtextプロパティがnilになることは無いので、forced unwrapして良い
            newItem.title = textField.text!
            newItem.done = false

            self.itemArray.append(newItem)

            self.saveItems()
        }

        // Alertにテキストフィールドを追加
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

    //MARK: Model Manupulation Methods

    func saveItems() {

        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }

        self.tableView.reloadData()
    }

    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }

}

