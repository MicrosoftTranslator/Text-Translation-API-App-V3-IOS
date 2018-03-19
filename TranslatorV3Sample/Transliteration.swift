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
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        var languages = parseTransliterate()
//        dump(languages)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sampleDataAddress = "https://dev.microsofttranslator.com/languages?api-version=3.0&scope=transliteration" //transliteration
        //let sampleDataAddress = "https://api.myjson.com/bins/ja165" //Dictionary
        
        let url = URL(string: sampleDataAddress)!
        let jsonData = try! Data(contentsOf: url)
        let jsonDecoder = JSONDecoder()
        
        //*****this is for after parsing to hold the data
        struct TransliterationAll: Codable {
            var langCode = String()
            var langName = String()
            var langNativeName = String()
            var langScriptData = [ScriptLangDetails]() //re-using struct from parsing
        }
        
        //*****used in the parsing of request Json
        struct Transliteration: Codable {
            var transliteration = [String: LanguageNames]()
        }
        
        struct LanguageNames: Codable {
            var name = String()
            var nativeName = String()
            var scripts = [ScriptLangDetails]()
        }
        
        struct ScriptLangDetails: Codable {
            var code = String()
            var name = String()
            var nativeName = String()
            var dir = String()
            var toScripts = [ToScripts]()
        }
        struct ToScripts: Codable {
            var code = String()
            var name = String()
            var nativeName = String()
            var dir = String()
        }
        //*****end parsing structs
        
        let languages = try? jsonDecoder.decode(Transliteration.self, from: jsonData)
        dump(languages)
        
        //Setup struct vars
        var transliterateLangData = [TransliterationAll]()
        var transliterateLangDataEach = TransliterationAll()
        var scriptLangDetailsSingle = ScriptLangDetails()
        var toScriptDetails = ToScripts()
        
        for language in (languages?.transliteration.values)! {
            
            transliterateLangDataEach.langName = language.name
            transliterateLangDataEach.langNativeName = language.nativeName
            print(language.scripts.count)
            
            //*****THIS LOOP WORKS*****
            var countInScriptsArray = language.scripts.count
            for index in 0...countInScriptsArray - 1 {
                //print("*****", language.scripts[index])
                scriptLangDetailsSingle.code = language.scripts[index].code
                scriptLangDetailsSingle.name = language.scripts[index].name
                scriptLangDetailsSingle.nativeName = language.scripts[index].nativeName
                scriptLangDetailsSingle.dir = language.scripts[index].dir
                
                scriptLangDetailsSingle.toScripts.append(toScriptDetails)
            }
            

            
            
            
            //append each to array
            transliterateLangDataEach.langScriptData.append(scriptLangDetailsSingle)
            transliterateLangData.append(transliterateLangDataEach)
            
        }
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












