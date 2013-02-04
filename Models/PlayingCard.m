//
//  PlayingCard.m
//  Matchismo
//
//  Created by Paul Schneller on 02.02.13.
//  Copyright (c) 2013 Paul Schneller. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if (otherCards.count == 1) {
        PlayingCard *otherCard = [otherCards lastObject];
        //match suit = 1 point
        if ([otherCard.suit isEqualToString:self.suit]) {
            score = 1;
        }
        //match rank = 4 points
        if (otherCard.rank == self.rank) {
            score = 4;
        }
    }

    
    //Points:
    // 3 ranks = 36 points
    // 2 ranks + 2 suits = 16 points
    // 2 ranks = 12 points
    // 3 suits = 12 points
    // 2 suits = 4 points
    if (otherCards.count == 2) {
        PlayingCard *otherCard = [otherCards objectAtIndex:0];
        PlayingCard *otherCard2 = [otherCards objectAtIndex:1];
        //match suit for first card 1 point
        if ([otherCard.suit isEqualToString:self.suit]) {
            score += 1;
        }
        if ([otherCard2.suit isEqualToString:self.suit]) {
            score += 1;
        }
        if ([otherCard2.suit isEqualToString:otherCard.suit]) {
            score += 1;
        }
        //match rank = 4 points
        if (otherCard.rank == self.rank) {
            score += 3;
        }
        if (otherCard2.rank == self.rank) {
            score += 3;
        }
        if (otherCard2.rank == otherCard.rank) {
            score += 3;
        }
    }
    
    return score;
}

-(NSString *) contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    return @[@"♠", @"♣", @"♥", @"♦"];
}

- (NSString *)suit;
{
    return _suit ? _suit : @"?";
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit])
        _suit = suit;
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"B", @"D", @"K"];
}

+ (NSUInteger)maxRank
{
    return [self rankStrings].count-1;
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
