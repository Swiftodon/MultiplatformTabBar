//
//  MultiplatfromTabBar.swift
//  Stuff To Buy
//
//  Created by Kevin Mullins on 4/30/21.
//

import Foundation
import SwiftUI
import SwiftletUtilities

/**
 Extends color to support the `MultiplatformTabBar`.
 */
public extension Color {
  
#if os(macOS)
  /// Holds the standard window background color.
  static let backgroundColor = Color(NSColor.windowBackgroundColor)
  
  /// Holds the standard control background color.
  static let secondaryBackgroundColor = Color(NSColor.controlBackgroundColor)
#else
  /// Holds the standard window background color.
  static let backgroundColor = Color(UIColor.systemBackground)
  
  /// Holds the standard control background color.
  static let secondaryBackgroundColor = Color(UIColor.secondarySystemBackground)
#endif
}

/**
 Creates a common Tab Bar control that runs and looks the same across multiple devices and OS (iOS, iPadOS, macOS & tvOS).
 
 ## Example:
 ```swift
 MultiplatformTabBar(tabPosition: .top, barHorizontalAlignment: .center)
 .tab(title: "Tab 1", icon: Image(systemName: "tray.fill")) {
 VStack {
 Text("Body of Tab 1")
 }
 }
 .tab(title: "Tab 2", icon: Image(systemName: "tray.fill")) {
 VStack {
 Text("Body of Tab 1")
 }
 }
 .tab(title: "Tab 3", icon: Image(systemName: "tray.fill")) {
 VStack {
 Text("Body of Tab 1")
 }
 }
 ```
 
 - Remark: This tool works great for creating a **Settings** page for the macOS build of a multiplatform SwiftUI project.
 */
public struct MultiplatformTabBar: View {
  // MARK: - Properties
  
  /// Defines the location of the Tab Bar.
  public var tabPosition:MultiplatformTabViewPosition = .top
  
  /// Defines the vertical alignment of the Tab Bar.
  public var barVerticalAlignment: MultiplatformTabBarVerticalAlignment = .center
  
  /// Defines the horizontal alignment of the Tab Bar.
  public var barHorizontalAlignment: MultiplatformTabBarHorizontalAlignment = .center
  
  /// Holds the currently selected tab bar.
  @State private var selection = 0
  
  /// Holds the collection of tabs being presented.
  @ObservedObject public var tabSet:MultiplatformTabCollection = MultiplatformTabCollection()
    
  private var buttonSize: CGSize
  
  // MARK: - Initializers
  
  /// Creates a new instance of the object.
  public init() {
    buttonSize = CGSize(width: 52, height: 52)
  }
  
  
  /// Creates a new instance of the object with the given properties
  /// - Parameters:
  ///   - tabPosition: The Tab Bar position.
  ///   - barVerticalAlignment: The Tab Bar's vertical alignment.
  ///   - barHorizontalAlignment: The Tab Bar's horizontal alignment.
  public init(tabPosition:MultiplatformTabViewPosition = .top, barVerticalAlignment: MultiplatformTabBarVerticalAlignment = .center, barHorizontalAlignment: MultiplatformTabBarHorizontalAlignment = .center, buttonSize: CGSize = CGSize(width: 52, height: 52)) {
    // Initialize
    self.tabPosition = tabPosition
    self.barVerticalAlignment = barVerticalAlignment
    self.barHorizontalAlignment = barHorizontalAlignment
    self.buttonSize = buttonSize
  }
  
  // MARK: - Functions
  
  /// Generates a horizontal Tab Bar.
  private var barHorizontal: some View {
    VStack {
      HStack {
        if barHorizontalAlignment == .center || barHorizontalAlignment == .right {
          Spacer()
        }
        ForEach(0..<tabSet.tabs.count, id: \.self) { index in
          RoundedRectangle(cornerRadius: 10)
            .fill(self.selection == index ? Color.secondaryBackgroundColor : Color.red.opacity(0.0))
            .overlay(
              tabSet.tabs[index]
            )
            .frame(width: buttonSize.width, height: buttonSize.height)
            .padding(0)
            .foregroundColor(self.selection == index ? Color.accentColor : Color.primary)
            .onTapGesture {
              self.selection = index
            }
        }
        if barHorizontalAlignment == .center || barHorizontalAlignment == .left {
          Spacer()
        }
      }
      
      Divider()
    }
    .padding(0)
  }
  
  /// Generates a vertical Tab Bar.
  private var barVertical: some View {
    HStack {
      VStack {
        if barVerticalAlignment == .center || barVerticalAlignment == .bottom {
          Spacer()
        }
        ForEach(0..<tabSet.tabs.count, id: \.self) { index in
          RoundedRectangle(cornerRadius: 10)
            .fill(self.selection == index ? Color.secondaryBackgroundColor : Color.red.opacity(0.0))
            .overlay(
              tabSet.tabs[index]
            )
            .frame(width: buttonSize.width, height: buttonSize.height)
            .padding(0)
            .foregroundColor(self.selection == index ? Color.accentColor : Color.primary)
            .onTapGesture {
              self.selection = index
            }
        }
        if barVerticalAlignment == .center || barVerticalAlignment == .top {
          Spacer()
        }
      }
      Divider()
    }
    .padding(0)
  }
  
  /// Generates the body of the Tab Bar and the contents of the currently selected tab.
  public var body: some View {
    
    switch tabPosition {
      case .top:
        VStack(spacing: 0) {
          barHorizontal
            .padding(.vertical, 5)
          
          if tabSet.tabs.count > 0 {
            tabSet.tabs[selection].contents
              .padding(0)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
        }
        .padding(0)
      case .bottom:
        VStack(spacing: 0) {
          if tabSet.tabs.count > 0 {
            tabSet.tabs[selection].contents
              .padding(0)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
          
          barHorizontal
            .padding(.vertical, 5)
        }
        .padding(0)
      case .left:
        HStack(spacing: 0) {
          barVertical
                .padding(.all, 5)
          
          if tabSet.tabs.count > 0 {
            tabSet.tabs[selection].contents
              .padding(0)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
        }
        .padding(0)
      case .right:
        HStack(spacing: 0) {
          if tabSet.tabs.count > 0 {
            tabSet.tabs[selection].contents
              .padding(0)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
          
          barVertical
            .padding(.all, 5)
        }
        .padding(0)
    }
  }
  
  
  /// Adds a new tab to the Tab Bar.
  /// - Parameter newTab: The new tab to add as a `MultiplatformTab`.
  /// - Returns: The parent `MultiplatformTabBar`.
  @discardableResult public func tab(_ newTab:MultiplatformTab) -> MultiplatformTabBar {
    
    // Add tab to collection
    tabSet.tabs.append(newTab)
    
    // Return self so the definitions can be chained.
    return self
  }
  
  
  /// Adds a new tab to the bar with the given properties.
  /// - Parameters:
  ///   - title: The title of the tab.
  ///   - icon: The icon for the tab.
  ///   - tag: An optional tag for the tab.
  ///   - content: The body of the page that will be displayed when the tab is selected in SwiftUI.
  /// - Returns: The parent `MultiplatformTabBar`.
  @discardableResult public func tab<Content: View>(title:String = "", icon:Image, tag:String = "", @ViewBuilder content: () -> Content) -> MultiplatformTabBar {
    
    // Add tab to collection
    tabSet.tabs.append(MultiplatformTab(title: title, icon: icon, tag: tag, contents: AnyView(content())))
    
    // Return self so the definitions can be chained.
    return self
  }
}
