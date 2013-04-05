//
//  TFGameViewController.m
//  Technology Flashcard Game
//
//  Created by Sean Fitzgerald on 3/14/13.
//  Copyright (c) 2013 EiE. All rights reserved.
//

#import "TFGameViewController.h"
#import "TFPostGameViewController.h"
#import "FlashcardView.h"
#import "Flashcard.h"
#import "TechnologyFlashcardGameButton.h"
#import "Constants.h"

#pragma mark - Interface/Properties
@interface TFGameViewController ()

#pragma mark - VIEW(self)
@property (nonatomic) CGRect cardOnScreenFrame;
@property (weak, nonatomic) IBOutlet UIProgressView *gameProgressView;
@property (weak, nonatomic) IBOutlet FlashcardView *currentFlashCardView;
@property (weak, nonatomic) IBOutlet UILabel *isThisTechnologyLabel;
@property (weak, nonatomic) IBOutlet TechnologyFlashcardGameButton *nextButton;
@property (weak, nonatomic) IBOutlet TechnologyFlashcardGameButton *yesTechnologyButton;
@property (weak, nonatomic) IBOutlet TechnologyFlashcardGameButton *noTechnologyButton;

#pragma mark - VIEW(flashcard)
@property (weak, nonatomic) IBOutlet UIImageView *correctImageView;
@property (weak, nonatomic) IBOutlet UILabel *correctLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;

#pragma mark - MODEL
@property (nonatomic) NSInteger indexOfCurrentCard;
@property (nonatomic) NSInteger numberCorrect;
@property (nonatomic) NSInteger numberCards;

@end

@implementation TFGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.numberCards = [self.technologyDeck count];
	
	self.numberCorrect = 0;
	self.gameProgressView.progress = self.numberCorrect / self.numberCards;
	self.cardNumberLabel.text = [NSString stringWithFormat:@"%d / %d", self.indexOfCurrentCard + 1, self.numberCards];
	
}

-(void) viewDidLayoutSubviews
{
	[self setupButtons];
	[self setupView];
	[self setupGameAndStart];
	
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	[super viewWillAppear:animated];
}

#pragma mark - Getters and Setters

-(NSArray *) technologyDeck
{
	if (!_technologyDeck)
		_technologyDeck = [[NSArray alloc] init];
	
	return _technologyDeck;
}

#pragma mark - Setup Methods

-(void) setupGameAndStart
{
	self.indexOfCurrentCard = 0;
	
	self.currentFlashCardView.imageFaceUp = YES;
	self.currentFlashCardView.hidden = NO;
	//turn the flashcard on and put it correctly up
	
	self.nextButton.hidden = YES;
	//turn the next button off for now
	
	self.currentFlashCardView.currentFlashcard = self.technologyDeck[self.indexOfCurrentCard];
	//set the correct card to the model
	
	self.currentFlashCardView.center = CGPointMake(self.cardOnScreenFrame.size.width + self.view.bounds.size.width, self.currentFlashCardView.center.y);
	[UIView animateWithDuration:0.5
									 animations:^(void){
										 self.currentFlashCardView.frame = self.cardOnScreenFrame;
									 }];
	
}

-(void) setupView
{
	//background color?
	if (!BACKGROUND_USE_UNDERPAGE_COLOR)
		[self.view setBackgroundColor:[UIColor colorWithRed:BACKGROUND_RED green:BACKGROUND_GREEN blue:BACKGROUND_BLUE alpha:1]];
	else
		[self.view setBackgroundColor:[UIColor underPageBackgroundColor]];
	
	self.cardOnScreenFrame = CGRectMake(self.currentFlashCardView.frame.origin.x, self.currentFlashCardView.frame.origin.y, self.currentFlashCardView.frame.size.width, self.currentFlashCardView.frame.size.height);
}

- (void) setupButtons
{
	
	[self.yesTechnologyButton setBackgroundColor:[UIColor colorWithRed:0 green:200.0f/255.0f blue:0 alpha:1]];
	[self.noTechnologyButton setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:173.0f/255.0f blue:0 alpha:1]];
	[self.nextButton setBackgroundColor:[UIColor colorWithRed:150.0f/255.0f green:0/255.0f blue:255.0f / 255.0f alpha:1]];
}

#pragma mark - Button Actions
- (IBAction)noTechnologyButtonPress
{
	if ([(Flashcard *)(self.technologyDeck[self.indexOfCurrentCard]) isTechnology])
	{
		self.descriptionLabel.text = @"This is technology!";
		[self showAnswerIncorrect];
	}
	else
	{
		self.descriptionLabel.text = @"This is NOT technology.";
		[self showAnswerCorrect];
	}
	
	self.yesTechnologyButton.hidden = YES;
	self.noTechnologyButton.hidden = YES;
	self.nextButton.hidden = NO;
	self.isThisTechnologyLabel.hidden = YES;
}//Not Technology has been pressed

- (IBAction)yesTechnologyButtonPressed
{
	if ([(Flashcard *)(self.technologyDeck[self.indexOfCurrentCard]) isTechnology])
	{
		self.descriptionLabel.text = @"This is technology!";
		[self showAnswerCorrect];
	}
	else
	{
		self.descriptionLabel.text = @"This is NOT technology.";
		[self showAnswerIncorrect];
	}
	//THIS IS A TEST

	
	self.yesTechnologyButton.hidden = YES;
	self.noTechnologyButton.hidden = YES;
	self.nextButton.hidden = NO;
	self.isThisTechnologyLabel.hidden = YES;
	//turn the answer buttons off. turn the next button on. The kid has answered the question.
}//Yes techonology button has been pressed


- (IBAction)nextButtonPressed
{
	
	if (self.indexOfCurrentCard == [self.technologyDeck count] - 1)
	{
		[self performSegueWithIdentifier:@"endGameSegue" sender:self];
		return;
	}
	self.currentFlashCardView.currentFlashcard = self.technologyDeck[++self.indexOfCurrentCard];
	//increment and update the image on the card
	
	self.yesTechnologyButton.hidden = NO;
	self.noTechnologyButton.hidden = NO;
	self.nextButton.hidden = YES;
	self.descriptionLabel.hidden = YES;
	self.isThisTechnologyLabel.hidden = NO;
	self.cardNumberLabel.text = [NSString stringWithFormat:@"%d / %d", self.indexOfCurrentCard + 1, self.numberCards];
	// turn the answer buttons back on for the next question. turnt the next button off
		
	[UIView animateWithDuration:SPEED_OF_FLASHCARD_CHANGE
									 animations:^(void){
										 self.currentFlashCardView.center = CGPointMake(-self.currentFlashCardView.center.x, self.currentFlashCardView.center.y);
									 }completion:^(BOOL finished) {
										 
										 _currentFlashCardView.center = CGPointMake(self.cardOnScreenFrame.size.width + self.view.bounds.size.width, self.currentFlashCardView.center.y);
										 //move the flashcard offscreen right
										 
										 self.currentFlashCardView.imageFaceUp = YES;
										 self.correctImageView.hidden = YES;
										 self.correctLabel.hidden = YES;
										 //setup the flashcard for face up view
										 
										 [UIView animateWithDuration:SPEED_OF_FLASHCARD_CHANGE
																			animations:^(void){
																				self.currentFlashCardView.frame = self.cardOnScreenFrame;
																			}];
										 //animate it back on
										 
									 }];
	
	
}

#pragma mark - Change The View

-(void) showAnswerCorrect
{
	self.currentFlashCardView.isCorrect = YES;
	self.numberCorrect++;
	self.correctLabel.text = @"CORRECT!";
	self.correctImageView.image = self.currentFlashCardView.correctImage;
	[self flipCard];
}

-(void) showAnswerIncorrect
{
	self.currentFlashCardView.isCorrect = NO;
	self.correctLabel.text = @"INCORRECT";
	self.correctImageView.image = self.currentFlashCardView.inCorrectImage;
	[self flipCard];
}

-(void) flipCard
{
	[self.gameProgressView setProgress:((double)(self.indexOfCurrentCard + 1) / self.numberCards) animated:YES];
	[UIView transitionWithView:self.currentFlashCardView
										duration:SPEED_OF_FLASHCARD_FLIP
										 options:UIViewAnimationOptionTransitionFlipFromRight
									animations:^{
										[self.currentFlashCardView setNeedsDisplay];
										self.currentFlashCardView.imageFaceUp = NO;
										self.correctImageView.hidden = NO;
										self.correctLabel.hidden = NO;
										self.descriptionLabel.hidden = NO;
									}
									completion:NULL];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	
	if ([[segue identifier] isEqualToString:@"endGameSegue"])
	{
		// Get reference to the destination view controller
		TFPostGameViewController * postGameViewController = [segue destinationViewController];
		
		// Pass any objects to the view controller here, like...
		postGameViewController.numberCards = self.numberCards;
		postGameViewController.numberCorrect = self.numberCorrect;
		postGameViewController.difficultyLevel = self.difficultyLevel;
	}

	[super prepareForSegue:segue sender:sender];
}



@end


