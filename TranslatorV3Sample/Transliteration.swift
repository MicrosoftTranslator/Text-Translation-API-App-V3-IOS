//
//  Transliteration.swift
//  TranslatorV3Sample
//
//  Created by MSTranslatorMac on 2/15/18.
//  Copyright © 2018 MSTranslatorMac. All rights reserved.
//

import Foundation
import UIKit

class Transliteration: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //*****this is for after parsing to hold the data
    struct TransliterationAll: Codable {
        var langCode = String()
        var langName = String()
        var langNativeName = String()
        var langScriptData = [LangDetails]() //re-using struct from parsing
    }
    
    struct LangDetails: Codable {
        var code = String()
        var name = String()
        var nativeName = String()
        var dir = String()
        var toScripts = [ToScripts]()
        
        struct ToScripts: Codable {
            var code = String()
            var name = String()
            var nativeName = String()
            var dir = String()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var languages = parseTransliterate()
        dump(languages)
    }
    
    
    //*****move data from languages into the three structs
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    

    
    
    
}












