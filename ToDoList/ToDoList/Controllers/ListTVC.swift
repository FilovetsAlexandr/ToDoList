//
//  ListTVC.swift
//  ToDoList
//
//  Created by Alexandr Filovets on 28.09.23.
//

import UIKit

class ListTVC: UITableViewController {
    var model = Model()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func pushAddAction(_ sender: Any) {
        TextPicker().showPicker(in: self) { [weak self] text in
            self?.model.addItem(title: text)
            self?.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { model.items.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")

        cell.textLabel?.text = model.items[indexPath.row].title

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short

        let formattedDate = "Created by: " + dateFormatter.string(from: model.items[indexPath.row].date)
        cell.detailTextLabel?.text = formattedDate

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.image = model.items[indexPath.row].isCompleted ? UIImage(named: "check.png") : UIImage(named: "uncheck.png")

        cell.accessoryView = imageView

        return cell
    }

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Rename") { _, _, completion in
            TextPicker().showPicker(in: self) { [weak self] text in

                self?.model.renameItem(atIndex: indexPath.row, newTitle: text)
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                completion(true)
            }
        }

        return UISwipeActionsConfiguration(actions: [action])
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in

            self.model.deleteItem(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.toogleItem(atIndex: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
