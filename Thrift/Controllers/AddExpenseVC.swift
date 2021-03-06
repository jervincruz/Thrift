//
//  SampleViewController.swift
//  Thrift
//
//  Created by Jervin Cruz on 3/6/18.
//  Copyright © 2018 Jervin Cruz. All rights reserved.
//

import UIKit
import CoreData
import HexColors

class AddExpenseVC : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nineButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var decimalButton: UIButton!
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet var priceButtons: [UIButton]!
    @IBOutlet var categoryButtons: [UIButton]!
    @IBOutlet weak var nameTextField: UITextField!
    
    var selectedCategory : String?
    var selectedName : String?
    var selectedDate : String?
    var selectedPrice : String = ""
    
    // Core Data Properties
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var expenses = [Expense]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        for button in priceButtons {
            button.layer.cornerRadius = button.frame.width / 2 // Make Circle Buttons
        }
        self.nameTextField.autocapitalizationType = .words
        self.hideKeyboard()
    }

    @IBAction func addExpense(){
        // Error handling when no category, name, price, input
        let alertController = UIAlertController(title: "Incomplete", message: "Missing Required Fields!", preferredStyle: .alert)
        let when = DispatchTime.now() + 1.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            alertController.dismiss(animated: true, completion: nil)
        }
        guard let name = nameTextField.text, !name.isEmpty, name.count < 100 else {
            self.present(alertController, animated: true, completion: nil)
            return
        }
        guard let category = selectedCategory else {
            self.present(alertController, animated: true, completion: nil)
            return
        }

        guard let date = selectedDate else {
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard selectedPrice.rangeOfCharacter(from: NSCharacterSet.decimalDigits) != nil else {
            self.present(alertController, animated: true, completion: nil)
            return
        }

        // Create Expense & Assign Properties
        let expense = Expense(context: context)
        expense.name = name
        expense.category = category
        expense.date = date
        expense.price = Double(selectedPrice)!
        expenses.append(expense)
        
        loadExpenses()
        saveExpense()
        navigationController?.popViewController(animated: true)
    }
    
    func saveExpense(){
        do {
            try context.save()
        } catch {
            fatalError("Error saving expenses \(error)")
        }
    }
    
    func loadExpenses(with request : NSFetchRequest<Expense> = Expense.fetchRequest()){
        do{
            expenses = try context.fetch(request)
        } catch {
            fatalError("Error fetching expenses \(error)")
        }
    }
    
    @IBAction func priceButtonPressed(_ sender: UIButton) {
        let decimal : Character = "."
        // Protects prices exceeding 2 decimal places
        if let index = selectedPrice.index(of: decimal) {
            let pos = selectedPrice.distance(from: selectedPrice.endIndex, to: index)
            if pos == -3 && sender.tag != 11 {
                return
            }
        }
        // Protects infinite numbers (Max: 18 Digits)
        if selectedPrice.count >= 18 && sender.tag != 11 {
            return
        }

        switch sender.tag {
        case 0:
            selectedPrice += "0"
        case 1:
            selectedPrice += "1"
        case 2:
            selectedPrice += "2"
        case 3:
            selectedPrice += "3"
        case 4:
            selectedPrice += "4"
        case 5:
            selectedPrice += "5"
        case 6:
            selectedPrice += "6"
        case 7:
            selectedPrice += "7"
        case 8:
            selectedPrice += "8"
        case 9:
            selectedPrice += "9"
        case 10:
            if selectedPrice.contains("."){
                return
            } else { selectedPrice += "." }
        case 11:
            if selectedPrice.count > 0 {
                selectedPrice = String(selectedPrice.dropLast())
            }
        default:
            return
        }
        DispatchQueue.main.async{
            self.priceLabel.text! = "$ " + self.selectedPrice
        }
    }
    
    @IBAction func categoryPressed(category: UIButton){
        switch category.tag {
        case 0:
            resetButtonSelection(category)
            selectedCategory = "Food"
        case 1:
            resetButtonSelection(category)
            selectedCategory = "Auto"
        case 2:
            resetButtonSelection(category)
            selectedCategory = "Utilities"
        case 3:
            resetButtonSelection(category)
            selectedCategory = "Clothing"
        case 4:
            resetButtonSelection(category)
            selectedCategory = "Leisure"
        case 5:
            resetButtonSelection(category)
            selectedCategory = "Misc"
        default:
            break
        }
    }
    
    func resetButtonSelection(_ category : UIButton){
        for button in categoryButtons{
            button.backgroundColor = UIColor("CBE4D1")
        }
        category.backgroundColor = UIColor.white
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}

extension UIViewController {
    func hideKeyboard(){
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}
