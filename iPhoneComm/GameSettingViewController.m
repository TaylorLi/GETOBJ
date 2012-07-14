//
//  GameSetting.m
//  TKD Score
//
//  Created by Eagle Du on 12/7/10.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "GameSettingViewController.h"
#import "UIHelper.h"
#import "LocalRoom.h"
#import "ChattyAppDelegate.h"
#import "TPKeyboardAvoidingScrollView.h"

@implementation GameSettingViewController
@synthesize roundTime;
@synthesize roundCount;

@synthesize settingView;
@synthesize txtGameName;
@synthesize txtGameDesc;
@synthesize txtRedSideName;
@synthesize txtRedSidePlace;
@synthesize txtblueSideName;
@synthesize txtBlueSidePlace;
@synthesize sldPsw;
@synthesize txtPwd;
@synthesize selRoundTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        minutes=5;
    }
    return self;
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    settingView.contentSize =CGSizeMake(settingView.frame.size.width, settingView.frame.size.height*1.2);
    selRoundTime = [[AFPickerView alloc] initWithFrame:CGRectMake(0,245,320,216) backgroundImage:@"PickerBG.png" shadowImage:@"PickerShadow.png" glassImage:@"PickerGlassHightlight.png" title:@"Round Time (Minutes)"];
    selRoundTime.dataSource = self;
    selRoundTime.delegate = self;
    [self.view addSubview:selRoundTime];
}

- (void)viewDidUnload
{
    [self setTxtGameName:nil];
    [self setTxtGameDesc:nil];
    [self setTxtRedSideName:nil];
    [self setTxtRedSidePlace:nil];
    [self setTxtblueSideName:nil];
    [self setTxtBlueSidePlace:nil];
    [self setSldPsw:nil];
    [self setTxtPwd:nil];
    [self setSelRoundTime:nil];
    [self setRoundCount:nil];
    [self setRoundTime:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)dealloc {
    [txtGameName release];
    [txtGameDesc release];
    [txtRedSideName release];
    [txtRedSidePlace release];
    [txtblueSideName release];
    [txtBlueSidePlace release];
    [sldPsw release];
    [txtPwd release];
    [selRoundTime release];
    [roundCount release];
    [roundTime release];
    [super dealloc];
}
- (IBAction)chgUsagePwd:(id)sender {
    txtPwd.hidden=!sldPsw.on;
}

- (IBAction)StartGame:(id)sender {
    if(![UIHelper validateTextFields:settingView.subviews])
    {
        [UIHelper showAlert:@"Information" message:@"Please input the required fields" delegate:nil];
        return;
    }
    //Create local chat room and go
    LocalRoom* room = [[[LocalRoom alloc] init] autorelease];
    room.gameSetting=[[ServerSetting alloc] init];
    room.gameSetting.gameDesc=txtGameName.text;
    room.gameSetting.gameName=txtGameDesc.text;
    room.gameSetting.blueSideDesc=txtBlueSidePlace.text;
    room.gameSetting.blueSideName=txtblueSideName.text;
    room.gameSetting.redSideDesc=txtRedSidePlace.text;
    room.gameSetting.redSideName=txtRedSidePlace.text;
    room.gameSetting.roundTime=minutes*60;
    room.gameSetting.roundCount=[roundCount.text intValue];
    if(sldPsw.isOn)
        room.gameSetting.password=txtPwd.text;
    else
        room.gameSetting.password=nil;
    [self.view removeFromSuperview];
    [room.gameSetting release];
    [[ChattyAppDelegate getInstance] showScoreBoard:room];
}

- (IBAction)backToSeverList:(id)sender {
    [self.view removeFromSuperview];
}

#pragma Text input event
-(IBAction)textFieldDidBeginEditing:(UITextField *)textField
{
    [settingView adjustOffsetToIdealIfNeeded];
//    float height= textField.center.y> self.view.frame.size.height/2-textField.frame.size.height*3?(self.view.frame.size.height/2-textField.frame.size.height*3): self.view.frame.size.height/2;
//    [self setCenterPoint:height];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [UIHelper alternateTextField:self.settingView.subviews];
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (IBAction)showTimePicker:(id)sender {
    [selRoundTime showPicker];
    [selRoundTime reloadData];
    [selRoundTime setSelectedRow:minutes-1];
}

#pragma mark -
#pragma mark Picker Data Source Methods

- (NSInteger)pickerView:(AFPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    if (component == kMiniuteComponent)
        return 15;
	else
        return 30;
}

#pragma mark Picker Delegate Methods

- (void)pickerView:(AFPickerView *)pickerView
	  didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    if (component == kMiniuteComponent) {
        //roundTime.titleLabel.text=[NSString stringWithFormat:@"%i",row+1];
    }
}

- (NSString *)pickerView:(AFPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == kMiniuteComponent)
        return [NSString stringWithFormat:@"%i",row+1];
    else{
        return [NSString stringWithFormat:@"%i",row+1];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(AFPickerView *)pickerView
{
    return 1;
}

-(void) doneSelect:(AFPickerView *)pickerView didSelectRow:(NSInteger)row 
       inComponent:(NSInteger)component
{
    roundTime.text=[NSString stringWithFormat:@"%i Minutes", row+1];
    minutes=row+1;
}
#pragma mark – 
#pragma mark UIScrollViewDelegate Methods 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{ 
    for(UIView *view in self.settingView.subviews)
    {
        if([view isMemberOfClass:[UITextField class]] && [view isFirstResponder])
        {
            [view resignFirstResponder];
        }
    }
    if([settingView isFirstResponder])
        {
            [settingView resignFirstResponder];
        }
} 
@end
