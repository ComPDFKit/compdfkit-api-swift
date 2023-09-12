//
//  CPDFDocumentAI.swift
//  compdfkit-api-swift
//

#if os(iOS)
import Foundation
#else
import Cocoa
#endif

public class CPDFDocumentAI: NSObject {
    public static let OCR              = "documentAI/ocr"
    public static let MAGICCOLOR       = "documentAI/magicColor"
    public static let TABLEREC         = "documentAI/tableRec"
    public static let LAYOUTANALYSIS   = "documentAI/layoutAnalysis"
    public static let DEWARP           = "documentAI/dewarp"
    public static let DETECTIONSTAMP   = "documentAI/detectionStamp"
}
