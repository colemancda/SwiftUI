//
//  ViewController.swift
//  SwiftUI
//
//  Created by Alsey Coleman Miller on 6/18/19.
//

open class ViewController {
    
    // MARK: - Initialization
    
    public init() {
        
    }
    
    // MARK: - Properties
    
    public var view: View {
        
        loadViewIfNeeded()
        return _view! // should never be nil
    }
    
    internal private(set) var _view: View?
    public final var isViewLoaded: Bool { return _view != nil }
    
    /// A localized string that represents the view this controller manages.
    public final var title: String?
    
    // MARK: - Methods
    
    /// Called after the controller's view is loaded into memory.
    open func viewDidLoad() { /* Subclasses should override */ }
    
    /// Loads the view controller’s view if it has not yet been loaded.
    public final func loadViewIfNeeded() {
        
        if isViewLoaded == false {
            
            _view = loadView()
            _view?.viewController = self
            viewDidLoad()
        }
    }
    
    open func loadView() -> View {
        
        return View(frame: .zero)
    }
}
