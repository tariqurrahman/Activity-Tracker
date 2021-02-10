//
//  SettingsViewController.swift
//  ActivityTracker
//
//  Created by Tariqur on 11/21/20.
//

import UIKit

class SettingsViewController: UIViewController {

    let mainScreenBGColorButton = UIButton(type: .roundedRect)
    let buttonColorButton = UIButton(type: .roundedRect)
    let activityScreenBGColorButton = UIButton(type: .roundedRect)
    let clearAllActivitiesButton = UIButton(type: .roundedRect)
    let colorPickerView = ColorPickerView()
    var theme : Theme? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        let width = view.frame.width
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        
        mainScreenBGColorButton.frame = CGRect(x: 10, y: 20, width: width/2 - 10, height: 150)
        mainScreenBGColorButton.titleLabel?.lineBreakMode = .byWordWrapping
        mainScreenBGColorButton.titleLabel?.textAlignment = .center
        mainScreenBGColorButton.setTitle("Click here to select main screen background color", for: .normal)
        mainScreenBGColorButton.addTarget(self, action: #selector(selectMainScreenBGColor), for: .touchUpInside)
        mainScreenBGColorButton.layer.borderWidth = 0.5
        mainScreenBGColorButton.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(mainScreenBGColorButton)
        
        
        buttonColorButton.frame = CGRect(x: mainScreenBGColorButton.frame.maxX + 10, y: 20, width: width/2 - 20, height: 150)
        buttonColorButton.titleLabel?.lineBreakMode = .byWordWrapping
        buttonColorButton.titleLabel?.textAlignment = .center
        buttonColorButton.setTitle("Click here to select button colors", for: .normal)
        buttonColorButton.addTarget(self, action: #selector(selectButtonColors), for: .touchUpInside)
        buttonColorButton.layer.borderWidth = 0.5
        buttonColorButton.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(buttonColorButton)
        
        
        activityScreenBGColorButton.frame = CGRect(x: 10, y: buttonColorButton.frame.maxY + 20, width: width/2 - 10, height: 150)
        activityScreenBGColorButton.titleLabel?.lineBreakMode = .byWordWrapping
        activityScreenBGColorButton.titleLabel?.textAlignment = .center
        activityScreenBGColorButton.setTitle("Click here to select activity screen background color", for: .normal)
        activityScreenBGColorButton.addTarget(self, action: #selector(selectActivityScreenBGColor), for: .touchUpInside)
        activityScreenBGColorButton.layer.borderWidth = 0.5
        activityScreenBGColorButton.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(activityScreenBGColorButton)
        
        
        clearAllActivitiesButton.frame = CGRect(x: activityScreenBGColorButton.frame.maxX + 10, y: buttonColorButton.frame.maxY + 20, width: width/2 - 20, height: 150)
        clearAllActivitiesButton.titleLabel?.lineBreakMode = .byWordWrapping
        clearAllActivitiesButton.titleLabel?.textAlignment = .center
        clearAllActivitiesButton.setTitle("Click here to clear entire Activity data", for: .normal)
        clearAllActivitiesButton.addTarget(self, action: #selector(clearData), for: .touchUpInside)
        clearAllActivitiesButton.layer.borderWidth = 0.5
        clearAllActivitiesButton.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(clearAllActivitiesButton)
        
        DispatchQueue.main.async {
            self.colorPickerView.frame = CGRect(x: 0, y: 0, width: width, height: self.view.frame.height)
            self.colorPickerView.isHidden = true
            self.view.addSubview(self.colorPickerView)
        }
        
        self.theme = Theme.fetchTheme()
        
        mainScreenBGColorButton.backgroundColor = self.theme?.mainScreenBGColor
        activityScreenBGColorButton.backgroundColor = self.theme?.activityScreenBGColor
        buttonColorButton.backgroundColor = self.theme?.buttonsColor
        
    }
    
    @objc func selectMainScreenBGColor(){
            self.colorPickerView.isHidden = false
            self.colorPickerView.onColorDidChange = { [weak self] color in
                DispatchQueue.main.async {
                    self?.mainScreenBGColorButton.backgroundColor = color
                    self?.theme?.mainScreenBackgroundColor = color.toHex
                    self?.colorPickerView.isHidden = true
                }
            }
    }
    
    @objc func selectActivityScreenBGColor(){
        
            self.colorPickerView.isHidden = false
            self.colorPickerView.onColorDidChange = { [weak self] color in
                DispatchQueue.main.async {
                    self?.activityScreenBGColorButton.backgroundColor = color
                    self?.colorPickerView.isHidden = true
                    self?.theme?.activityScreenBackgroundColor = color.toHex
                }
            }
    }
    
    @objc func selectButtonColors(){
        
            self.colorPickerView.isHidden = false
            self.colorPickerView.onColorDidChange = { [weak self] color in
                DispatchQueue.main.async {
                    self?.buttonColorButton.backgroundColor = color
                    self?.colorPickerView.isHidden = true
                    self?.theme?.mainScreenButtonsColor = color.toHex
                }
            }
    }
    
    @objc func clearData(){
        
        let alert = UIAlertController(title: "Clear Activity Data", message: "Would you like to clear entire acctivity data", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            Activity.deleteAllActivities { (status) in
                
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func back(){
        theme?.save(complition: { (status) in
            self.navigationController?.popViewController(animated: true)
        })
    }

}
