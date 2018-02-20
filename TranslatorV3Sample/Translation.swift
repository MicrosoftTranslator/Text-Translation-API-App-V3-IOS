//
//  Translation.swift
//  TranslatorV3Sample
//
//  Created by MSTranslatorMac on 2/15/18.
//  Copyright © 2018 MSTranslatorMac. All rights reserved.
//

import Foundation
import UIKit

class Translation: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    
    
    @IBOutlet weak var textToTranslate: UITextView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("test")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //*****CODE FROM PLAYGROUND FOR GETTING LANGUAGES NEED TO MOVE SOME VARS TO CLASS VARS
    func getLanguages() {
        
        let sampleLangAddress = "https://dev.microsofttranslator.com/languages?api-version=3.0&scope=translation"
        
        let url1 = URL(string: sampleLangAddress)
        let jsonLangData = try! Data(contentsOf: url1!)
        
        //*****used in the parsing of Json
        struct Translation: Codable {
            var translation: [String: LanguageDetails]
            
        }
        
        struct LanguageDetails: Codable {
            var name: String
            var nativeName: String
            var dir: String
        }
        
        //*****used after parsing need to put into an array of structs
        struct AllLangDetails: Codable {
            var code = String()
            var name = String()
            var nativeName = String()
            var dir = String()
        }
        
        let jsonDecoder1 = JSONDecoder()
        
        let languages = try? jsonDecoder1.decode(Translation.self, from: jsonLangData)
        
        var eachLangInfo = AllLangDetails(code: " ", name: " ", nativeName: " ", dir: " ") //Use this instance to populate and then append to the array instance
        var arrayLangInfo = [AllLangDetails]()
        
        //dump(languages)
        //print(languages!.translation.first?.key as Any)
        //print(languages!.translation.first?.value.name as Any)
        //print(languages!.translation.first?.value.nativeName as Any)
        //print(languages!.translation.first?.value.dir as Any)
        
        for languageValues in languages!.translation.values {
            eachLangInfo.name = languageValues.name
            eachLangInfo.nativeName = languageValues.nativeName
            eachLangInfo.dir = languageValues.dir
            arrayLangInfo.append(eachLangInfo)
        }
        
        let countOfLanguages = languages?.translation.count
        var counter = 0
        
        for languageKey in languages!.translation.keys {
            
            if counter < countOfLanguages! {
                arrayLangInfo[counter].code = languageKey
                counter += 1
            }
        }
        
        arrayLangInfo.count
        //print(arrayLangInfo[60])
        arrayLangInfo.sort(by: {$0.code < $1.code})
        print(arrayLangInfo)
    }
    
    
    
}
