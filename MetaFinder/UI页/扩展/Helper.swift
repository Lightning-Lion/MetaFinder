

// MARK: - UIKit+
let keyWindow = UIApplication.shared.keyWindow
// MARK: - WebView
import SwiftUI
import WebKit
struct Bro: View {
    let 网页:URL
    
    @StateObject var viewModel = WebView.ProgressViewModel(progress: 0.0)
    @State var 显示进度条 = true
    var body: some View {
        VStack {
            if 显示进度条 {
                ProgressView(value: viewModel.progress)
                    .progressViewStyle(.linear)
                    .animation(.default, value: viewModel.progress)
                    .transition(.move(edge: .top))
            }
            WebView(url: 网页, viewModel: viewModel)
                .onChange(of: viewModel.progress, perform: { 进度 in
                    if 进度 == 1 {
                        withAnimation(.default, {
                            显示进度条 = false
                        }
                        )
                    }
                })
            
        }
    }
}


extension View {
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    ///
    ///     Text("Label")
    ///         .isHidden(true)
    ///
    /// Example for complete removal:
    ///
    ///     Text("Label")
    ///         .isHidden(true, remove: true)
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
    
}



struct WebView: UIViewRepresentable {
    
    let url: URL
    @ObservedObject var viewModel: ProgressViewModel
    
    private let webView = WKWebView()
    
    func makeUIView(context: Context) -> WKWebView {
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}
extension WebView {
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, viewModel: viewModel)
    }
    
    class Coordinator: NSObject {
        private var parent: WebView
        private var viewModel: ProgressViewModel
        private var observer: NSKeyValueObservation?
        
        init(_ parent: WebView, viewModel: ProgressViewModel) {
            self.parent = parent
            self.viewModel = viewModel
            super.init()
            
            observer = self.parent.webView.observe(\.estimatedProgress) { [weak self] webView, _ in
                guard let self = self else { return }
                self.parent.viewModel.progress = webView.estimatedProgress
            }
        }
        
        deinit {
            observer = nil
        }
    }
}
extension WebView {
    class ProgressViewModel: ObservableObject {
        @Published var progress: Double = 0.0
        
        init (progress: Double) {
            self.progress = progress
        }
    }
}
