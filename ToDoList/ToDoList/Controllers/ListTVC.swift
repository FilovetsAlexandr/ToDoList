//
//  ListTVC.swift
//  ToDoList
//
//  Created by Alexandr Filovets on 28.09.23.
//

import UIKit

final class ListTVC: UITableViewController {
    
    private var model = Model()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        loadImageAsync()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        DispatchQueue.main.asyncAfter(deadline:.now() + 0.5, execute: { self.animate() })
    }
    private func loadImageAsync() {
        DispatchQueue.global().async {
            if let image = UIImage(named: "logo") {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
    private func animate() {
        UIView.animate(withDuration: 1, animations: {
            let size = self.view.frame.size.width * 3
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            self.imageView.frame = CGRect(
                x: -(diffX/2),
                y: diffY/2,
                width: size,
                height: size
            )
        })
        UIView.animate(withDuration: 1.5, animations: {
            self.imageView.alpha = 0
        })
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

        // Изменение альфа-значения ячейки в зависимости от состояния галочки
        let alphaValue: CGFloat = model.items[indexPath.row].isCompleted ? 0.2 : 1.0
            cell.textLabel?.alpha = alphaValue
            cell.detailTextLabel?.alpha = alphaValue
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
