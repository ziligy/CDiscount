import Foundation

public enum Error : ErrorProtocol {
    case couldNotCompileMarkdown(code:Int32)
}

public struct Markdown {

    private typealias DocumentPointer = UnsafeMutablePointer<Void>
    private typealias BytePointer = UnsafeMutablePointer<Int8>

    private let markdown: DocumentPointer

    public init(from: String) throws {
        self.markdown = mkd_string(from, Int32(from.characters.count), 0)

        let result = mkd_compile(self.markdown, 0)

        if result <= 0 {
            throw Error.couldNotCompileMarkdown(code: result)
        }
    }

    public var html: String {

        var buffer = [BytePointer?](repeating: BytePointer(allocatingCapacity: 1), count: 1)

        mkd_document(markdown, &buffer)

        guard let html = String(validatingUTF8: buffer[0]!) else {
            return ""
        }

        return html
    }

}
