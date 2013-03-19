//
//  TechnologyFlashcardViewController.m
//  Technology Flashcard Game
//
//  Created by Sean Fitzgerald on 2/20/13.
//  Copyright (c) 2013 EiE. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TechnologyFlashcardViewController.h"
#import "FlashcardView.h"
#import "Flashcard.h"
#import "Constants.h"


//
//MACROS HERE!!!
//
//changes these and they will affect the view and layout of the app
//

#pragma mark - Interface/Properties

@interface TechnologyFlashcardViewController ()

#pragma mark - VIEW

@property (weak, nonatomic) IBOutlet UIButton *notTechnologyButton;
@property (weak, nonatomic) IBOutlet UIButton *isTechnologyButton;
@property (weak, nonatomic) IBOutlet FlashcardView *currentFlashcardView;
@property (weak, nonatomic) IBOutlet UIProgressView *deckProgressView;
@property (nonatomic) CGRect cardOnScreenFrame;
@property (weak, nonatomic) IBOutlet UILabel *isThisTechnologyLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *technologyQuestionLabel;
@property (weak, nonatomic) IBOutlet UILabel *technologyExplanationLabel;
@property (weak, nonatomic) IBOutlet UIButton *startGameButton;

#pragma mark - MODEL

@property (strong, nonatomic) NSArray * technologyDeck;
@property (nonatomic) NSInteger indexOfCurrentCard;


@end


#pragma mark - Implementation

@implementation TechnologyFlashcardViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
			
	self.technologyDeck = [self updateTechnologyFlashcardArray];
		
}

-(void) viewDidLayoutSubviews
{
	[self setupButtons];
	[self setupView];

}

#pragma mark - Setup Methods

-(void) setupGameAndStart
{
	self.indexOfCurrentCard = 0;
	
	self.currentFlashcardView.imageFaceUp = YES;
	self.currentFlashcardView.hidden = NO;
	//turn the flashcard on and put it correctly up
	
	self.isTechnologyButton.hidden = NO;
	self.notTechnologyButton.hidden = NO;
	self.deckProgressView.hidden = NO;
	self.isThisTechnologyLabel.hidden = NO;
	//reveal all the game views
	
	self.currentFlashcardView.currentFlashcard = self.technologyDeck[self.indexOfCurrentCard];
	//set the correct card to the model
	
	self.currentFlashcardView.center = CGPointMake(self.cardOnScreenFrame.size.width + self.view.bounds.size.width, self.currentFlashcardView.center.y);
	[UIView animateWithDuration:0.5
									 animations:^(void){
										 self.currentFlashcardView.frame = self.cardOnScreenFrame;
									 }];
	
}

-(void) setupView
{
	//background color?
	if (!BACKGROUND_USE_UNDERPAGE_COLOR)
		[self.view setBackgroundColor:[UIColor colorWithRed:BACKGROUND_RED green:BACKGROUND_GREEN blue:BACKGROUND_BLUE alpha:1]];
	else
		[self.view setBackgroundColor:[UIColor underPageBackgroundColor]];
	
	self.cardOnScreenFrame = CGRectMake(self.currentFlashcardView.frame.origin.x, self.currentFlashcardView.frame.origin.y, self.currentFlashcardView.frame.size.width, self.currentFlashcardView.frame.size.height);
}
/*
#pragma mark Button Setup Methods


-(void) addLightGradientToButton: (UIButton *) button
{
	button.imageView.contentMode = UIViewContentModeScaleToFill;
	//this is so the gradient fills the button
	CAGradientLayer *buttonLayer = [CAGradientLayer layer];
	NSArray *colors = [NSArray arrayWithObjects:
										 (id)[UIColor colorWithWhite:255.0f / 255.0f alpha:BUTTON_GRADIENT_AMOUNT].CGColor,
										 (id)[UIColor colorWithWhite:255.0f / 255.0f alpha:0.0f].CGColor,
										 nil];
	[buttonLayer setColors:colors];
	[buttonLayer setFrame:button.bounds];
	[button.layer insertSublayer:buttonLayer atIndex:0];
	//create and add the gradient
	return;
}

-(void) addDarkGradientToButton: (UIButton *) button
{
	button.imageView.contentMode = UIViewContentModeScaleToFill;
	//this is so the gradient fills the button

	CAGradientLayer *buttonLayer = [CAGradientLayer layer];
	NSArray *colors = [NSArray arrayWithObjects:
										 (id)[UIColor colorWithWhite:0.0f / 255.0f alpha:BUTTON_PRESSED_GRADIENT_AMOUNT].CGColor,
										 (id)[UIColor colorWithWhite:0.0f / 255.0f alpha:0.0f].CGColor,
										 nil];
	[buttonLayer setColors:colors];
	[buttonLayer setFrame:button.bounds];
	[button.layer insertSublayer:buttonLayer atIndex:0];
	//create and add the gradient
	return;
}

-(void) setupBorderWithButton:(UIButton *) button
{
	const CGFloat* components = CGColorGetComponents(button.backgroundColor.CGColor);
	button.layer.borderColor = [[[UIColor alloc] initWithRed:components[0] * BUTTON_BORDER_DARKNESS
																										 green:components[1] * BUTTON_BORDER_DARKNESS
																											blue:components[2] * BUTTON_BORDER_DARKNESS
																										 alpha:CGColorGetAlpha(button.backgroundColor.CGColor)] CGColor];
	button.layer.borderWidth = BUTTON_BORDER_THICKNESS;

}
*/
- (void) setupButtons
{
	
	[self.isTechnologyButton setBackgroundColor:[UIColor colorWithRed:0 green:200.0f/255.0f blue:0 alpha:1]];
	[self.notTechnologyButton setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:173.0f/255.0f blue:0 alpha:1]];
	[self.nextButton setBackgroundColor:[UIColor colorWithRed:150.0f/255.0f green:0/255.0f blue:255.0f / 255.0f alpha:1]];
	[self.startGameButton setBackgroundColor:[UIColor colorWithRed:255.0f / 255.0f
																													 green:0.0f / 255.0f
																														blue:0.0f / 255.0f
																													 alpha:1.0f]];
	//set the background color
	/*
	
	for (UIButton * button in @[self.isTechnologyButton, self.notTechnologyButton, self.nextButton, self.startGameButton])
	{
		button.clipsToBounds = YES;
		
		[button addTarget:self action:@selector(buttonHighlighted:) forControlEvents:UIControlEventTouchDown];
		[button addTarget:self action:@selector(buttonNotHighlighted:) forControlEvents:UIControlEventTouchDragExit];
		//this allows the button to fire on the appropriate selection methods
				
		[button.layer setCornerRadius:BUTTON_CORNER_RADIUS];
		//set the corner radius
		
		[self addLightGradientToButton:button];
		
		[self setupBorderWithButton:button];
		//add the border color and thickness
		
		[button setTitleColor:button.currentTitleColor forState:UIControlStateHighlighted];
		
	}
	
	 */
	 
}

#pragma mark - Getters and Setters

-(NSArray *) technologyDeck
{
	if (!_technologyDeck)
		_technologyDeck = [[NSArray alloc] init];
	
	return _technologyDeck;
}

#pragma mark - Button Actions
- (IBAction)startGame:(UIButton *)sender
{
	[self setupGameAndStart];
	sender.hidden = YES;
}

//Not Technology has been pressed
- (IBAction)notTechnologyButtonPress
{
	if ([(Flashcard *)(self.technologyDeck[self.indexOfCurrentCard]) isTechnology])
		[self showAnswerCorrect];
	else [self showAnswerIncorrect];
	
	self.isTechnologyButton.hidden = YES;
	self.notTechnologyButton.hidden = YES;
	self.nextButton.hidden = NO;
	self.technologyQuestionLabel.hidden = YES;
	//turn the answer buttons off. turn the next button on. The kid has answered the question.
	
	///////////////////////////[self buttonNotHighlighted:self.notTechnologyButton];
	//create and add the unhighlighted gradient
	
}

//"is" technology button pressed
- (IBAction)technologyButtonPressed
{
	if ([(Flashcard *)(self.technologyDeck[self.indexOfCurrentCard]) isTechnology])
		[self showAnswerCorrect];
	else [self showAnswerIncorrect];
	
	self.isTechnologyButton.hidden = YES;
	self.notTechnologyButton.hidden = YES;
	self.nextButton.hidden = NO;
	self.technologyQuestionLabel.hidden = YES;
	//turn the answer buttons off. turn the next button on. The kid has answered the question.

	///////////////////////////[self buttonNotHighlighted:self.isTechnologyButton];
	//create and add the unhighlighted gradient
	
}

- (IBAction)nextButtonPressed
{
		self.currentFlashcardView.currentFlashcard = self.technologyDeck[++self.indexOfCurrentCard];
	//increment and update the image on the card
	
	self.isTechnologyButton.hidden = NO;
	self.notTechnologyButton.hidden = NO;
	self.nextButton.hidden = YES;
	self.technologyQuestionLabel.hidden = NO;
	// turn the answer buttons back on for the next question. turnt he next button off
	
	///////////////////////////[self buttonNotHighlighted:self.nextButton];
	//create and add the unhighlighted gradient
	
	[UIView animateWithDuration:0.3
									 animations:^(void){
										 self.currentFlashcardView.center = CGPointMake(-self.currentFlashcardView.center.x, self.currentFlashcardView.center.y);
									 }completion:^(BOOL finished) {
										 
										 self.currentFlashcardView.center = CGPointMake(self.cardOnScreenFrame.size.width + self.view.bounds.size.width, self.currentFlashcardView.center.y);
										 //move the flashcard offscreen right
										 self.currentFlashcardView.imageFaceUp = YES;
										 [UIView animateWithDuration:0.3
																			animations:^(void){
																				self.currentFlashcardView.frame = self.cardOnScreenFrame;
																			}];
										 //animate it back on

									 }];
	
	
}

#pragma mark - Change The View

/*
 -(void) buttonHighlighted:(UIButton *) button
{
	[button.layer.sublayers[0] removeFromSuperlayer];
	[self addDarkGradientToButton:button];
	//create and add the gradient
}

-(void) buttonNotHighlighted:(UIButton *) button
{
	[button.layer.sublayers[0] removeFromSuperlayer];
	[self addLightGradientToButton:button];
	//create and add the gradient
}
*/

-(void) showAnswerCorrect
{
	self.currentFlashcardView.isCorrect = YES;
	[self flipCard];
}

-(void) showAnswerIncorrect
{
	self.currentFlashcardView.isCorrect = NO;
	[self flipCard];
}

-(void) flipCard
{
	[UIView transitionWithView:self.currentFlashcardView
										duration:.5
										 options:UIViewAnimationOptionTransitionFlipFromRight
									animations:^{
										self.currentFlashcardView.isCorrect = YES;
										self.currentFlashcardView.imageFaceUp = NO;
									}
									completion:NULL];
}

-(NSArray *)updateTechnologyFlashcardArray
{
	__block NSMutableArray * arrayOfCards = [[NSMutableArray alloc] init];
	__block Flashcard * currentCard;
	
	NSString* path = [[NSBundle mainBundle] pathForResource:@"IsThePictureTechnology"
																									 ofType:@"txt"];
	NSString* content = [NSString stringWithContentsOfFile:path
																								encoding:NSUTF8StringEncoding
																									 error:NULL];
	[content enumerateSubstringsInRange:NSMakeRange(0, [content length])
															options:NSStringEnumerationByWords
													 usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
														 if ([substring isEqualToString:@"YES"])
														 {
															 currentCard.isTechnology = YES;
															 [arrayOfCards addObject:currentCard];
														 }
														 else if ([substring isEqualToString:@"NO"])
														 {
															 currentCard.isTechnology = NO;
															 [arrayOfCards addObject:currentCard];
														 }
														 else
														 {
															 currentCard = [[Flashcard alloc] init];
															 currentCard.flashcardImageName = substring;
														 }
													 }];
	
	return [arrayOfCards copy];
}

#pragma mark - Timer Methods

@end
