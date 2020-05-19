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
    var normalizedSource = "--"
    var normalizedTarget = "--"
    var examples = [ResponseExamples]()
}

//Response Struct for dictionary/example
struct ResponseExamples: Codable {
    var sourcePrefix = "--"
    var sourceTerm = "--"
    var sourceSuffix = "--"
    var targetPrefix = "--"
    var targetTerm = "--"
    var targetSuffix = "--"
}

//*****
//**********
//*****

//Response Struct for dictionary/lookup
struct ResponseJsonLookup: Codable {
    var normalizedSource = "--"
    var displaySource = "--"
    var translations = [ResponseLookups]()
}

//Response Struct for dictionary/lookup
struct ResponseLookups: Codable {
    var normalizedTarget = "--"
    var displayTarget = "--"
    var posTag = "--"
    var confidence = Float()
    var prefixWord = "--"
    var backTranslations = [ResponseBackTranslations]()
}

//Response Struct for dictionary/lookup
struct ResponseBackTranslations: Codable {
    var normalizedText = "--"
    var displayText = "--"
    var numExamples = Int()
    var frequencyCount = Int()
}















