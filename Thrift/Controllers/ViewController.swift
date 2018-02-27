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
    var total = 0.0
    
    var vcContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var vcExpenses = [Expense]()
    
    @IBOutlet weak var foodChart: CircleProgressView!
    @IBOutlet weak var autoChart: CircleProgressView!
    @IBOutlet weak var utilitiesChart: CircleProgressView!
    @IBOutlet weak var clothingChart: CircleProgressView!
    @IBOutlet weak var leisureChart : CircleProgressView!
    @IBOutlet weak var miscChart: CircleProgressView!
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        loadExpenses()
        
        foodChart.setProgress(0.5, animated: true)
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
        pieChartUpdate()

    }
    
    func pieChartUpdate() {
        
        for expense in vcExpenses {
            switch expense.category {
            case "Food"?:
                food += expense.price
            case "Auto"?:
                auto += expense.price
            case "Utilities"?:
                utilities += expense.price
            case "Clothing"?:
                clothing += expense.price
            case "Leisure"?:
                leisure += expense.price
            case "Misc"?:
                misc += expense.price
            default:
                return
            }
        }
        
        // Computations
        total = food + auto + utilities + clothing + leisure + misc
        let foodOffset = total - food
        let autoOffset = total - auto
        let utilitiesOffset = total - utilities
        let clothingOffset = total - clothing
        let leisureOffset = total - leisure
        let miscOffset = total - misc
/*
        let foodEntry = PieChartDataEntry(value: Double(food), label: "Food")
        let foodEntry2 = PieChartDataEntry(value: Double(foodOffset), label: "")

        let foodDataSet = PieChartDataSet(values: [foodEntry, foodEntry2], label: "")
        foodDataSet.colors = [UIColor.blue, UIColor.white]
        foodDataSet.selectionShift = 0
        let foodData = PieChartData(dataSet: foodDataSet)
        foodChart.data = foodData
        foodChart.legend.enabled = false
        
        let autoEntry = PieChartDataEntry(value: Double(auto), label: "Auto")
        let autoEntry2 = PieChartDataEntry(value: Double(autoOffset), label: "")
        let autoDataSet = PieChartDataSet(values: [autoEntry, autoEntry2], label: "")
        autoDataSet.colors = [UIColor.blue, UIColor.white]
        autoDataSet.selectionShift = 0
        let autoData = PieChartData(dataSet: autoDataSet)
        autoChart.data = autoData
        autoChart.legend.enabled = false

        
        let utilitiesEntry = PieChartDataEntry(value: Double(utilities), label: "Utilities")
        let utilitiesEntry2 = PieChartDataEntry(value: Double(utilitiesOffset), label: "")
        let utilitiesDataSet = PieChartDataSet(values: [utilitiesEntry, utilitiesEntry2], label: "")
        utilitiesDataSet.colors = [UIColor.blue, UIColor.white]
        utilitiesDataSet.selectionShift = 0
        let utilitiesData = PieChartData(dataSet: utilitiesDataSet)
        utilitiesChart.data = utilitiesData
        utilitiesChart.legend.enabled = false
        
        let clothingEntry = PieChartDataEntry(value: Double(clothing), label: "Clothing")
        let clothingEntry2 = PieChartDataEntry(value: Double(clothingOffset), label: "")
        let clothingDataSet = PieChartDataSet(values: [clothingEntry, clothingEntry2], label: "")
        clothingDataSet.colors = [UIColor.blue, UIColor.white]
        clothingDataSet.selectionShift = 0
        let clothingData = PieChartData(dataSet: clothingDataSet)
        clothingChart.data = clothingData
        clothingChart.legend.enabled = false
        
        
        let leisureEntry = PieChartDataEntry(value: Double(leisure), label: "Leisure")
        let leisureEntry2 = PieChartDataEntry(value: Double(leisureOffset), label: "Leisure")
        let leisureDataSet = PieChartDataSet(values: [leisureEntry, leisureEntry2], label: "")
        leisureDataSet.colors = [UIColor.blue, UIColor.white]
        leisureDataSet.selectionShift = 0
        let leisureData = PieChartData(dataSet: leisureDataSet)
        leisureChart.data = leisureData
        leisureChart.legend.enabled = false
        
        let miscEntry = PieChartDataEntry(value: Double(misc), label: "Misc")
        let miscEntry2 = PieChartDataEntry(value: Double(miscOffset), label: "Misc")
        let miscDataSet = PieChartDataSet(values: [miscEntry, miscEntry2], label: "")
        miscDataSet.colors = [UIColor.blue, UIColor.white]
        miscDataSet.selectionShift = 0
        let miscData = PieChartData(dataSet: miscDataSet)
        miscChart.data = miscData
        miscChart.legend.enabled = false
        
        foodChart.chartDescription?.textColor = UIColor.white
        autoChart.chartDescription?.textColor = UIColor.white
        utilitiesChart.chartDescription?.textColor = UIColor.white
        clothingChart.chartDescription?.textColor = UIColor.white
        leisureChart.chartDescription?.textColor = UIColor.white
        miscChart.chartDescription?.textColor = UIColor.white
        
        
        //This must stay at end of function
        foodChart.notifyDataSetChanged()
        autoChart.notifyDataSetChanged()
        utilitiesChart.notifyDataSetChanged()
        clothingChart.notifyDataSetChanged()
        leisureChart.notifyDataSetChanged()
        miscChart.notifyDataSetChanged()
 */
    }

    
}

