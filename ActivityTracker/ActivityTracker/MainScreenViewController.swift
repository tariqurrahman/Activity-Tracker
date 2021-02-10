//
//  ViewController.swift
//  ActivityTracker
//
//  Created by Tariqur on 11/21/20.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    var activityTableView : UITableView!
    var settingBtn = UIButton(type: .roundedRect)
    var addBtn = UIButton(type: .roundedRect)
    var data : [Activity] = [Activity]()
    var theme : Theme? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        activityTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), style: .grouped)
        activityTableView.delegate = self
        activityTableView.dataSource = self
        activityTableView.rowHeight = view.frame.height/5.5
        activityTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        activityTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        activityTableView.backgroundColor = .clear
        view.addSubview(activityTableView)
        
        addBtn.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        addBtn.setTitle("Add", for: .normal)
        addBtn.addTarget(self, action: #selector(addClicked), for: .touchUpInside)
        
        settingBtn.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        settingBtn.setTitle("Settings", for: .normal)
        settingBtn.addTarget(self, action: #selector(settingsClicked), for: .touchUpInside)
            
//      addBtn = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addClicked))
//      settingBtn = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsClicked))

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingBtn) //settingBtn
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addBtn) //addBtn
        
        if let theme = Theme.fetchTheme() {
            self.theme = theme
        }
        else {
            self.theme = Theme.create()
            self.theme?.save(complition: { (status) in })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.settingBtn.backgroundColor = self.theme?.buttonsColor
        self.addBtn.backgroundColor = self.theme?.buttonsColor
        view.backgroundColor = self.theme?.mainScreenBGColor
        self.fetchData()
    }
    
    func fetchData(){
        Activity.fetchActivities(complition: { (activities) in
            
            DispatchQueue.main.async {
                self.data = activities
                self.activityTableView.reloadData()
            }
            
        })
    }
    
    
    @objc func addClicked(){
        
        let activityVC = ActivityViewController()
        self.navigationController?.pushViewController(activityVC, animated: true)
    }
    
    @objc func settingsClicked(){
        let settingsVC = SettingsViewController()
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }

}

extension MainScreenViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let obj = self.data[indexPath.row]
        cell.textLabel?.text = self.getCellData(obj: obj)
        cell.textLabel?.numberOfLines = 0
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activityVC = ActivityViewController()
        activityVC.objectID = self.data[indexPath.row].objectID
        self.navigationController?.pushViewController(activityVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let obj = self.data[indexPath.row]
                
        let actionDelete =  UIContextualAction(style: .normal, title: "Delete", handler: { (action,view,completionHandler ) in
            
            obj.delete { (status) in
                self.fetchData()
                completionHandler(true)
            }
            
        })
        
        actionDelete.backgroundColor = .red
    
        var actions = [UIContextualAction]()
        actions.append(actionDelete)
        let confrigation = UISwipeActionsConfiguration(actions: actions)
        confrigation.performsFirstActionWithFullSwipe = false
        return confrigation
        
    }
    
    func getCellData(obj : Activity) -> String {
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy"
        
        var description = obj.activityDiscription ?? ""
        
        if let date = obj.date {
           description +=  "\nActivity Date : " + dateformatter.string(from: date)
        }
        
        if let starttime = obj.starttime {
            dateformatter.dateFormat = "hh:mm a"
           description +=  "\nActivity starts at : " + dateformatter.string(from: starttime)
        }
        
        if let endtime = obj.endtime {
            dateformatter.dateFormat = "hh:mm a"
           description +=  "\nActivity ends at : " + dateformatter.string(from: endtime)
        }
        
        return description
    }
}


