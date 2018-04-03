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
    
    var dictionaryLangArray = [DictionaryLanguages]()
    var dictionaryLangEach = DictionaryLanguages()
    var dictionaryTranslationTo = TranslationsTo()
    var firstPickerRowSelected = Int()
    var secondLanguageArray = [TranslationsTo]()
    
    @IBAction func lookupBtnPressed(_ sender: Any) {
        
        
    }
    
    @IBAction func exampleBtnPressed(_ sender: Any) {
        
        
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
    
} //end class





























