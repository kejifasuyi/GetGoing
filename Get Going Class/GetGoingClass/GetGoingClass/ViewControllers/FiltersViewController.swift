//
//  FiltersViewController.swift
//  GetGoingClass
//
//  Created by Admin on 2019-02-04.
//  Copyright © 2019 SMU. All rights reserved.
//

import UIKit

enum RankBy {
    case prominence, distance
    
    func description() -> String {
        switch self {
        case .distance:
            return String(describing: self)
        case .prominence:
            return String(describing: self)
        }
    }
}

class FiltersViewController: UIViewController {

    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var isOpenNow: UISwitch!
    @IBOutlet weak var rankByLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var rankBySelectedLabel: UILabel!
    
    var rankByDictionary: [RankBy] = [.prominence, .distance]
    
    //Declaring the Delegate Variable
    var filterDelegate: filterViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self
        
        rankByLabel.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(rankByLabelTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        rankByLabel.addGestureRecognizer(tapGestureRecognizer)
        rankBySelectedLabel.text = rankByDictionary.first?.description()
    
        toolBar.isHidden = true
    }
    
    @objc func rankByLabelTapped(){
        pickerView.isHidden = !pickerView.isHidden
        toolBar.isHidden = !toolBar.isHidden
    }
    
    @objc func hidePicker() {
        pickerView.isHidden = true
        toolBar.isHidden = true
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        print("switch value changed to \(sender.isOn)")
    }
    
    @IBAction func closeButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func resetButton(_ sender: UIBarButtonItem) {
        
        radiusSlider.value = Constants.defaultRadius
        rankBySelectedLabel.text = Constants.defaultRankBy
        isOpenNow.isOn = false
    }
    
    
    @IBAction func radiusSliderChangedValue(_ sender: UISlider) {
        print("slider value changed to \(sender.value) \(Int(sender.value))")
    }
    
    
    @IBAction func saveButtonAction(_ sender: UIBarButtonItem) {
        //Get Radius Value
        let radiusValue: Double = Double(radiusSlider?.value ?? Constants.defaultRadius)
        let rankByValue = rankBySelectedLabel.text ?? Constants.defaultRankBy
        let openNowValue = isOpenNow.isOn
        
        filterDelegate?.updateFilterSettings(radius: radiusValue, rankBy: rankByValue, openNow: openNowValue)
        
        self.dismiss(animated: true, completion: nil)
    }
    
  
    @IBAction func doneItemButton(_ sender: UIBarButtonItem) {
        hidePicker()
    }
}


extension FiltersViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rankByDictionary.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rankByDictionary[row].description()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rankBySelectedLabel.text = rankByDictionary[row].description()
    }
}

protocol filterViewDelegate {
    func updateFilterSettings(radius: Double, rankBy: String, openNow: Bool)
}
