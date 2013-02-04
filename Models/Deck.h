//
//  Deck.h
//  Matchismo
//
//  Created by Paul Schneller on 02.02.13.
//  Copyright (c) 2013 Paul Schneller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (Card *)drawRandomCard;

@end
