//
//  CPDFConversion.swift
//  compdfkit-api-swift
//

#if os(iOS)
import Foundation
#else
import Cocoa
#endif

public class CPDFConversion: NSObject {
    public static let PDF_TO_WORD      = "pdf/docx"
    public static let PDF_TO_EXCEL     = "pdf/xlsx"
    public static let PDF_TO_PPT       = "pdf/pptx"
    public static let PDF_TO_TXT       = "pdf/txt"
    public static  let PDF_TO_PNG       = "pdf/png"
    public static let PDF_TO_HTML      = "pdf/html"
    public static let PDF_TO_RTF       = "pdf/rtf"
    public static let PDF_TO_CSV       = "pdf/csv"
    public static let PDF_TO_JPG       = "pdf/jpg"

    public static let DOC_TO_PDF       = "doc/pdf"
    public static let DOCX_TO_PDF      = "docx/pdf"
    public static let XLSX_TO_PDF      = "xlsx/pdf"
    public static let XLS_TO_PDF       = "xls/pdf"
    public static let PPT_TO_PDF       = "ppt/pdf"
    public static let PPTX_TO_PDF      = "pptx/pdf"
    public static let TXT_TO_PDF       = "txt/pdf"
    public static let PNG_TO_PDF       = "png/pdf"
    public static let HTML_TO_PDF      = "html/pdf"
    public static let CSV_TO_PDF       = "csv/pdf"
    public static let RTF_TO_PDF       = "rtf/pdf"
}
