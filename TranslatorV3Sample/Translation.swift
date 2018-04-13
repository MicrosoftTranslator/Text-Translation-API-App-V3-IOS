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


    @IBOutlet weak var fromLangPicker: UIPickerView!
    @IBOutlet weak var toLangPicker: UIPickerView!
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    
    
    var fromLangCode = Int()
    var toLangCode = Int()
    var arrayLangInfo = [AllLangDetails]() //array of structs for language info
    let jsonEncoder = JSONEncoder()
    
    
    //*****used after parsing to create an array of structs with language information
    struct AllLangDetails: Codable {
        var code = String()
        var name = String()
        var nativeName = String()
        var dir = String()
    }
    
    
    //*****Format JSON for body of translation request
    struct TranslatedStrings: Codable {
        var text: String
        var to: String
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textToTranslate.delegate = self
        self.hideKeyboardWhenTappedAround()
        
        fromLangPicker.dataSource = self
        toLangPicker.dataSource = self
        fromLangPicker.delegate =  self
        toLangPicker.delegate = self
        
        getLanguages()
    }
    
    
    //*****IBAction
    
    @IBAction func getTranslationBtn(_ sender: Any) {
        
        fromLangCode = self.fromLangPicker.selectedRow(inComponent: 0)
        toLangCode = self.toLangPicker.selectedRow(inComponent: 0)
        
        print("this is the selected language code ->", arrayLangInfo[fromLangCode].code)
        
        let selectedFromLangCode = arrayLangInfo[fromLangCode].code
        let selectedToLangCode = arrayLangInfo[toLangCode].code
        
        struct encodeText: Codable {
            var text = String()
        }
        
        let azureKey = "31b6016565ac4e1585b1fdb688e42c6d"
        //let azureKey = "18358F19A2E74F80-A7C5BE039C8E614D"
        let contentType = "application/json"
        let traceID = "A14C9DB9-0DED-48D7-8BBE-C517A1A8DBB0"
        let host = "dev.microsofttranslator.com"
        let apiURL = "https://dev.microsofttranslator.com/translate?api-version=3.0&from=" + selectedFromLangCode + "&to=" + selectedToLangCode
        
        let text2Translate = textToTranslate.text
        var encodeTextSingle = encodeText()
        var toTranslate = [encodeText]()
        
        encodeTextSingle.text = text2Translate!
        toTranslate.append(encodeTextSingle)
        
        let jsonToTranslate = try? jsonEncoder.encode(toTranslate)
        let url = URL(string: apiURL)
        var request = URLRequest(url: url!)

        request.httpMethod = "POST"
        request.addValue(azureKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        request.addValue(traceID, forHTTPHeaderField: "X-ClientTraceID")
        request.addValue(host, forHTTPHeaderField: "Host")
        request.addValue(String(describing: jsonToTranslate?.count), forHTTPHeaderField: "Content-Length")
        request.httpBody = jsonToTranslate
        
        let config = URLSessionConfiguration.default
        let session =  URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            
            if responseError != nil {
                print("this is the error ", responseError!)
                
                let alert = UIAlertController(title: "Could not connect to service", message: "Please check your network connection and try again", preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
                
            }
            print("*****")
            self.parseJson(jsonData: responseData!)
        }
        task.resume()
    }
    
    
    func parseJson(jsonData: Data) {
        
        //*****TRANSLATION RETURNED DATA*****
        struct ReturnedJson: Codable {
            var translations: [TranslatedStrings]
        }
        struct TranslatedStrings: Codable {
            var text: String
            var to: String
        }
        
        let jsonDecoder = JSONDecoder()
        let langTranslations = try? jsonDecoder.decode(Array<ReturnedJson>.self, from: jsonData)
        let numberOfTranslations = langTranslations!.count - 1
        print(langTranslations!.count)
        
        //Put response on main thread to update UI
        DispatchQueue.main.async {
            self.translatedText.text = langTranslations![0].translations[numberOfTranslations].text
        }
    }
    
    
    //*****CODE FROM PLAYGROUND FOR GETTING LANGUAGES NEED TO MOVE SOME VARS TO CLASS VARS
    func getLanguages() {
        
        let sampleLangAddress = "https://dev.microsofttranslator.com/languages?api-version=3.0&scope=translation"
        
        let url1 = URL(string: sampleLangAddress)
        let jsonLangData = try! Data(contentsOf: url1!)
        
        //*****used in the parsing of request Json
        struct Translation: Codable {
            var translation: [String: LanguageDetails]
            
        }
        struct LanguageDetails: Codable {
            var name: String
            var nativeName: String
            var dir: String
        }
        //*****
        
        let jsonDecoder1 = JSONDecoder()
        var languages: Translation?
        
        languages = try! jsonDecoder1.decode(Translation.self, from: jsonLangData)
        var eachLangInfo = AllLangDetails(code: " ", name: " ", nativeName: " ", dir: " ") //Use this instance to populate and then append to the array instance
        
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
        
        arrayLangInfo.sort(by: {$0.name < $1.name}) //sort the structs based on the language name
    }
    
    
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
        
        //*****
        //TO DO: THE NATIVE NAME PICKER IS NOT SORTED CORRECTLY NEED TO CREATE TWO ARRAYS AND SORT ONE BY NAME AND THE OTHER BY NATIVE NAME, FROM IS NATIVE NAME.
        //*****
        
        if pickerView == fromLangPicker {
            rowContent = arrayLangInfo[row].nativeName
            
        } else if pickerView == toLangPicker {
            rowContent = arrayLangInfo[row].name
        }
        
        let attributedString = NSAttributedString(string: rowContent, attributes: [NSAttributedStringKey.foregroundColor : UIColor.black])
        
        return attributedString
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let languageName = row
        print("selected row ", languageName)
    }
    
}


extension Translation: UITextViewDelegate {
    
    //this clears the text view
    func textViewDidBeginEditing(_ textView: UITextView) {
        textToTranslate.text = ""
    }
}












