//
//  RubyWidgetPlugin.h
//  RubyWidget
//
//  Created by Olexandr Prokhorenko on 4/24/09.
//  Copyright prokhorenko.us 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface RubyWidgetPlugin : NSObject {
}

// JavaScript-ready methods
- (NSString *) web_doRuby:(NSString *)call;

@end
