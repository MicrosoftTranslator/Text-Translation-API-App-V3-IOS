//
//  Translation.swift
//  TranslatorV3Sample
//
//  Created by MSTranslatorMac on 2/15/18.
//  Copyright © 2018 MSTranslatorMac. All rights reserved.
//

import Foundation
import UIKit

class Translation: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var fromLangPicker: UIPickerView!
    @IBOutlet weak var toLangPicker: UIPickerView!
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    
    var arrayLangInfo = [AllLangDetails]() //array of structs for language info
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textToTranslate.delegate = self // UITextView!
        self.hideKeyboardWhenTappedAround()
        
        fromLangPicker.dataSource = self
        toLangPicker.dataSource = self
        fromLangPicker.delegate =  self
        toLangPicker.delegate = self
        
        getTranslationLanguages()
    }
    
    //*****IBAction
    /*    curl -X POST "https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&to=es" \
           >      -H "Ocp-Apim-Subscription-Key: 75605c0edf924ef197302112e1bbdc2a" \
           >      -H "Ocp-Apim-Subscription-Region:eastus" \
           >      -H "Content-Type: application/json" \
           >      -d "[{'Text':'Hello, what is your name?'}]"
     
           [{"detectedLanguage":{"language":"en","score":1.0},"translations":[{"text":"Hola, ¿cómo te llamas?","to":"es"}]}]
    */
    @IBAction func getTranslationBtn(_ sender: Any) {
        var fromLangCode = Int()
        var toLangCode = Int()
        let jsonEncoder = JSONEncoder()
        
        // -------------------------------------------------
        // NOTE:  UI Handling get current values in iOS.
            
        fromLangCode = self.fromLangPicker.selectedRow(inComponent: 0)
        toLangCode = self.toLangPicker.selectedRow(inComponent: 0)
        let text2Translate = textToTranslate.text   // UITextView!
        
        // end values...
        
        
        print("getTranslationBtn\nthis is the selected language code ->", arrayLangInfo[fromLangCode].code)
        print("Text:", text2Translate!)
                    
        let selectedFromLangCode = arrayLangInfo[fromLangCode].code
        let selectedToLangCode = arrayLangInfo[toLangCode].code
        
        var encodeTextSingle = encodeText()
        var toTranslate = [encodeText]()
        encodeTextSingle.text = text2Translate!
              
        toTranslate.append(encodeTextSingle)
        toTranslate.append(encodeTextSingle)
                    
        let jsonToTranslate = try? jsonEncoder.encode(toTranslate)  //  Body: [{"text":"Enter Text"}]
        print ("Body json",  jsonToTranslate!)
        
        let apiURL = "https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&from=" + selectedFromLangCode + "&to=" + selectedToLangCode
        print ("URL:", apiURL)
        
        let url = URL(string: apiURL)
        var request = URLRequest(url: url!)

        request.httpMethod = "POST"
        request.httpBody = jsonToTranslate
        let bodyLen = request.httpBody!.count
        
        request.addValue(azureKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.addValue(azureRegion, forHTTPHeaderField: "Ocp-Apim-Subscription-Region")
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        request.addValue(traceID, forHTTPHeaderField: "X-ClientTraceID")
        request.addValue(host, forHTTPHeaderField: "Host")
        
        request.addValue(String(bodyLen ), forHTTPHeaderField: "Content-Length")
        print ("Headers:", request.allHTTPHeaderFields!)
              
        let str = String(decoding: request.httpBody!, as: UTF8.self)
        print (str)

        let config = URLSessionConfiguration.default
        let session =  URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            
            if responseError != nil {
                print("this is the error ", responseError!)
                
                let alert = UIAlertController(title: "Could not connect to service", message: "Please check your network connection and try again", preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
            
            print("***** getTranslation>")
            let str = String(decoding: responseData!, as: UTF8.self)
            print ("Repsonse: ",str)
            // {"error":{"code":401000,"message":"The request is not authorized because credentials are missing or invalid."}}

            self.parseJsonTranslate(jsonData: responseData!)
           
        }
        task.resume()
    }
    
  //  URL: https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&from=en&to=ja
  //  Body: [{"text":"Enter Text"}]
  //  Response:  [{"translations":[{"text":"テキストを入力する","to":"ja"}]}]
    
    func parseJsonTranslate(jsonData: Data) {
        
        let jsonDecoder = JSONDecoder()
        if (jsonData.count == 0) {
            DispatchQueue.main.async {
                self.translatedText.text = "No data returned";
            }
             return;
        }
            
        let langTranslations = try? jsonDecoder.decode(Array<TranslationReturnedJson>.self, from: jsonData)
        print(langTranslations?.count as Any)
         //Put response on main thread to update UI
        DispatchQueue.main.async {
            if ((langTranslations) != nil) {
                
                let numberOfTranslations = langTranslations!.count - 1
                self.translatedText.text = langTranslations![numberOfTranslations].translations[0].text // only show 1st translation
                
            } else {
                    let    aError : jsonError = try! jsonDecoder.decode(jsonError.self, from: jsonData)
                    print (aError)
                    self.translatedText.text = "No translation, error:" + aError.error.message;
            }
        }
        
    }
    
    
    func getTranslationLanguages() {
        
        let  translationLangListAddress = "https://dev.microsofttranslator.com/languages?api-version=3.0&scope=translation"
        let url1 = URL(string: translationLangListAddress)
        let jsonLangData = try! Data(contentsOf: url1!)
        
        let jsonDecoder1 = JSONDecoder()
        var languages: TranslationLang?
        
        languages = try! jsonDecoder1.decode(TranslationLang.self, from: jsonLangData)
        var eachLangInfo = AllLangDetails(code: " ", name: " ", nativeName: " ", dir: " ") //Use this instance to populate and then append to the array instance
        
        for languageValues in languages!.translation.values {
            eachLangInfo.name = languageValues.name
            eachLangInfo.nativeName = languageValues.nativeName
            eachLangInfo.dir = languageValues.dir
            arrayLangInfo.append(eachLangInfo)
        //    print(languageValues.name);
        }
        
        let countOfLanguages = languages?.translation.count
        var counter = 0
       
        for languageKey in languages!.translation.keys {
            
            if counter < countOfLanguages! {
                arrayLangInfo[counter].code = languageKey
                counter += 1
            }
        }
        
        arrayLangInfo.sort(by: {$0.name < $1.name}) //sort the structs based on the language name
    }
    
// -------------------------------------------------
// NOTE:  UI Handling for selecting Language in iOS.
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var rowCount = Int()
        
        if pickerView == fromLangPicker {
            rowCount = arrayLangInfo.count
        } else if pickerView == toLangPicker {
            rowCount = arrayLangInfo.count
        }
        return rowCount
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var rowContent = String()
        
        if pickerView == fromLangPicker {
            rowContent = arrayLangInfo[row].nativeName + "(" + arrayLangInfo[row].name + ")"
            
        } else if pickerView == toLangPicker {
            rowContent = arrayLangInfo[row].name + "(" + arrayLangInfo[row].nativeName + ")"
        }
        
        let attributedString = NSAttributedString(string: rowContent, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
        return attributedString
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let languageName = row
        print("selected row ", languageName)
    }
    
}


extension Translation: UITextViewDelegate {
    
    //this clears the text view
    func textViewDidBeginEditing(_ textView: UITextView) {
        textToTranslate.text = ""
    }
}












