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
    
    //*****used after parsing need to put into an array of structs
    struct AllLangDetails: Codable {
        var code = String()
        var name = String()
        var nativeName = String()
        var dir = String()
    }
    var arrayLangInfo = [AllLangDetails]()
    
    //*****Formatting JSON for body of request
    struct TranslatedStrings: Codable {
        var text: String
        var to: String
    }
    
    let jsonEncoder = JSONEncoder()
    
    @IBOutlet weak var fromLangPicker: UIPickerView!
    @IBOutlet weak var toLangPicker: UIPickerView!
    @IBOutlet weak var textToTranslate: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fromLangPicker.dataSource = self
        toLangPicker.dataSource = self
        fromLangPicker.delegate =  self
        toLangPicker.delegate = self
        
        getLanguages()
        usleep(900000)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //*****IBAction
    
    @IBAction func getTranslationBtn(_ sender: Any) {
        
        let azureKey = "18358F19A2E74F80-A7C5BE039C8E614D"
        let contentType = "Content-Type/json"
        let traceID = "a1d2e356-ded0-8cce-c5a11d34589"
        let host = "dev.microsofttranslator.com"
        let sampleLangAddress = "https://dev.microsofttranslator.com/translate?api-version=3.0&from=en&to=de"
        
        let textToTranslate = TranslatedStrings(text: "my dog is very happy", to: "de")
        let jsonToTranslate = try? jsonEncoder.encode(textToTranslate.self)
        
        let url = URL(string: sampleLangAddress)
        print(url!, azureKey)
        //X-MT-ClientKey: 18358F19A2E74F80-A7C5BE039C8E614D
        
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.addValue(azureKey, forHTTPHeaderField: "X-MT-ClientKey")
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        request.addValue(traceID, forHTTPHeaderField: "X-ClientTraceID")
        request.addValue(host, forHTTPHeaderField: "Host")
        request.httpBody = jsonToTranslate
        
        //*****TO DO ADD THE TASK USING THE REQUEST AND RESUME TASK, ADD COMPLETION BLOCK AND THEN PARSE THE JSON
    }
    
    //*****Class Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var rowCount = Int()
        
        if pickerView == fromLangPicker {
            rowCount = arrayLangInfo.count
        } else if pickerView == toLangPicker {
            rowCount = arrayLangInfo.count
        }
        return rowCount
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var rowContent = String()
        
        if pickerView == fromLangPicker {
            rowContent = arrayLangInfo[row].nativeName
            
        } else if pickerView == toLangPicker {
            rowContent = arrayLangInfo[row].name
        }
        
        let attributedString = NSAttributedString(string: rowContent, attributes: [NSAttributedStringKey.foregroundColor : UIColor.blue])
        
        return attributedString
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
        
        
        
        let jsonDecoder1 = JSONDecoder()
        
        let languages = try? jsonDecoder1.decode(Translation.self, from: jsonLangData)
        
        var eachLangInfo = AllLangDetails(code: " ", name: " ", nativeName: " ", dir: " ") //Use this instance to populate and then append to the array instance
        
        
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
        
        //arrayLangInfo.count
        //print(arrayLangInfo[60])
        arrayLangInfo.sort(by: {$0.code < $1.code})
        print(arrayLangInfo)
    }
    
    
    
}
