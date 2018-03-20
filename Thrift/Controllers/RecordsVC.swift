//
//  CVCalendarViewController.swift
//  Thrift
//
//  Created by Jervin Cruz on 2/26/18.
//  Copyright © 2018 Jervin Cruz. All rights reserved.
//

import UIKit
import CVCalendar
import CoreData

class RecordsVC : UIViewController {

    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var recordsTableView: UITableView!
    @IBOutlet weak var monthLabel: UILabel!
    
    var name = ""
    var price = 0.0
    var category = ""
    var date = ""
    var viewAppeared = false
    
    var selectedDay = ""
    var selectedMonth = ""
    var selectedYear = ""
    var selectedDate = ""
    
    private var selectedDayView : DayView!
    var recordsContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var expenses = [Expense]()

    override func viewDidLoad(){
        super.viewDidLoad()
        loadExpenses()
    }
    
    override func viewDidLayoutSubviews() {
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
        calendarView.setNeedsUpdateConstraints()
    }
    
    func saveExpense(){
        do {
            try recordsContext.save()
        } catch {
            fatalError("Error saving expenses \(error)")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if viewAppeared{
            menuView.commitMenuViewUpdate()
            calendarView.commitCalendarViewUpdate()
            calendarView.toggleCurrentDayView()
            selectedDateConverter()
            loadExpenses()
            self.recordsTableView.reloadData()
        }
        viewAppeared = true
    }
    
    func loadExpenses(with request : NSFetchRequest<Expense> = Expense.fetchRequest()){
        let selectedDayPredicate = NSPredicate(format: "date == %@", selectedDate)
        request.predicate = selectedDayPredicate
        do {
            expenses = try recordsContext.fetch(request)
            for expense in expenses {
                name = expense.name!
                price = expense.price
                category = expense.category!
                date = expense.date!
            }
        } catch {
            fatalError("Error fetching expenses \(error)")
        }
    }
    
    func selectedDateConverter(){
        selectedDate = selectedDayView.date.commonDescription
        let dateSeparatedBySpace = selectedDate.replacingOccurrences(of: ",", with: "")
        let selectedDateArray = dateSeparatedBySpace.components(separatedBy: " ")
        let selectedDay = selectedDateArray[0].count == 1 ? ("0" + selectedDateArray[0]) : selectedDateArray[0]
        selectedYear = selectedDateArray[2]
        
        switch selectedDateArray[1] {
            case "January":
                selectedMonth = "01"
            case "February":
                selectedMonth = "02"
            case "March":
                selectedMonth = "03"
            case "April":
                selectedMonth = "04"
            case "May":
                selectedMonth = "05"
            case "June":
                selectedMonth = "06"
            case "July":
                selectedMonth = "07"
            case "August":
                selectedMonth = "08"
            case "September":
                selectedMonth = "09"
            case "October":
                selectedMonth = "10"
            case "November":
                selectedMonth = "11"
            case "December":
                selectedMonth = "12"
            default:
                selectedMonth = "01"
        }
        self.selectedDate = "\(selectedDay) \(selectedMonth), \(selectedYear)"
    }
}

//MARK: - Records TableView

extension RecordsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordsCell", for: indexPath) as! RecordsTVCell
        
        cell.transform = CGAffineTransform(translationX: 0, y: 1)
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0.05*Double(indexPath.row), options: [.curveEaseInOut], animations: {
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
            cell.alpha = 1
        }, completion: nil)
        
        switch expenses[indexPath.row].category {
        case "Food"?:
            cell.recordImage.image = UIImage(named: "foodBlue")
        case "Auto"?:
            cell.recordImage.image = UIImage(named: "autoBlue")
        case "Utilities"?:
            cell.recordImage.image = UIImage(named: "utilitiesBlue")
        case "Clothing"?:
            cell.recordImage.image = UIImage(named: "clothingBlue")
        case "Leisure"?:
            cell.recordImage.image = UIImage(named: "leisureBlue")
        case "Misc"?:
            cell.recordImage.image = UIImage(named: "miscBlue")
        default:
            cell.recordImage.image = UIImage(named: "foodBlue")
        }
        
        cell.recordName.text = expenses[indexPath.row].name!
        cell.recordPrice.text = expenses[indexPath.row].price > 99999.99 ? "$ 100k+ " : " $ \(String(format: "%.2f", expenses[indexPath.row].price))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.recordsContext.delete(self.expenses[indexPath.row])
            self.expenses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.saveExpense()
            tableView.reloadData()
        }
        return [delete]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recordsToAddExpense" {
            let addExpenseVC = segue.destination as! AddExpenseVC
            addExpenseVC.selectedDate = selectedDate
        }
    }

}

//MARK: - CVCalendar
extension RecordsVC: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
        selectedDayView = dayView
        selectedDate = selectedDayView.date.commonDescription
        selectedDateConverter()
        loadExpenses()

        DispatchQueue.main.async{
            self.recordsTableView.reloadData()
        }
    }
    
    func presentationMode() -> CalendarMode {
        return CalendarMode.monthView
    }
    
    func firstWeekday() -> Weekday {
        return Weekday.sunday
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        monthLabel.fadeTransition(0.4)
        monthLabel.text! = String(date.month)
        var month = ""
        switch date.month {
        case 1:
            month = "January"
        case 2:
            month = "February"
        case 3:
            month = "March"
        case 4:
            month = "April"
        case 5:
            month = "May"
        case 6:
            month = "June"
        case 7:
            month = "July"
        case 8:
            month = "August"
        case 9:
            month = "September"
        case 10:
            month = "October"
        case 11:
            month = "November"
        case 12:
            month = "December"
        default:
            month = ""
        }
        monthLabel.text = "\(month) \(date.year)"
    }
}


extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionFade)
    }
}
