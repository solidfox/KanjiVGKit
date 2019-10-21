//
//  KVGStroke.swift
//  KEX
//
//  Created by Daniel Schlaug on 6/25/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

//import BezierKit
//import DanielsKit
import Foundation
import CoreGraphics

enum StrokeType: Character {
    case Dot = "㇔"
    case Vertical = "㇑"
    case Horizontal = "㇐"
    case HorizontalBent = "㇕"
    case ThrowAway = "㇒"
    case PressDown = "㇏"
    // TODO add all
}

class KVGStroke {
    
    let path: BezierPath
    let type: Character
    var parent: KVGElement!
    let strokeOrder: Int
    let bounds = CGSize(width:109, height:109)
    
    init(attributeDictionary: Dictionary<String, String>) {
        let idAttribute = attributeDictionary["id"]!
        let strokeOrderRegExp = ~/".*-s([1-9][0-9]?)(-.*|$)"
        let strokeOrderString: NSString = strokeOrderRegExp.stringByReplacingMatchesInString(idAttribute, options: [], range: idAttribute.fullRange, withTemplate: "$1")
        let strokeOrder = strokeOrderString.integerValue
        self.strokeOrder = strokeOrder
        assert(strokeOrder != 0, "Could not parse stroke order.")
        
        let dAttribute = attributeDictionary["d"]!
        let typeAttribute = attributeDictionary["kvg:type"]!
        
        self.path = BezierPath(SVGdAttribute: dAttribute)
        
        self.type = typeAttribute[0]
    }
    
    
    func debugQuickLookObject() -> AnyObject {
        return path
    }
}