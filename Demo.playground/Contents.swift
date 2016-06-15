//: Playground - noun: a place where people can play

import Foundation
import RouterX

//: Here I define some pattern

let pattern1 = "/articles(/page/:page(/per_page/:per_page))(/sort/:sort)(.:format)"
let pattern2 = "/articles/new"
let pattern3 = "/articles/:id"
let pattern4 = "/:article_id"

//: Initialize the router, I can give a default closure to handle while given a URI path but match no one.

// This is the handler that would be performed after no pattern match
let defaultUnmatchHandler = { (url: NSURL, context: AnyObject?) in
  // Do something here, e.g: give some tips or show a default UI
  print("\(url) is unmatched.")

  // context can be provided on matching patterns
  if let context = context as? String {
    print("Context is \"\(context)\"")
  }
}

// Initialize a router instance, consider it's global and singleton
let router = Router(defaultUnmatchHandler: defaultUnmatchHandler)

//: Register patterns, the closure is the handle when matched the pattern.

// Set a route pattern, the closure is a handler that would be performed after match the pattern
router.registerRoutingPattern(pattern: pattern1) { (url, parameters, context) in
  // Do something here, e.g: show a UI
  var string = "URL is \(url), parameter is \(parameters)"
  if let context = context as? String {
    string += " Context is \"\(context)\""
  }
  print(string)
}

router.registerRoutingPattern(pattern: pattern2) { _ in
  // Do something here, e.g: show a UI
  print("call new article")
}

//: Let match some URI Path.

// A case that should be matched
let path1 = "/articles/page/2/sort/recent.json?foo=bar&baz"

// It's will be matched, and perform the handler that we have set up.
router.matchURLPathAndDoHandler(urlPath: path1)
// It can pass the context for handler
router.matchURLPathAndDoHandler(urlPath: path1, context: "fooo")

// A case that shouldn't be matched
let path2 = "/articles/2/edit"

let customUnmatchHandler: UnmatchRouteHandler = { (url, context) in
  var string = "\(url) is no match..."
  // context can be provided on matching patterns
  if let context = context as? String {
    string += "Context is \"\(context)\""
  }

  print(string)
}
// It's will not be matched, and perform the default unmatch handler that we have set up
router.matchURLPathAndDoHandler(urlPath: path2)

// It can provide a custome unmatch handler to override the default, also can pass the context
router.matchURLPathAndDoHandler(urlPath: path2, context: "bar", unmatchHandler: customUnmatchHandler)
