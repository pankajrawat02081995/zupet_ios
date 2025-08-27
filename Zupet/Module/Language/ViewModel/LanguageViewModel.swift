//
//  LanguageViewModel.swift
//  Zupet
//
//  Created by Pankaj Rawat on 27/08/25.
//

import Foundation

final class LanguageViewModel{
    
    private var view : LanguageVC?
    let languages: [LanguageModel] = [
        LanguageModel(language: "English", languageCode: "en"),
        LanguageModel(language: "Spanish", languageCode: "es"),
        LanguageModel(language: "French", languageCode: "fr")
    ]
    init(view : LanguageVC) {
        self.view = view
    }
}
