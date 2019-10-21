//
//  KVGElement.swift
//  KEX
//
//  Created by Daniel Schlaug on 6/25/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

import Foundation
import UIKit
//import DanielsKit

enum KVGRadical: String {
    case General = "general"
    case Nelson = "nelson"
    case Tradit = "tradit"
}

enum KVGPosition: String {
    case Left = "left"
    case Right = "right"
    case Top = "top"
    case Bottom = "bottom"
    case Nyo = "nyo"
    case Tare = "tare"
    case Kamae = "kamae"
    case Kamae1 = "kamae1"
    case Kamae2 = "kamae2"
}

class KVGElement {
    let mostSimilarUnicode: Character?
    let semanticUnicode: Character?
    let position: KVGPosition?
    let radical: KVGRadical?
    let variant: Bool
    let partial: Bool
    let number: Int?
    let childElements: [KVGElement]
    var parent: KVGElement?
    let rootStrokes: [KVGStroke]
    
    var strokes: [KVGStroke] {
        var strokes = rootStrokes
        for childElement in childElements {
            strokes += childElement.strokes
        }

        strokes.sortInPlace {$0.strokeOrder < $1.strokeOrder}
        
        return strokes
    }
    
    init(attributeDict:Dictionary<String,String>, rootStrokes:[KVGStroke] = [], childElements:[KVGElement] = []) {
        mostSimilarUnicode = attributeDict["kvg:element"]?[0]
        semanticUnicode = attributeDict["kvg:original"]?[0]
        position = KVGPosition(rawValue: attributeDict["kvg:position"] ?? "")
        radical = KVGRadical(rawValue: attributeDict["kvg:radical"] ?? "")
        variant = attributeDict["kvg:variant"] == "true"
        partial = attributeDict["kvg:partial"] == "true"
        number = Int(attributeDict["kvg:number"] ?? "")
        
        self.childElements = childElements
        self.rootStrokes = rootStrokes
        for element in self.childElements {
            element.parent = self
        }
        for stroke in self.rootStrokes {
            stroke.parent = self
        }
    }
    
    func debugQuickLookObject() -> AnyObject {
        let path = UIBezierPath()
        for stroke in strokes {
            path.appendPath(stroke.path.UIBezierPath)
        }
        return path
    }
}
