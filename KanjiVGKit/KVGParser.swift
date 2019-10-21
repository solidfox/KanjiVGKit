//
//  KVGParser.swift
//  KanjiVGKit
//
//  Created by Daniel Schlaug on 6/30/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

import UIKit

class KVGParser: NSObject, NSXMLParserDelegate {
    
    class XMLElement {
        let tagName: String
        let attributeDict: Dictionary<String, String>
        var childElements: [KVGElement] = []
        var childStrokes: [KVGStroke] = []
        init(tagName:String, attributeDict: Dictionary<String,String>) {
            self.tagName = tagName
            self.attributeDict = attributeDict
        }
    }
    
    var _done = false
    var _parsingStrokePaths = false
    var _interestingTags = ["g", "path"]
    var _resultEntry: KVGEntry? = nil
    var _elementStack: [XMLElement] = []
    let _parser: NSXMLParser
    
    func _startedParsingEntry() {
        if _parsingStrokePaths {
            fatalError("Starting parsing StrokePaths twice is not allowed!")
        }
        _parsingStrokePaths = true
    }
    
    func _isChildElement(newElement:KVGElement) {
        _elementStack[_elementStack.count - 1].childElements.append(newElement)
    }
    
    func _isRootElement(newElement:KVGElement) {
        assert(_resultEntry == nil)
        _resultEntry = KVGEntry(rootElement: newElement)
        _finishedParsingEntry()
    }
    
    func _finishedParsingEntry() {
        assert(_parsingStrokePaths, "Cannot finish parsing entry without starting.")
        _parsingStrokePaths = false
        _done = true
    }
   
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: NSDictionary!) {
        // Guard for noninteresting tags
        if _done || !contains(_interestingTags, elementName) {
            return
        }
        
        let newElement = XMLElement(
            tagName: elementName,
            attributeDict: attributeDict as Dictionary)
        
        if !_parsingStrokePaths {
            // Check if we are starting a StrokePaths element
            if newElement.tagName == "g" {
                if let idAttribute = newElement.attributeDict["id"] {
                    if idAttribute.hasPrefix("kvg:StrokePaths"){
                        _startedParsingEntry()
                        return
                    }
                }
            }
        } else {
            _elementStack.append(newElement)
        }
    }
    
    
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        // Guard for noninteresting tags
        if _done || !contains(_interestingTags, elementName) {
            return
        }
        let currentTagName = elementName!
        
        if _parsingStrokePaths {
            let endedElement = _elementStack.removeLast()
            if endedElement.tagName != currentTagName {
                NSLog("Tag name \(endedElement.tagName) != \(currentTagName)")
                fatalError("Invalid xml")
            }
            
            switch endedElement.tagName {
            case "g":
                let newElement = KVGElement(attributeDict: endedElement.attributeDict, rootStrokes: endedElement.childStrokes, childElements: endedElement.childElements)
                
                if _elementStack.isEmpty {
                    _isRootElement(newElement)
                } else {
                    _isChildElement(newElement)
                }
            case "path":
                assert(endedElement.childElements.isEmpty)
                assert(endedElement.childStrokes.isEmpty)
                let newStroke = KVGStroke(attributeDictionary: endedElement.attributeDict)
                _elementStack[_elementStack.count - 1].childStrokes.append(newStroke)
            default:
                println("Unrecognized tag ended: \(elementName)")
                fatalError("Unrecognized tagName")
            }

        }
    }
    
    func parse() -> KVGEntry? {
        _parser.parse()
        
        let returnEntry = _resultEntry
        _resultEntry = nil
        
        return returnEntry
    }
    
    init(SVGData: NSData) {
        _parser = NSXMLParser(data: SVGData)!
        super.init()
        _parser.delegate = self
        _parser.shouldProcessNamespaces = false
        _parser.shouldReportNamespacePrefixes = false
        _parser.shouldResolveExternalEntities = false
    }
}
