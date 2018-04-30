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

    @IBOutlet weak var fromLanguage: UIPickerView!
    @IBOutlet weak var toLanguage: UIPickerView!
    @IBOutlet weak var textToSubmitTxt: UITextField!
    @IBOutlet weak var textReturnedTxtView: UITextView!
    @IBOutlet weak var exampleBtn: UIButton!
    @IBOutlet weak var lookupBtn: UIButton!
    
    var dictionaryLangArray = [DictionaryLanguages]()
    var dictionaryLangEach = DictionaryLanguages()
    var dictionaryTranslationTo = TranslationsTo()
    var firstPickerRowSelected = Int()
    var secondLanguageArray = [TranslationsTo]()
    let jsonEncoder = JSONEncoder()
    var exampleText = String()
    var exampleTranslation = String()
    
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
    
    //*****Struct for data after json parsing
    struct DictionaryLanguages: Codable {
        var langCode = String()
        var langName = String()
        var langNativeName = String()
        var langDir = String()
        var langTranslations = [TranslationsTo]()
    }
    //*****End Struct for parsed data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textToSubmitTxt.delegate = self
        
        fromLanguage.dataSource = self
        fromLanguage.delegate = self
        toLanguage.dataSource = self
        toLanguage.delegate = self
        
        exampleBtn.isHidden = true
        lookupBtn.isHidden = true //hide the button until a selection is made
        
        getLanguages()
    }

    @IBAction func lookupBtnPressed(_ sender: Any) {
        
        sendRequest(typeOfRequest: "lookup")
        textToSubmitTxt.resignFirstResponder()
        exampleBtn.isHidden = false
        
    }
    
    
    @IBAction func exampleBtnPressed(_ sender: Any) {
        
        sendRequest(typeOfRequest: "examples")
    }
    
    
    func getLanguages() {
        
        let sampleDataAddress = "https://dev.microsofttranslator.com/languages?api-version=3.0&scope=dictionary"
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
        
        lookupBtn.isHidden = false //unhide after row selected
        
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
        
        let selectedFromLangCode = dictionaryLangArray[fromLangCode].langCode
        let selectedToLangCode = dictionaryLangArray[fromLangCode].langTranslations[toLangCode].code
        
        struct EncodeLookupText: Codable {
            var text = String()
        }
        
        struct EncodeExampleText: Codable {
            var text = String()
            var translation = String()
            
        }
        
        let azureKey = "*****ENTER-KEY-HERE*****"
        
        let contentType = "application/json"
        let traceID = "A14C9DB9-0DED-48D7-8BBE-C517A1A8DBB0"
        let host = "dev.microsofttranslator.com"
        let apiURL = "https://dev.microsofttranslator.com/dictionary/" + typeOfRequest + "?api-version=3.0&from=" + selectedFromLangCode + "&to=" + selectedToLangCode
        
        //get text from UItext field
        let lookupText2Translate = textToSubmitTxt.text
        
        //Create instances of Structs for encoding
        var encodeLookupTextSingle = EncodeLookupText()
        var encodeLookupText = [EncodeLookupText]()
        var encodeExampleTextSingle = EncodeExampleText()
        var encodeExampleText = [EncodeExampleText]()
        
        //add data to the example struct
        encodeExampleTextSingle.text = exampleText
        encodeExampleTextSingle.translation = exampleTranslation
        encodeExampleText.append(encodeExampleTextSingle)
        
        //add data to the lookup struct
        encodeLookupTextSingle.text = lookupText2Translate!
        encodeLookupText.append(encodeLookupTextSingle)
        
        //setup the URL
        let url = URL(string: apiURL)
        var request = URLRequest(url: url!)
        var jsonToTranslate = try? jsonEncoder.encode(encodeLookupText)
        
        if typeOfRequest == "lookup" {
            jsonToTranslate = try? jsonEncoder.encode(encodeLookupText)

        }
        
        if typeOfRequest == "examples" {
            jsonToTranslate = try? jsonEncoder.encode(encodeExampleText)
        }
        
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
            
            //call the parser
            self.parseJson(jsonData: responseData!, typeOfRequest: typeOfRequest)
        }
        task.resume() //run the setup task
    }
    
    
    func parseJson(jsonData: Data, typeOfRequest: String) {
        
        let jsonDecoder = JSONDecoder()
        
        if typeOfRequest == "examples" {
            let dictionaryTranslationsExample = try? jsonDecoder.decode(Array<ResponseJsonExample>.self, from: jsonData)
            
            DispatchQueue.main.async {
                
                if dictionaryTranslationsExample?.count != 0 && dictionaryTranslationsExample?[0].examples.count != 0 {
                    
                    let sourcePrefix = dictionaryTranslationsExample![0].examples[0].sourcePrefix
                    let sourceTerm = dictionaryTranslationsExample![0].examples[0].sourceTerm
                    let sourceSuffix = dictionaryTranslationsExample![0].examples[0].sourceSuffix
                        
                    let targetPrefix = dictionaryTranslationsExample![0].examples[0].targetPrefix
                    let targetTerm = dictionaryTranslationsExample![0].examples[0].targetTerm
                    let targetSuffix = dictionaryTranslationsExample![0].examples[0].targetSuffix
                    
                    self.textReturnedTxtView.text = "Source word: " + dictionaryTranslationsExample![0].normalizedSource + "\n"
                    self.textReturnedTxtView.text = self.textReturnedTxtView.text.appending("Target word: " + dictionaryTranslationsExample![0].normalizedTarget) + "\n \n"
                    self.textReturnedTxtView.text = self.textReturnedTxtView.text.appending(sourcePrefix + sourceTerm + sourceSuffix) + "\n"
                    self.textReturnedTxtView.text = self.textReturnedTxtView.text.appending(targetPrefix + targetTerm + targetSuffix) + "\n"

                } else {
                    self.textReturnedTxtView.text = "No Examples Found"
                }
                
            }
        }
        
        if typeOfRequest == "lookup" {
            let dictionaryTranslationsLookup = try? jsonDecoder.decode(Array<ResponseJsonLookup>.self, from: jsonData)
            
            DispatchQueue.main.async {
                
                if dictionaryTranslationsLookup?.count != 0 && dictionaryTranslationsLookup![0].translations.count != 0 {
                    self.exampleText = dictionaryTranslationsLookup![0].normalizedSource
                    self.exampleTranslation = dictionaryTranslationsLookup![0].translations[0].normalizedTarget
                    
                    self.textReturnedTxtView.text = "Source word: " + dictionaryTranslationsLookup![0].normalizedSource + "\n"
                    self.textReturnedTxtView.text = self.textReturnedTxtView.text.appending("Translations: " + dictionaryTranslationsLookup![0].translations[0].normalizedTarget) + "\n"
                    self.textReturnedTxtView.text = self.textReturnedTxtView.text.appending("Grammar: " + dictionaryTranslationsLookup![0].translations[0].posTag) + "\n"
                } else {
                    self.textReturnedTxtView.text = "No data found"
                }
            }
        }
    }
    
} //end class


extension Dictionary: UITextFieldDelegate {
    
    //this clears the text view
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textToSubmitTxt.text = ""
    }
}





























