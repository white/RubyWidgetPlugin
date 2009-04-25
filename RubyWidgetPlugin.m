//
//  RubyWidgetPlugin.m
//  RubyWidget
//
//  Created by Olexandr Prokhorenko on 4/24/09.
//  Copyright prokhorenko.us 2009. All rights reserved.
//

#import "RubyWidgetPlugin.h"
#import <MacRuby/MacRuby.h>

@implementation RubyWidgetPlugin

#pragma mark WidgetPlugin

#pragma mark *** WidgetPlugin ***

// initWithWebView is called as the Dashboard widget and its WebView
// are initialized, which is when the widget plug-in is loaded
// This is just an object initializer; DO NOT use the passed WebView
// to manipulate WebScriptObjects or anything in the WebView's hierarchy
- (id) initWithWebView:(WebView*)webView {
    self = [super init];
    return self;
}

#pragma mark *** WebScripting ***

// windowScriptObjectAvailable passes the JavaScript window object referring
// to the plug-in's parent window (in this case, the Dashboard widget)
// We use that to register our plug-in as a var of the window object;
// This allows the plug-in to be referenced from JavaScript via 
// window.<plugInName>, or just <plugInName>
- (void) windowScriptObjectAvailable:(WebScriptObject*)webScriptObject {
    [webScriptObject setValue:self forKey:@"RubyWidgetPlugin"];
}

// Prevent direct key access from JavaScript
// Write accessor methods and expose those if necessary
+ (BOOL) isKeyExcludedFromWebScript:(const char*)key {
    return YES;
}

// Used for convenience of WebScripting names below
NSString * const kWebSelectorPrefix = @"web_";

// This is where prefixing our JavaScript methods with web_ pays off:
// instead of a huge if/else trail to decide which methods to exclude,
// just check the selector names for kWebSelectorPrefix
+ (BOOL) isSelectorExcludedFromWebScript:(SEL)aSelector {
    return !([NSStringFromSelector(aSelector) hasPrefix:kWebSelectorPrefix]);
}

// Another simple implementation: take the first token of the Obj-C method signature
// and remove the web_ prefix. 
+ (NSString *) webScriptNameForSelector:(SEL)aSelector {
    NSString*    selName = NSStringFromSelector(aSelector);
	
    if ([selName hasPrefix:kWebSelectorPrefix] && ([selName length] > [kWebSelectorPrefix length])) {
        return [[[selName substringFromIndex:[kWebSelectorPrefix length]] componentsSeparatedByString: @":"] objectAtIndex: 0];
    }
    return nil;
}

#pragma mark *** JavaScript Exposed ***

- (NSString *) web_doRuby:(NSString *)call {
	NSLog(@"doRuby");
	
	NSString *result = call;
	
	@try {
		id object;
			
		object = [[MacRuby sharedRuntime] evaluateString:[call string]];
		result = [object description];
	}
	@catch (NSException *exception) {
		NSString *string = [NSString stringWithFormat:@"%@: %@\n%@", [exception name], [exception reason], 
							[[[exception userInfo] objectForKey:@"backtrace"] description]];
		result = string;
	}
	
	return result;
}

@end
