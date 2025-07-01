//
//  Scaler.swift
//  Stroll
//
//  Created by William Kindlien Gunawan on 01/07/25.
//

import SwiftUI

// MARK: - Screen Size Helper
extension UIScreen {
    static var screenWidth: CGFloat { main.bounds.width }
    static var screenHeight: CGFloat { main.bounds.height }
}

// MARK: - Figma Scaling Extension
extension CGFloat {
    /// Scales value based on Figma design dimensions
    func scaled(from figmaScreenWidth: CGFloat = 375) -> CGFloat {
        (self / figmaScreenWidth) * UIScreen.screenWidth
    }
}

// MARK: - SwiftUI View Extensions
extension View {
    // MARK: - Font Scaling
    func figmaFont(
        _ fontSize: CGFloat,
        designWidth: CGFloat = 375,
        weight: Font.Weight = .regular,
        design: Font.Design = .default
    ) -> some View {
        let scaledSize = fontSize.scaled(from: designWidth)
        return self.font(.system(size: scaledSize, weight: weight, design: design))
    }

    // MARK: - Frame Scaling
    func figmaFrame(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        minWidth: CGFloat? = nil,
        maxWidth: CGFloat? = nil,
        minHeight: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        designWidth: CGFloat = 375
    ) -> some View {
        var view = AnyView(self)

        if let minWidth = minWidth?.scaled(from: designWidth),
           let idealWidth = width?.scaled(from: designWidth),
           let maxWidth = maxWidth?.scaled(from: designWidth) {
            view = AnyView(view.frame(minWidth: minWidth, idealWidth: idealWidth, maxWidth: maxWidth))
        } else if let width = width?.scaled(from: designWidth),
                  let height = height?.scaled(from: designWidth) {
            view = AnyView(view.frame(width: width, height: height))
        } else if let width = width?.scaled(from: designWidth) {
            view = AnyView(view.frame(width: width))
        } else if let height = height?.scaled(from: designWidth) {
            view = AnyView(view.frame(height: height))
        }

        if let minHeight = minHeight?.scaled(from: designWidth),
           let maxHeight = maxHeight?.scaled(from: designWidth) {
            view = AnyView(view.frame(minHeight: minHeight, maxHeight: maxHeight))
        }

        return view
    }

    // MARK: - Padding Scaling
    func figmaPadding(
        _ edges: Edge.Set = .all,
        _ length: CGFloat,
        designWidth: CGFloat = 375
    ) -> some View {
        self.padding(edges, length.scaled(from: designWidth))
    }

    // MARK: - Offset Scaling
    func figmaOffset(
        x: CGFloat = 0,
        y: CGFloat = 0,
        designWidth: CGFloat = 375
    ) -> some View {
        self.offset(
            x: x.scaled(from: designWidth),
            y: y.scaled(from: designWidth)
        )
    }

    // MARK: - Corner Radius Scaling
    func figmaCornerRadius(
        _ radius: CGFloat,
        designWidth: CGFloat = 375
    ) -> some View {
        self.cornerRadius(radius.scaled(from: designWidth))
    }

    // MARK: - Spacing Helper (for Stack views)
    func figmaSpacing(
        _ spacing: CGFloat,
        designWidth: CGFloat = 375
    ) -> some View {
        environment(\.layoutSpacing, spacing.scaled(from: designWidth))
    }
}

// MARK: - Environment Value for Spacing
private struct LayoutSpacing: EnvironmentKey {
    static let defaultValue: CGFloat? = nil
}

extension EnvironmentValues {
    var layoutSpacing: CGFloat? {
        get { self[LayoutSpacing.self] }
        set { self[LayoutSpacing.self] = newValue }
    }
}

// MARK: - Custom Stack with Scaled Spacing
struct FigmaVStack<Content: View>: View {
    @Environment(\.layoutSpacing) private var spacing
    let content: Content

    init(spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(spacing: spacing) {
            content
        }
    }
}

struct FigmaHStack<Content: View>: View {
    @Environment(\.layoutSpacing) private var spacing
    let content: Content

    init(spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        HStack(spacing: spacing) {
            content
        }
    }
}
