//
//  KVGEntry.swift
//  KEX
//
//  Created by Daniel Schlaug on 6/26/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

import Foundation
import UIKit

class KVGEntry {
    
    let character: Character
    let element: KVGElement
    var strokes: [KVGStroke] {
    return element.strokes
    }
    
    init(rootElement: KVGElement) {
        element = rootElement
        character = element.mostSimilarUnicode!
    }
    
    class func entryFromData(SVGData: NSData) -> KVGEntry? {
        let parser = KVGParser(SVGData: SVGData)
        return parser.parse()
    }
    
    func strokeWithStrokeCount(count:Int) -> KVGStroke {
        return strokes[count - 1]
    }
    
    func debugQuickLookObject() -> AnyObject {
        return element
    }
}
