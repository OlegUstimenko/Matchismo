//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Paul Schneller on 03.02.13.
//  Copyright (c) 2013 Paul Schneller. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (readwrite, nonatomic) int score;
@property (readwrite, nonatomic) NSString *status;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i<cardCount; i++) {
            Card *card = [deck drawRandomCard];
            if (!card)
                self = nil;
            else
                self.cards[i] = card;
            
        }
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index]: nil;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_PENALTY 1

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isUplayable) {
        self.status = nil;
        if (!card.isFaceUp) {
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUplayable) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        otherCard.unplayable = YES;
                        card.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                        self.status = [NSString stringWithFormat:@"Matched %@ & %@ for %d points", card.contents, otherCard.contents, matchScore * MATCH_BONUS];
                    } else {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        self.status = [NSString stringWithFormat:@"%@ & %@ don't match. Penalty %d points", card.contents, otherCard.contents, MISMATCH_PENALTY];
                    }
                    break;
                }
            }
            self.score -= FLIP_PENALTY;
        }
        card.faceUp = !card.isFaceUp;
        if (!self.status) {
            self.status = [NSString stringWithFormat:@"Flipped %@", card.contents];
        }
    }
}

//new method for matching 3 cards
- (void)flipCardAtIndex2:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];

    if (!card.isUplayable) {
        self.status = nil;
        if (!card.isFaceUp) {
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUplayable) {
                    for (Card *otherCard2 in self.cards) {
                        if (![otherCard.contents isEqualToString:otherCard2.contents] && otherCard2.isFaceUp && !otherCard2.isUplayable) {
                            int matchScore = [card match:@[otherCard, otherCard2]];
                            if (matchScore) {
                                otherCard.unplayable = YES;
                                otherCard2.unplayable = YES;
                                card.unplayable = YES;
                                self.score += matchScore * MATCH_BONUS;
                                self.status = [NSString stringWithFormat:@"Matched %@ & %@ & %@ for %d points", card.contents, otherCard.contents, otherCard2.contents, matchScore * MATCH_BONUS];
                            } else {
                                otherCard.faceUp = NO;
                                otherCard2.faceUp = NO;
                                self.score -= MISMATCH_PENALTY;
                                self.status = [NSString stringWithFormat:@"%@ & %@ & %@ don't match. Penalty %d points", card.contents, otherCard.contents, otherCard2.contents, MISMATCH_PENALTY];
                            }
                            break;
                        }
                    }
                }
            }
            self.score -= FLIP_PENALTY;
        }
        card.faceUp = !card.isFaceUp;
        if (!self.status) {
            self.status = [NSString stringWithFormat:@"Flipped %@", card.contents];
        }
    }
}

@end
