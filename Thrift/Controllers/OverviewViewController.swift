//
//  OverviewViewController.swift
//  Thrift
//
//  Created by Jervin Cruz on 2/26/18.
//  Copyright © 2018 Jervin Cruz. All rights reserved.
//

import UIKit
import Charts

class OverviewViewController : UIViewController {
    
    
    @IBOutlet weak var barChartView: BarChartView!
    var dataEntry : [BarChartDataEntry] = []
    
    var workoutDuration = [String]()
    var beatsPerMinute = [String]()

    
    override func viewDidLoad(){
        super.viewDidLoad()
        populateChartData()
        setBarChart(dataPoints: workoutDuration, values: beatsPerMinute)

        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dayOfWeek = calendar.component(.weekday, from: today)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
            .flatMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }  // use `compactMap` in Xcode 9.3 and later
        
        let formatter = DateFormatter()
        formatter.dateFormat = "eeee' = 'D"
        for date in days {
            //print(formatter.string(from: date))
        }
 
        
        /*
        let date = Date()
        let calendar = Calendar.current
        
        let day = calendar.component(.day, from: date)
        print(day)
        let weekday = calendar.component(.weekday, from: date)
        print(weekday)
 
         */
        
    }
    
    func populateChartData(){
        workoutDuration = ["Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun"]
        beatsPerMinute = ["76", "150", "160", "180", "195", "195", "180"]
    }
    
    func setBarChart(dataPoints: [String], values: [String]){
        // No data setup
        barChartView.noDataTextColor = UIColor.yellow
        barChartView.noDataText = "No expenses yet for this week"
        barChartView.backgroundColor = UIColor.white
        
        // Data Point setup & color config
        for i in 0..<dataPoints.count {
            let dataPoint = BarChartDataEntry(x: Double(i), y: Double(values[i])!)
            dataEntry.append(dataPoint)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntry, label: "BPM")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(false) // true if we want values above bar
        chartDataSet.colors = [UIColor.blue]
        
        // Axes Setup
        let formatter : BarChartFormatter = BarChartFormatter(labels: dataPoints)
        let xaxis : XAxis = XAxis()
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.drawGridLinesEnabled = false // true if want X-Axis grid lines
        barChartView.xAxis.valueFormatter = formatter
        barChartView.chartDescription?.enabled = false
        barChartView.legend.enabled = true
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawLabelsEnabled = true
        barChartView.data = chartData
    }
    
    
    
    private class BarChartFormatter: NSObject, IAxisValueFormatter {
        var labels: [String] = []
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return labels[Int(value)]
        }
        init(labels: [String]) {
            super.init()
            self.labels = labels
        }
    }

}
