//
//  TextPicker.swift
//  ToDoList
//
//  Created by Alexandr Filovets on 28.09.23.
//

import UIKit
 
class TextPicker {
    func showPicker(in viewController: UIViewController, completion: @escaping ((String) -> Void)) {
        let alertController = UIAlertController(title: "Enter the name of the task ", message: nil, preferredStyle: .alert)
        
        alertController.addTextField()
        
        let actionOk = UIAlertAction(title: "Ok", style: .default) { _ in
            if let text = alertController.textFields?[0].text, text != "" { completion(text)
}
        }
         
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(actionOk)
        alertController.addAction(actionCancel)
        
        viewController.present(alertController, animated: true)
    }
}
