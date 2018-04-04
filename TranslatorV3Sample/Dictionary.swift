//
//  Dictionary.swift
//  TranslatorV3Sample
//
//  Created by MSTranslatorMac on 2/15/18.
//  Copyright © 2018 MSTranslatorMac. All rights reserved.
//

import Foundation
import UIKit

class Dictionary: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //*****TODO CHANGE THE UI TO DISABLE THE EXAMPLE BUTTON UNTIL THE LOOKUP BUTTON HAS BEEN PRESSED, NO TITLE. IF THE EXAMPLE BUTTON IS VISIBLE AND PRESSED THEN USE THE RETURNED DATA FROM THE LOOKUP AS THE INPUT FOR THE EXAMPLE AND DISPLAY THE EXAMPLE BELOW THE LOOKUP OR IN PLACE OF THE LOOKUP.
    
    @IBOutlet weak var fromLanguage: UIPickerView!
    @IBOutlet weak var toLanguage: UIPickerView!
    @IBOutlet weak var textToSubmitTxt: UITextField!
    @IBOutlet weak var textReturnedTxtView: UITextView!
    
    var dictionaryLangArray = [DictionaryLanguages]()
    var dictionaryLangEach = DictionaryLanguages()
    var dictionaryTranslationTo = TranslationsTo()
    var firstPickerRowSelected = Int()
    var secondLanguageArray = [TranslationsTo]()
    let jsonEncoder = JSONEncoder()
    
    //*****Structs for parsing JSON from Languages
    struct Dictionary: Codable {
        var dictionary = [String: LanguageNames]()
    }
    
    struct LanguageNames: Codable {
        var name = String()
        var nativeName = String()
        var dir = String()
        var translations = [TranslationsTo]()
    }
    
    struct TranslationsTo: Codable {
        var name = String()
        var nativeName = String()
        var dir = String()
        var code = String()

    }
    //*****End struct for languages parsing
    
    //*****Struct for data after parsing
    struct DictionaryLanguages: Codable {
        var langCode = String()
        var langName = String()
        var langNativeName = String()
        var langDir = String()
        var langTranslations = [TranslationsTo]()
    }
    //*****End Struct for parsed data
    

    
    @IBAction func lookupBtnPressed(_ sender: Any) {
        
        sendRequest(typeOfRequest: "lookup")
        
    }
    
    @IBAction func exampleBtnPressed(_ sender: Any) {
        
        sendRequest(typeOfRequest: "example")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fromLanguage.dataSource = self
        fromLanguage.delegate = self
        toLanguage.dataSource = self
        toLanguage.delegate = self
        
        
        
        let sampleDataAddress = "https://dev.microsofttranslator.com/languages?api-version=3.0&scope=dictionary" //transliteration
        let url = URL(string: sampleDataAddress)!
        let jsonData = try! Data(contentsOf: url)
        let jsonDecoder = JSONDecoder()
        let languages = try? jsonDecoder.decode(Dictionary.self, from: jsonData)
        
        for language in (languages?.dictionary.values)! {
            
            dictionaryLangEach.langName = language.name
            dictionaryLangEach.langNativeName = language.nativeName
            dictionaryLangEach.langDir = language.dir
            print("number of scriptLangDetails structs", language.translations.count)
            
            let countTranslationsArray = language.translations.count
            
            for index1 in 0...countTranslationsArray - 1 {
                //print("*****", language.scripts[index])
                dictionaryTranslationTo.name = language.translations[index1].name
                dictionaryTranslationTo.nativeName = language.translations[index1].nativeName
                dictionaryTranslationTo.dir = language.translations[index1].dir
                dictionaryTranslationTo.code = language.translations[index1].code
                
                dictionaryLangEach.langTranslations.append(dictionaryTranslationTo)
            }
            dictionaryLangArray.append(dictionaryLangEach)
            dictionaryLangEach.langTranslations.removeAll()
        }
        
        //*****Get lang code(keyvalue) into the struct array
        let countOfLanguages = languages?.dictionary.count
        
        var counter = 0
        
        for languageKey in languages!.dictionary.keys {
            
            if counter < countOfLanguages! {
                dictionaryLangArray[counter].langCode = languageKey
                print(languageKey)
                counter += 1
            }
        }
        //*****end get key
        //print(dictionaryLangArray)
        
        dictionaryLangArray.sort(by: {$0.langName < $1.langName})
        dictionaryLangEach.langNativeName = "--Select--"
        dictionaryLangArray.insert(dictionaryLangEach, at: 0)

        secondLanguageArray = (dictionaryLangArray.first?.langTranslations)!
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == fromLanguage {
            return dictionaryLangArray.count
        } else if pickerView == toLanguage {
            
            return secondLanguageArray.count
            
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == fromLanguage {
            firstPickerRowSelected = row
            secondLanguageArray = dictionaryLangArray[row].langTranslations
            toLanguage.reloadComponent(0)
            print(firstPickerRowSelected)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == fromLanguage {
            return dictionaryLangArray[row].langNativeName
        } else if pickerView == toLanguage {
             return secondLanguageArray[row].nativeName
        }
        else {
            return "not found"
        }
    }
   
    func sendRequest(typeOfRequest: String) {
        
        let fromLangCode = self.fromLanguage.selectedRow(inComponent: 0)
        let toLangCode = self.toLanguage.selectedRow(inComponent: 0)
        
        print("this is the selected language code ->", dictionaryLangArray[fromLangCode].langCode)
        
        let selectedFromLangCode = dictionaryLangArray[fromLangCode].langCode
        let selectedToLangCode = dictionaryLangArray[fromLangCode].langTranslations[toLangCode].code
        
        struct encodeText: Codable {
            var text = String()
        }
        
        let azureKey = "31b6016565ac4e1585b1fdb688e42c6d"
        //let azureKey = "18358F19A2E74F80-A7C5BE039C8E614D"
        let contentType = "application/json"
        let traceID = "A14C9DB9-0DED-48D7-8BBE-C517A1A8DBB0"
        let host = "dev.microsofttranslator.com"
        let apiURL = "https://dev.microsofttranslator.com/dictionary/" + typeOfRequest + "?api-version=3.0&from=" + selectedFromLangCode + "&to=" + selectedToLangCode
        
        let text2Translate = textToSubmitTxt.text
        var encodeTextSingle = encodeText()
        var toTranslate = [encodeText]()
        encodeTextSingle.text = text2Translate!
        toTranslate.append(encodeTextSingle)
        print("text to translator for dictionary ", toTranslate)
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
        
        //print(String(data: jsonToTranslate!, encoding: .utf8)!)
        let config = URLSessionConfiguration.default
        let session =  URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            
            if responseError != nil {
                print("this is the error ", responseError!)
            }
            print("*****")
            print(response!)
            dump(responseData!)
            self.parseJson(jsonData: responseData!, typeOfRequest: typeOfRequest)
        }
        task.resume()
    }
    
    func parseJson(jsonData: Data, typeOfRequest: String) {
        let jsonDecoder = JSONDecoder()
        
        
        
        
        if typeOfRequest == "example" {
            let dictionaryTranslationsExample = try? jsonDecoder.decode(Array<ResponseJsonExample>.self, from: jsonData)
            
        }
        
        if typeOfRequest == "lookup" {
            let dictionaryTranslationsLookup = try? jsonDecoder.decode(Array<ResponseJsonLookup>.self, from: jsonData)
            
            print(dictionaryTranslationsLookup!.count)
            
            //Put response on main thread to update UI
            DispatchQueue.main.async {
                self.textReturnedTxtView.text = "Source word: " + dictionaryTranslationsLookup![0].normalizedSource + "\n"
                self.textReturnedTxtView.text = self.textReturnedTxtView.text.appending("Translations: " + dictionaryTranslationsLookup![0].translations[0].normalizedTarget) + "\n"
                self.textReturnedTxtView.text = self.textReturnedTxtView.text.appending("Grammar: " + dictionaryTranslationsLookup![0].translations[0].posTag) + "\n"
            }
        }
        

    }
    
} //end class





























