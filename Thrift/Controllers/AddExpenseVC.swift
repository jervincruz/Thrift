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

class AddExpenseVC : UIViewController {
    
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
    var selectedDate : String?
    var selectedPrice : String = ""
    
    // Core Data Properties
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var expenses = [Expense]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // [Navigation Bar] -> Add Expense Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addExpense))
                
        // Make Rounded Buttons
        for button in priceButtons {
            makeButtonRound(button)
        }
    }

    @objc func addExpense(){
        // Error handling when no category, name, price, input
        let alertController = UIAlertController(title: "Incomplete", message: "Missing Required Fields!", preferredStyle: .alert)
        let when = DispatchTime.now() + 1.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            alertController.dismiss(animated: true, completion: nil)
        }
        guard let name = nameTextField.text else {
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
            print("Error saving context \(error)")
        }
    }
    
    func loadExpenses(with request : NSFetchRequest<Expense> = Expense.fetchRequest()){
        do{
            expenses = try context.fetch(request)
            for expense in expenses{
                let name = expense.name!
                let category = expense.category!
                let price = expense.price
            }
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    @IBAction func priceButtonPressed(_ sender: UIButton) {
        let decimal : Character = "."
        
        if let index = selectedPrice.index(of: decimal) {
            let pos = selectedPrice.distance(from: selectedPrice.endIndex, to: index)
            if pos == -3 && sender.tag != 11 {
                return
            }
        }

        switch sender.tag {
        case 0:
            selectedPrice += "0"
            showPriceLabel()
        case 1:
            selectedPrice += "1"
            showPriceLabel()
        case 2:
            selectedPrice += "2"
            showPriceLabel()
        case 3:
            selectedPrice += "3"
            showPriceLabel()
        case 4:
            selectedPrice += "4"
            showPriceLabel()
        case 5:
            selectedPrice += "5"
            showPriceLabel()
        case 6:
            selectedPrice += "6"
            showPriceLabel()
        case 7:
            selectedPrice += "7"
            showPriceLabel()
        case 8:
            selectedPrice += "8"
            showPriceLabel()
        case 9:
            selectedPrice += "9"
            showPriceLabel()
        case 10:
            if selectedPrice.contains("."){
                return
            } else { selectedPrice += "." }
            showPriceLabel()
        case 11:
            if selectedPrice.count > 0 {
                selectedPrice = String(selectedPrice.dropLast())
            }
            showPriceLabel()
        default:
            return
        }
    }
    
    func showPriceLabel(){
        DispatchQueue.main.async{
            self.priceLabel.text! = "$ " + self.selectedPrice
        }
    }
    
    func makeButtonRound(_ myBtn : UIButton){
        myBtn.layer.cornerRadius = myBtn.frame.width / 2
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
    
}
