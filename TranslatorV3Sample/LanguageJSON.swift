//
//  LanguageJSON.swift
//  TranslatorV3Sample
//
//  Created by Mark Fleming, markf@imagemontage.com 5 May 2020
//  Copyright © 2018 MSTranslatorMac. All rights reserved.
//

import Foundation
/*  Documentation at: https://docs.microsoft.com/en-ca/azure/cognitive-services/Translator/reference/v3-0-languages
 
 https://api.cognitive.microsofttranslator.com/languages?api-version=3.0
 
 A client uses the scope query parameter to define which groups of languages it's interested in.
 
 scope=translation provides languages supported to translate text from one language to another language;
 scope=transliteration provides capabilities for converting text in one language from one script to another script;
 scope=dictionary provides language pairs for which Dictionary operations return data.
 
 A client may retrieve several groups simultaneously by specifying a comma-separated list of names. For example, scope=translation,transliteration,dictionary would return supported languages for all groups.
 
 JSON Repsonse:
 
 {
     "translation": {
         //... set of languages supported to translate text (scope=translation)
     },
     "transliteration": {
         //... set of languages supported to convert between scripts (scope=transliteration)
     },
     "dictionary": {
         //... set of languages supported for alternative translations and examples (scope=dictionary)
     }
 }

 */


//*****Structs for parsing JSON from Languages from Dictionary API
/*  JSON Response:
 "es": {
   "name": "Spanish",
   "nativeName": "Español",
   "dir": "ltr",
   "translations": [
     {
       "name": "English",
       "nativeName": "English",
       "dir": "ltr",
       "code": "en"
     }
   ]
 },
 */
struct LangDictionary: Codable {
    var dictionary = [String: DictLanguageNamesList]()
}

struct DictLanguageNamesList: Codable {
    var name = String()
    var nativeName = String()
    var dir = String()
    var translations = [DictTranslationsTo]()
}

struct DictTranslationsTo: Codable {
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
    var langTranslations = [DictTranslationsTo]()
}
//*****End Struct for parsed data

//*****used in the parsing of request Json for translation language list
/* JSON Response:
 {
   "translation": {
     ...
     "fr": {
       "name": "French",
       "nativeName": "Français",
       "dir": "ltr"
     },
     ...
   }
 }
 
 */
       struct TranslationLang: Codable {
           var translation: [String: TranslationLanguageDetails]
           
       }
       struct TranslationLanguageDetails: Codable {
           var name: String
           var nativeName: String
           var dir: String
       }
       //*****

//*****Structs for parsing JSON from Transliteration Languages

/* JSON Response:
 {
   "transliteration": {
     ...
     "ja": {
       "name": "Japanese",
       "nativeName": "日本語",
       "scripts": [
         {
           "code": "Jpan",
           "name": "Japanese",
           "nativeName": "日本語",
           "dir": "ltr",
           "toScripts": [
             {
               "code": "Latn",
               "name": "Latin",
               "nativeName": "ラテン語",
               "dir": "ltr"
             }
           ]
         },
         {
           "code": "Latn",
           "name": "Latin",
           "nativeName": "ラテン語",
           "dir": "ltr",
           "toScripts": [
             {
               "code": "Jpan",
               "name": "Japanese",
               "nativeName": "日本語",
               "dir": "ltr"
             }
           ]
         }
       ]
     },
     ...
   }
 }
 */
 struct Transliteration: Codable {
     var transliteration = [String: TransliterationLanguageNames]()
 }
 
 //This is for parsing of request JSON as a dictionary
 struct TransliterationLanguageNames: Codable {
     var name = String()
     var nativeName = String()
     var scripts = [ScriptLangDetails]()
 }
 

//*****End struct for languages parsing

//*****End Struct for parsed data

  //*****used after parsing to create an array of structs with language information
  struct AllLangDetails: Codable {
      var code = String()
      var name = String()
      var nativeName = String()
      var dir = String()
  }
 
 //*****Used to hold the final data from parsing in an array of structs data pulled from dictionary parsed from the languages JSON.
 struct TransliterationAll: Codable {
     var langCode = String()
     var langName = String()
     var langNativeName = String()
     var langScriptData = [ScriptLangDetails]() //re-using struct from parsing
 }

 //This is for parsing JSON from Languages, and after JSON parsing to hold final data
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

  //*****Format JSON for body of translation request
/*
    Request Body:
    [  {"Text":"fly"} ]
 */
struct TranslatedStrings: Codable {
      var text: String
      var to: String
  }

struct encodeText: Codable {
    var text = String()
}

//*****TRANSLATION RETURNED DATA*****
 struct TranslationReturnedJson: Codable {
     var translations: [TranslatedStrings]
 }

// JSON error response:
//
// {"error":{"code":401000,"message":"The request is not authorized because credentials are missing or invalid."}}

   struct jsonError: Decodable {
       let error: Platform
       struct Platform: Decodable {
            let code: Int
           let message: String
       }
   }
