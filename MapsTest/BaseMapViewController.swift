//
//  BaseMapViewController.swift
//  MapsTest
//
//  Created by Timo Schoepflin on 11.09.17.
//  Copyright © 2017 Timo Schoepflin. All rights reserved.
//
import UIKit
class BaseMapViewController :UIViewController,UITextFieldDelegate{
    
    @IBOutlet var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Override in implementation class to perform search
    func updateMapBasedOnSearch(searchText:String){}
    
    // Triggered on submit in keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.returnKeyType==UIReturnKeyType.go)
        {
            updateMapBasedOnSearch(searchText: textField.text!)
            textField.endEditing(true)
        }
        return true
    }
    
}
