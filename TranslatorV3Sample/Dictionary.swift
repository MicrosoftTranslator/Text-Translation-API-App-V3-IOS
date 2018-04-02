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
        //let countOfLanguages = languages?.transliteration.count
        var counter = 0
        
        for languageKey in languages!.dictionary.keys {
            
            if counter < countOfLanguages! {
                dictionaryLangArray[counter].langCode = languageKey
                print(languageKey)
                counter += 1
            }
        }
        //*****end get key
        //transliterateLangDataEach.langName = "--Select--"
        //transliterateLangData.insert(transliterateLangDataEach, at: 0)
        print(dictionaryLangArray)
        
        dictionaryLangArray.sort(by: {$0.langName < $1.langName})
        
    }
    
} //end class





























