//
//  Application.swift
//  SwiftUI
//
//  Created by Alsey Coleman Miller on 4/20/19.
//

import Foundation
import SDL
import CSDL2

public final class Application {
    
    // MARK: - Initialization
    
    public static let shared = Application()
    
    private init() { }
    
    // MARK: - Properties
    
    public private(set) var window: Window?
    
    public var didLaunch: (() throws -> (Window)) = {
        return try Window(title: "",
                          frame: (x: .centered, y: .centered, width: 640, height: 480))
    }
    
    internal private(set) var isRunning = false
    
    public var windows: [Window] {
        return _windows.values()
    }
    
    internal private(set) var _windows = WeakArray<Window>()
    
    internal lazy var eventEnvironment = EventEnvironment()
    
    // MARK: - Methods
    
    public func run() throws {
        
        isRunning = true
        defer { isRunning = false }
        
        assert(Thread.current.isMainThread, "Should only be called from main thread")
        
        try SDL.initialize(subSystems: [.video])
        defer { SDL.quit() }
        
        window = try didLaunch()
        
        let runloop = RunLoop.current
        
        var sdlEvent = SDL_Event()
        
        while isRunning {
            
            let startTime = SDL_GetTicks()
            let frameStart = Date()
            
            // poll events
            var maximumFramesPerSecond = 1
            for window in windows {
                let framesPerSecond = try window.window.displayMode().refreshRate
                if framesPerSecond > maximumFramesPerSecond {
                    maximumFramesPerSecond = framesPerSecond
                }
            }
            
            let maximumFrameTime = UInt32(1000 / maximumFramesPerSecond)
            
            var shouldPoll = true
            while SDL_GetTicks() - startTime < maximumFrameTime, shouldPoll {
                shouldPoll = SDL_PollEvent(&sdlEvent) != 0
                eventEnvironment.recieveEvent(&sdlEvent)
            }
            eventEnvironment.dispatchEvents()
            
            // run main loop
            let maximumFrameDuration = 1.0 / TimeInterval(maximumFramesPerSecond)
            runloop.run(mode: .default, before: frameStart + maximumFrameDuration)
            
            // sleep to save energy
            let frameDuration = SDL_GetTicks() - startTime
            if frameDuration < maximumFrameTime {
                SDL_Delay(maximumFrameTime - frameDuration) // sleep for remainder of frame
            }
        }
    }
    
    internal func windowCreated(_ window: Window) {
        
        self._windows.append(window)
    }
    
    public func quit() {
        
        self.isRunning = false
    }
    
    internal func lowMemory() {
        
        for window in windows {
            window.lowMemory()
        }
    }
}
