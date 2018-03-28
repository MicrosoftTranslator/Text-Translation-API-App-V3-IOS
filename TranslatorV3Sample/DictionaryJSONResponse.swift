//
//  DictionaryJSONResponse.swift
//  TranslatorV3Sample
//
//  Created by MSTranslatorMac on 3/28/18.
//  Copyright © 2018 MSTranslatorMac. All rights reserved.
//

import Foundation

//Response Struct for dictionary/example
struct ResponseJsonExample: Codable {
    var normalizedSource = String()
    var normalizedTarget = String()
    var examples = [ResponseExamples]()
}

//Response Struct for dictionary/example
struct ResponseExamples: Codable {
    var sourcePrefix = String()
    var sourceTerm = String()
    var sourceSuffix = String()
    var targetPrefix = String()
    var targetTerm = String()
    var targetSuffix = String()
}


//*****
//**********
//*****


//Response Struct for dictionary/lookup
struct ResponseJsonLookup: Codable {
    var normalizedSource = String()
    var displaySource = String()
    var translations = [ResponseLookups]()
}

//Response Struct for dictionary/lookup
struct ResponseLookups: Codable {
    var normalizedTarget = String()
    var displayTarget = String()
    var postTag = String()
    var confidence = Float()
    var prefixWord = String()
    var backTranslations = [ResponseBackTranslations]()
}

//Response Struct for dictionary/lookup
struct ResponseBackTranslations: Codable {
    var normalizedText = String()
    var displayText = String()
    var numExamples = Int()
    var frequencyCount = Int()
}















