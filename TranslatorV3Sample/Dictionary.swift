//
//  Dictionary.swift
//  TranslatorV3Sample
//
//  Created by MSTranslatorMac on 2/15/18.
//  Copyright © 2018 MSTranslatorMac. All rights reserved.
//

import Foundation
import UIKit

class Dictionary: UIViewController {
    
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sampleDataAddress = "https://dev.microsofttranslator.com/languages?api-version=3.0&scope=dictionary" //transliteration
        let url = URL(string: sampleDataAddress)!
        let jsonData = try! Data(contentsOf: url)
        let jsonDecoder = JSONDecoder()
        
        let languages = try? jsonDecoder.decode(Dictionary.self, from: jsonData)
        print("*****Begin Dump")
        //dump(languages)
        print("*****END")
        
        for language in (languages?.dictionary.values)! {
            
            dictionaryLangEach.dictionary. = language.name
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
        transliterateLangDataEach.langName = "--Select--"
        transliterateLangData.insert(transliterateLangDataEach, at: 0)
    }
        
    }
    
    
    
    
}





























