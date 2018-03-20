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
    
    //*****Used in the parsing of request JSON as a dictionary
    struct Transliteration: Codable {
        var transliteration = [String: LanguageNames]()
    }
    
    //This is for parsing of request JSON as a dictionary
    struct LanguageNames: Codable {
        var name = String()
        var nativeName = String()
        var scripts = [ScriptLangDetails]()
    }
    
    //*****Used to hold the final data from parsing in an array of structs data pulled from dictionary parsed from the languages JSON.
    struct TransliterationAll: Codable {
        var langCode = String()
        var langName = String()
        var langNativeName = String()
        var langScriptData = [ScriptLangDetails]() //re-using struct from parsing
    }

    //This is for parsing and after JSON parsing to hold final data
    struct ScriptLangDetails: Codable {
        var code = String()
        var name = String()
        var nativeName = String()
        var dir = String()
        var toScripts = [ToScripts]()
    }
    
    //This is for parsing and after JSON parsing to hold final data
    struct ToScripts: Codable {
        var code = String()
        var name = String()
        var nativeName = String()
        var dir = String()
    }
    //*****end structs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sampleDataAddress = "https://dev.microsofttranslator.com/languages?api-version=3.0&scope=transliteration" //transliteration
        let url = URL(string: sampleDataAddress)!
        let jsonData = try! Data(contentsOf: url)
        let jsonDecoder = JSONDecoder()
        
        let languages = try? jsonDecoder.decode(Transliteration.self, from: jsonData)
        print("*****Begin Dump")
        //dump(languages)
        print("*****END")
        
        //Setup struct vars
        var transliterateLangData = [TransliterationAll]()
        var transliterateLangDataEach = TransliterationAll()
        var scriptLangDetailsSingle = ScriptLangDetails()
        var toScriptDetails = ToScripts()
        
        for language in (languages?.transliteration.values)! {
            
            transliterateLangDataEach.langName = language.name
            transliterateLangDataEach.langNativeName = language.nativeName
            print("number of scriptLangDetails structs", language.scripts.count)
            
            let countInScriptsArray = language.scripts.count
            
            for index1 in 0...countInScriptsArray - 1 {
                //print("*****", language.scripts[index])
                scriptLangDetailsSingle.code = language.scripts[index1].code
                scriptLangDetailsSingle.name = language.scripts[index1].name
                scriptLangDetailsSingle.nativeName = language.scripts[index1].nativeName
                scriptLangDetailsSingle.dir = language.scripts[index1].dir
                
                let countInToScriptsArray = language.scripts[index1].toScripts.count
                var counter = 0
                while counter < countInToScriptsArray {
                    toScriptDetails.code = language.scripts[index1].toScripts[counter].code
                    toScriptDetails.name = language.scripts[index1].toScripts[counter].name
                    toScriptDetails.nativeName = language.scripts[index1].toScripts[counter].nativeName
                    toScriptDetails.dir = language.scripts[index1].toScripts[counter].dir
                    print(language.scripts[index1].toScripts[counter].code)
                    counter += 1
                    scriptLangDetailsSingle.toScripts.append(toScriptDetails)
                }
                
                transliterateLangDataEach.langScriptData.append(scriptLangDetailsSingle)
                scriptLangDetailsSingle.toScripts.removeAll()
            }
            
            transliterateLangData.append(transliterateLangDataEach)
            transliterateLangDataEach.langScriptData.removeAll()
            
        }
        
        //*****Get lang code(keyvalue) into the struct array
        let countOfLanguages = languages?.transliteration.count
        var counter = 0
        
        for languageKey in languages!.transliteration.keys {
            
            if counter < countOfLanguages! {
                transliterateLangData[counter].langCode = languageKey
                //print(transliterateLangData[counter].langCode)
                counter += 1
            }
        }
        //*****end get key
        print(transliterateLangData)
    }
    
    
    
    
    //*****move data from languages into the three structs
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    

    
    
    
}












