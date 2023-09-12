//
//  CPDFDocumentEditor.swift
//  compdfkit-api-swift
//

#if os(iOS)
import Foundation
#else
import Cocoa
#endif

public class CPDFDocumentEditor: NSObject {
    public static let SPLIT            = "pdf/split"
    public static let MERGE            = "pdf/merge"
    public static let COMPRESS         = "pdf/compress"
    public static let DELETE           = "pdf/delete"
    public static let EXTRACT          = "pdf/extract"
    public static let ROTATION         = "pdf/rotation"
    public static let INSERT           = "pdf/insert"
    public static let ADD_WATERMARK    = "pdf/addWatermark"
    public static let DEL_WATERMARK    = "pdf/delWatermark"
}
