//
//  ViewController.swift
//  Thrift
//
//  Created by Jervin Cruz on 2/20/18.
//  Copyright © 2018 Jervin Cruz. All rights reserved.
//

import UIKit
import CoreData
import CircleProgressView

class ViewController: UIViewController {

    var food = 0.0
    var auto = 0.0
    var utilities = 0.0
    var clothing = 0.0
    var leisure = 0.0
    var misc = 0.0
    var totalCost = 0.0
    var total = 0.0 {
        didSet{
            display()
        }
    }
    
    var vcContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var vcExpenses = [Expense]()
    
    @IBOutlet weak var foodChart: CircleProgressView!
    @IBOutlet weak var autoChart: CircleProgressView!
    @IBOutlet weak var utilitiesChart: CircleProgressView!
    @IBOutlet weak var clothingChart: CircleProgressView!
    @IBOutlet weak var leisureChart : CircleProgressView!
    @IBOutlet weak var miscChart: CircleProgressView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        loadExpenses()
        calculateExpenses()        
    }

    func loadExpenses(with request : NSFetchRequest<Expense> = Expense.fetchRequest()){
        do {
            vcExpenses = try vcContext.fetch(request)
            for expense in vcExpenses {
                print("Name: ", expense.name!)
                print("Price: ", expense.price)
                print("Category: ", expense.category!)
            }
        } catch {
            print("Error fetching data from context \(error)")
        }

    }
    
    func display(){
        self.totalPriceLabel.text! = "$ \(self.totalCost)"
        DispatchQueue.main.async{
            self.foodChart.setProgress(self.food/self.total, animated: true)
            self.autoChart.setProgress(self.auto/self.total, animated: true)
            self.utilitiesChart.setProgress(self.utilities/self.total, animated: true)
            self.clothingChart.setProgress(self.clothing/self.total, animated: true)
            self.leisureChart.setProgress(self.leisure/self.total, animated: true)
            self.miscChart.setProgress(self.utilities/self.total, animated: true)
        }
    }
 
    func calculateExpenses(){
        var foodExpenses = 0.0
        var autoExpenses = 0.0
        var utilitiesExpenses = 0.0
        var clothingExpenses = 0.0
        var leisureExpenses = 0.0
        var miscExpenses = 0.0
        
        for expense in vcExpenses {
            switch expense.category {
            case "Food"?:
                food += 1
                foodExpenses += expense.price
            case "Auto"?:
                auto += 1
                autoExpenses += expense.price
            case "Utilities"?:
                utilities += 1
                utilitiesExpenses += expense.price
            case "Clothing"?:
                clothing += 1
                clothingExpenses += expense.price
            case "Leisure"?:
                leisure += 1
                leisureExpenses += expense.price
            case "Misc"?:
                misc += 1
                miscExpenses += expense.price
            default:
                return
            }
        }
        totalCost = foodExpenses + autoExpenses + utilitiesExpenses + clothingExpenses + leisureExpenses + miscExpenses
        
        total = food + auto + utilities + clothing + leisure + misc
        print("Total:", total)
        print("Food: \(food) Auto: \(auto) Utilities: \(utilities) Clothing: \(clothing) Leisure: \(leisure) Misc: \(misc)")
        
    }

    
}
