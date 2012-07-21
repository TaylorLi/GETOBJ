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
#import "AppConfig.h"
#import "ChattyViewController.h"
#import "ServerSetting.h"
#import "GameInfo.h"

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
@synthesize navBar;

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
    float height=self.view.frame.size.height/2;
    selRoundTime = [[AFPickerView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height+navBar.frame.size.height+1-height,self.view.frame.size.width,height) backgroundImage:@"PickerBG.png" shadowImage:@"PickerShadow.png" glassImage:@"PickerGlassHightlight.png" title:@"Round Time (Minutes)"];
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
    [self setNavBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    [navBar release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [AppConfig shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (IBAction)chgUsagePwd:(id)sender {
    txtPwd.hidden=!sldPsw.on;
    if(sldPsw.on)
        [txtPwd becomeFirstResponder];
    else
        [txtPwd resignFirstResponder];
}

- (IBAction)StartGame:(id)sender {
    if(![UIHelper validateTextFields:settingView.subviews])
    {
        [UIHelper showAlert:@"Information" message:@"Please input the required fields" delegate:nil];
        return;
    }
    //Create local chat room and go    
    ServerSetting *gameSetting=[[ServerSetting alloc] init];
    gameSetting.gameDesc=txtGameDesc.text;
    gameSetting.gameName=txtGameName.text;
    gameSetting.blueSideDesc=txtBlueSidePlace.text;
    gameSetting.blueSideName=txtblueSideName.text;
    gameSetting.redSideDesc=txtRedSidePlace.text;
    gameSetting.redSideName=txtRedSidePlace.text;
    gameSetting.roundTime=minutes*60;
    gameSetting.roundCount=[roundCount.text intValue];
    if(sldPsw.isOn)
        gameSetting.password=txtPwd.text;
    else
        gameSetting.password=nil;
    NSLog(@"Game Setting:%@",[gameSetting description]);
    LocalRoom* room = [[[LocalRoom alloc] initWithGameInfo:[[GameInfo alloc] initWithGameSetting:gameSetting]] autorelease];
    [self.view removeFromSuperview];
    [gameSetting release];
    [[ChattyAppDelegate getInstance].viewController stopBrowser];
    [[ChattyAppDelegate getInstance] showScoreBoard:room];
}

- (IBAction)backToSeverList:(id)sender {
    [self.view removeFromSuperview];
    //[[ChattyAppDelegate getInstance] showRoomSelection];
}

#pragma Text input event
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [settingView adjustOffsetToIdealIfNeeded];
    [selRoundTime hidePicker];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [UIHelper alternateTextField:self.settingView.subviews];
    [textField resignFirstResponder];    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (IBAction)showTimePicker:(id)sender {
    if([selRoundTime isHidden]){
    [UIHelper resignResponser:self.settingView.subviews];
    [selRoundTime showPicker];
    [selRoundTime reloadData];
    [selRoundTime setSelectedRow:minutes-1];
    }else{
        [selRoundTime hidePicker];
    }
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
    [UIHelper resignResponser:self.settingView.subviews];
    [settingView resignFirstResponder];
    [selRoundTime hidePicker];
} 
@end
