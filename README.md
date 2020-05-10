# Text-Translation-API-App-V3-IOS

This app demonstrates the five main features of the Microsoft Text Translation API V3. The five methods are:
* Languages
* Translate
* Transliteration
* Dictionary/lookup
* Dictionary/Examples

The app is written in Swift 4. 
Clone the app, get an Azure Text Translation Subsrcription, get your key, replace the text "ENTER-KEY-HERE" with your key and you are ready to run.

[Translator Text API Reference](https://docs.microsoft.com/en-us/azure/cognitive-services/translator/)


Changes by Mark Fleming  10 May 2020

* add some error checking (no data returned) and return error message for bad key etc.
* add debug code to display url, header and body
* and refactor constant to new files and structure used to parse JSON return by API into Structures.

KeysAndURLS.swift - contains you key and region code
					- replace the text "ENTER-KEY-HERE" with your key and you are ready 

LanguageJSON.swift - contians may of the strucutre used to encode or decode JSON.


[Translator Text API Reference](https://docs.microsoft.com/en-ca/azure/cognitive-services/Translator/reference/v3-0-transliterate/)
