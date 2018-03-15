//
//  TransliterateParsing.swift
//  TranslatorV3Sample
//
//  Created by MSTranslatorMac on 3/15/18.
//  Copyright © 2018 MSTranslatorMac. All rights reserved.
//
import Foundation



//*****used in the parsing of request Json
struct Transliterate: Codable {
    var transliterate = [String: LanguageNames]()
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
    
    struct ToScripts: Codable {
        var code = String()
        var name = String()
        var nativeName = String()
        var dir = String()
    }
}
//*****end parsing structs

func parseTransliterate() -> Transliterate {
    let sampleDataAddress = "https://dev.microsofttranslator.com/languages?api-version=3.0&scope=transliteration" //transliteration
    //let sampleDataAddress = "https://api.myjson.com/bins/ja165" //Dictionary
    
    let url = URL(string: sampleDataAddress)!
    let jsonData = try! Data(contentsOf: url)
    let jsonDecoder = JSONDecoder()
    
    let languages = try? jsonDecoder.decode(Transliterate.self, from: jsonData)
    
    dump(languages)
    
    return languages!
}




















