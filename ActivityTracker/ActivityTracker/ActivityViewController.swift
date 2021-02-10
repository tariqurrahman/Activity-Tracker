//
//  ActivityViewController.swift
//  ActivityTracker
//
//  Created by Tariqur on 11/21/20.
//

import UIKit
import CoreData

class ActivityViewController: UIViewController {
    
    var activityDiscriptionTV : UITextView!
    var dateSelectionTF : UITextField!
    var startTimeSelectionTF : UITextField!
    var endTimeSelectionTF : UITextField!
    var objectID : NSManagedObjectID? = nil
    var activity : Activity? = nil
    
    var datePicker = UIDatePicker()
    var startTimePicker = UIDatePicker()
    var endTimePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        
        let width = view.frame.width - 40
        
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
            startTimePicker.preferredDatePickerStyle = .wheels
            endTimePicker.preferredDatePickerStyle = .wheels
        }
        
        datePicker.datePickerMode = .date
        startTimePicker.datePickerMode = .time
        endTimePicker.datePickerMode = .time
        
        let activityDiscriptionLbl = UILabel(frame: CGRect(x: 20, y: 20, width: width, height: 20))
        activityDiscriptionLbl.text = "Activity Discription : "
        view.addSubview(activityDiscriptionLbl)
        activityDiscriptionLbl.sizeToFit()
        
        activityDiscriptionTV = UITextView(frame: CGRect(x: 20, y: activityDiscriptionLbl.frame.maxY
                                                         + 10, width: width, height: 100))
        activityDiscriptionTV.layer.borderColor = UIColor.lightGray.cgColor
        activityDiscriptionTV.layer.borderWidth = 0.5
        activityDiscriptionTV.delegate = self
        
        view.addSubview(activityDiscriptionTV)
        
        let activityDateLbl = UILabel(frame: CGRect(x: 20, y: activityDiscriptionTV.frame.maxY + 30, width: width, height: 20))
        activityDateLbl.text = "Activity Date : "
        view.addSubview(activityDateLbl)
        activityDateLbl.sizeToFit()
        
        dateSelectionTF =  UITextField(frame: CGRect(x: activityDateLbl.frame.maxX + 20, y: activityDateLbl.frame.minY - 10, width:  width - (activityDateLbl.frame.maxX), height: 40))
        dateSelectionTF.tag = 1
        dateSelectionTF.borderStyle = .roundedRect
        dateSelectionTF.inputView = datePicker
        dateSelectionTF.delegate = self

        view.addSubview(dateSelectionTF)
        
        let startTimeLbl = UILabel(frame: CGRect(x: 20, y: dateSelectionTF.frame.maxY + 30, width: 150, height: 20))
        startTimeLbl.text = "Start Time : "
        view.addSubview(startTimeLbl)
        startTimeLbl.sizeToFit()
        
        startTimeSelectionTF =  UITextField(frame: CGRect(x:startTimeLbl.frame.maxX + 20, y: startTimeLbl.frame.minY - 10 , width: width - (startTimeLbl.frame.maxX), height: 40))
        startTimeSelectionTF.borderStyle = .roundedRect
        startTimeSelectionTF.tag = 2
        startTimeSelectionTF.delegate = self
        startTimeSelectionTF.inputView = startTimePicker
        view.addSubview(startTimeSelectionTF)
        
        let endTimeLbl = UILabel(frame: CGRect(x: 20, y: startTimeSelectionTF.frame.maxY + 30, width: 150, height: 20))
        endTimeLbl.text = "End Time : "
        view.addSubview(endTimeLbl)
        endTimeLbl.sizeToFit()
        
        endTimeSelectionTF =  UITextField(frame: CGRect(x: endTimeLbl.frame.maxX
                                                     + 20, y: endTimeLbl.frame.minY - 10 , width:  width - (endTimeLbl.frame.maxX), height: 40))
        endTimeSelectionTF.tag = 3
        endTimeSelectionTF.borderStyle = .roundedRect
        endTimeSelectionTF.inputView = endTimePicker
        endTimeSelectionTF.delegate = self

        view.addSubview(endTimeSelectionTF)
        
        self.setupToolBar(textfiled: dateSelectionTF, str: "Date")
        self.setupToolBar(textfiled: startTimeSelectionTF, str: "Start Time")
        self.setupToolBar(textfiled: endTimeSelectionTF, str: "End Time")
        
        
        if let objectid = objectID {
            activity = Activity.activityOfObjectID(objectID: objectid)
            if let activity = activity{
                self.activityDiscriptionTV.text = activity.activityDiscription
                
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "dd-MM-yyyy"
                
                if let date = activity.date {
                    self.dateSelectionTF.text = dateformatter.string(from: date )
                }
                
                if let starttime = activity.starttime {
                    dateformatter.dateFormat = "hh:mm a"
                    self.startTimeSelectionTF.text = dateformatter.string(from: starttime)
                }
                
                if let endtime = activity.endtime {
                    dateformatter.dateFormat = "hh:mm a"
                    self.endTimeSelectionTF.text = dateformatter.string(from: endtime )
                }
            
            }
        }
        else {
            self.activity = Activity.create()
        }
        
        let theme = Theme.fetchTheme()
        self.view.backgroundColor = theme?.activityScreenBGColor
    }
    
    private func setupToolBar(textfiled: UITextField,str: String){
        
        let toolBar = UIToolbar(frame: CGRect(x:0, y:self.view.frame.size.height/6, width:self.view.frame.size.width, height:40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = .black
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.init(red: 17/255, green: 28/255, blue: 57/255, alpha: 1.0)
        
        let todayBtn = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.tappedToolBarBtn))
        todayBtn.tag = textfiled.tag
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.donePressed))
        okBarBtn.tag = textfiled.tag
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = str;//"Task Date"
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([todayBtn,flexSpace,textBtn,flexSpace,okBarBtn], animated: true)
        
        textfiled.inputAccessoryView = toolBar
    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "hh:mm a"
        print(sender.tag)
        if sender.tag == 1{
            dateformatter.dateFormat = "dd-MM-yyyy"
            dateSelectionTF.text = dateformatter .string(from:datePicker.date)
            self.activity?.date = datePicker.date
        }else if sender.tag == 2{
            startTimeSelectionTF.text = dateformatter.string(from: startTimePicker.date)
            self.activity?.starttime = startTimePicker.date
        }else if sender.tag == 3{
            endTimeSelectionTF.text = dateformatter.string(from: endTimePicker.date)
            self.activity?.endtime = endTimePicker.date
        }
    
        self.view.endEditing(true)
    }
    
    @objc func tappedToolBarBtn(sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    @objc func back(){
        
        if let activity = activity, activity.activityDiscription != nil && activity.date != nil && activity.starttime != nil && activity.endtime != nil {

            activity.save { (status) in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        else {
            self.activity?.delete(complition: { (status) in
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
}

extension ActivityViewController : UITextViewDelegate, UITextFieldDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        self.activity?.activityDiscription = textView.text
        self.view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
}
