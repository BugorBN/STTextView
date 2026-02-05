//  Created by Marcin Krzyzanowski
//  https://github.com/krzyzanowskim/STTextView/blob/main/LICENSE.md

import SwiftUI
import UIKit
import STTextViewSwiftUI

struct ContentView: View {
    init() {
        var text = AttributedString(" ")
        text.uiKit.foregroundColor = .red
        text.uiKit.backgroundColor = .yellow
        text.uiKit.font = .systemFont(ofSize: 60)
//        text.uiKit.alignment = .center
        _text = .init(initialValue: text)
    }

    @State private var text: AttributedString
    @State private var textAlignment: NSTextAlignment = .left
    @State private var selection: NSRange?
    @State private var counter = 0
    
    var isEmpty: Bool {
        text.characters.isEmpty
    }

    var body: some View {
        GeometryReader { proxy in
            SwiftUI.Color.white
                .ignoresSafeArea()
                .overlay(alignment: .center) {
                    let height = textFieldHeight(proxySize: proxy.size)
                    
                    TextView(
                        text: $text,
                        textAlignment: $textAlignment,
                        selection: $selection,
                        options: [.wrapLines]
                    )
                    .frame(
                        maxWidth: proxy.size.width,
                        maxHeight: height
                    )
                    .background {
                        Text("Placeholder")
                            .font(Font(text.uiKit.font!))
                            .foregroundStyle(Color(text.uiKit.foregroundColor!))
                            .background(Color(text.uiKit.backgroundColor!))
                            .opacity(isEmpty ? 1 : 0)
                    }
                }
        }
    }

    private func textFieldHeight(proxySize: CGSize) -> CGFloat {
        let nsstring = NSAttributedString(text)
        let height = nsstring.height(withConstrainedWidth: proxySize.width)
        return max(height, text.uiKit.font!.lineHeight)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

private extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        let result = ceil(boundingBox.height)
        return result
    }
}
