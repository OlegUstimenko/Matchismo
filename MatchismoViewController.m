//
//  MatchismoViewController.m
//  Matchismo
//
//  Created by Paul Schneller on 02.02.13.
//  Copyright (c) 2013 Paul Schneller. All rights reserved.
//

#import "MatchismoViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface MatchismoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySegment;
@property (strong, nonatomic) IBOutlet UITextView *pointsTextView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (nonatomic) int flipsCount;

@property (strong, nonatomic) CardMatchingGame *game;

@end

@implementation MatchismoViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc]initWithCardCount:[self.cardButtons count]
                                                         usingDeck:[[PlayingCardDeck alloc]init]];
    return _game;
}

//only thing that is set outside of updateUI, just like in the lecture
- (void)setFlipsCount:(int)flipsCount
{
    _flipsCount = flipsCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipsCount];
}

//update the UI: set the cards and labels according to the model
- (void)updateUI
{
    UIImage *cardBackImage = [UIImage imageNamed:@"cardback.png"];
    UIImage *cardFrontImage = [UIImage imageNamed:@"cardfront.png"];
    
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        
        if (card.isFaceUp)
            [cardButton setBackgroundImage:cardFrontImage forState:UIControlStateNormal];
        else
            [cardButton setBackgroundImage:cardBackImage forState:UIControlStateNormal];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUplayable;
        cardButton.alpha = card.isUplayable ? 0.3 : 1.0;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
    if (self.game.status)
        self.statusLabel.text = [NSString stringWithFormat:@"%@",self.game.status];
    else {
        if (self.difficultySegment.selectedSegmentIndex == 0)
            self.statusLabel.text = @"Have fun matching 2 cards!";
        else
            self.statusLabel.text = @"Have fun matching 3 cards!";
    }
    
    //show&hide difficultySegment/pointsTextView
    if (self.difficultySegment.hidden == NO)
        self.difficultySegment.hidden = YES;
    if (self.pointsTextView.hidden == YES)
        self.pointsTextView.hidden = NO;
}


- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

//the difficultySegment tells which flipCardAtIndex to use
- (IBAction)flipCard:(UIButton *)sender {
    if (self.difficultySegment.selectedSegmentIndex == 0) {
        [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    }
    else if (self.difficultySegment.selectedSegmentIndex == 1) {
        [self.game flipCardAtIndex2:[self.cardButtons indexOfObject:sender]];
    }
    self.flipsCount++;
    [self updateUI];
}

//start a new game
- (IBAction)newGame:(UIButton *)sender {
    self.game = nil;
    self.flipsCount = 0;
    [self updateUI];
    
    //show&hide difficultySegment/pointsTextView
    self.difficultySegment.hidden = NO;
    self.pointsTextView.hidden = YES;
}

//update statusLable according to difficulty
- (IBAction)changeDifficulty:(UISegmentedControl *)sender {
    if (self.difficultySegment.selectedSegmentIndex == 0)
        self.statusLabel.text = @"Have fun matching 2 cards!";
    else
        self.statusLabel.text = @"Have fun matching 3 cards!";
}

@end
