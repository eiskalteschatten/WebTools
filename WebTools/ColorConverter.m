//
//  ColorConverter.m
//  WebTools
//
//  Created by Alex Seifert on 9/7/14.
//  Copyright (c) 2014 Alex Seifert. All rights reserved.
//

#import "ColorConverter.h"

@implementation ColorConverter

- (IBAction)convertColor:(id)sender {
    NSString *toConvert;
    NSString *finalRgb;
    NSString *finalHex;
    NSResponder *firstResponder = [[NSApp keyWindow] firstResponder];

    if ([firstResponder isKindOfClass:[NSTextView class]] && [(NSTextView *)firstResponder delegate] == _rgbText) {
        toConvert = [_rgbText stringValue];
        
        if ([toConvert isNotEqualTo:@""]) {
            NSArray *rgbParts;
            
            if ([toConvert rangeOfString:@", "].location != NSNotFound) {
                rgbParts = [toConvert componentsSeparatedByString:@", "];
            }
            else {
                rgbParts = [toConvert componentsSeparatedByString:@","];
            }
            
            if ([rgbParts count] == 3) {
                NSString *r = [self toHex:[rgbParts[0] intValue]];
                NSString *g = [self toHex:[rgbParts[1] intValue]];
                NSString *b = [self toHex:[rgbParts[2] intValue]];
                
                finalHex = [NSString stringWithFormat:@"#%@%@%@", r, g, b];
                [_hexText setStringValue:finalHex];
            }
            else {
                NSString *error = @"Could not convert RGB to Hex. There were not 3 components given!\n\n";
                [_logView insertIntoLog:error];
                NSLog(error);
            }
        }
    }
    else if ([firstResponder isKindOfClass:[NSTextView class]] && [(NSTextView *)firstResponder delegate] == _hexText) {
        toConvert = [_hexText stringValue];
        
        if ([toConvert isNotEqualTo:@""]) {
            toConvert = [toConvert stringByReplacingOccurrencesOfString:@"#" withString:@""];
            
            if ([toConvert length] == 6) {
                NSString *r = [self fromHex:[toConvert substringWithRange:NSMakeRange(0, 2)]];
                NSString *g = [self fromHex:[toConvert substringWithRange:NSMakeRange(2, 2)]];
                NSString *b = [self fromHex:[toConvert substringWithRange:NSMakeRange(4, 2)]];
            
                finalRgb = [NSString stringWithFormat:@"%@, %@, %@", r, g, b];
                [_rgbText setStringValue:finalRgb];
            }
            else {
                NSString *error = @"Could not convert Hex to RGB. The hex is not 6 characters!\n\n";
                [_logView insertIntoLog:error];
                NSLog(error);
            }
        }
    }
}

- (NSString*)toHex:(NSInteger)number {
    NSString *value;
    NSString *values = @"0123456789ABCDEF";
    
    if (number > 255) {
        number = 255;
    }
    else if (number < 0) {
        number = 0;
    }
    
    NSInteger firstValue = (number - number % 16) / 16;
    NSInteger secondValue = number % 16;
    
    unichar firstChar = [values characterAtIndex:firstValue];
    unichar secondChar = [values characterAtIndex:secondValue];
    
    value = [NSString stringWithFormat:@"%c%c", firstChar, secondChar];
    
    return value;
}

- (NSString*)fromHex:(NSString*)number {
    NSString *value;
    
    unsigned int outValue;
    NSScanner* scanner = [NSScanner scannerWithString:number];
    [scanner scanHexInt:&outValue];
    
    value = [NSString stringWithFormat:@"%u", outValue];
    
    return value;
}

- (IBAction)setColorFromColorWell:(id)sender {
    //[someObjectWhoseColorYouWantToChange setColor:[sender color]];
    
    [[NSApp keyWindow] makeFirstResponder:_rgbText];
    
//    NSColor *color = [sender color];
    
    //[self convertColor:nil];
}

- (void)colorUpdate:(NSColorPanel*)colorPanel {
    NSColor* color = colorPanel.color;
   
    CGFloat red = [color redComponent];
    CGFloat green = [color greenComponent];
    CGFloat blue = [color blueComponent];
    
    NSString *rgb = [NSString stringWithFormat:@"%f, %f, %f", red, green, blue];
}

@end
