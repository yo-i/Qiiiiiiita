//
//  QICommon.swift
//  Qiiiiiiita
//
//  Created by yo_i on 2020/01/20.
//  Copyright © 2020 yo_i. All rights reserved.
//

import Foundation



extension String {

    func parseHTML2Text() -> NSAttributedString? {
        
        let encodeData = self.data(using: String.Encoding.utf8, allowLossyConversion: true)
        let attributedOptions =
            [
                NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
            ] as [NSAttributedString.DocumentReadingOptionKey : Any]

        var attributedString: NSAttributedString?
        if let encodeData = encodeData {
            do {
                attributedString = try NSAttributedString(
                    data: encodeData,
                    options: attributedOptions,
                    documentAttributes: nil
                )
            } catch _ {

            }
        }

        return attributedString
    }


}
