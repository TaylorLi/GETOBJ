//
//  ChattyViewController.m
//  Chatty
//
//  Copyright (c) 2009 Peter Bakhyryev <peter@byteclub.com>, ByteClub LLC
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

#import "ChattyViewController.h"
#import "ChattyAppDelegate.h"
#import "LocalRoom.h"
#import "RemoteRoom.h"
#import "AppConfig.h"
#import "ServerRelateInfo.h"
#import "UIPasswordBox.h"
#import "UIHelper.h"
#import "ServerSetting.h"
#import "GameInfo.h"
// Private properties
@interface ChattyViewController ()
@property(nonatomic,retain) ServerBrowser* serverBrowser;
@property(nonatomic,retain) PeerBrowser *peerServerBrowser;
@end


@implementation ChattyViewController

@synthesize serverBrowser;
@synthesize peerServerBrowser;
@synthesize settingViewController;

// View loaded
- (void)viewDidLoad {
    lockImg=[UIImage imageNamed:@"54-lock.png"];
    if([AppConfig getInstance].networkUsingWifi)
    {
        serverBrowser = [[ServerBrowser alloc] init];
        serverBrowser.delegate = self;
    }
    else
    {
        peerServerBrowser=[[PeerBrowser alloc] init];
        peerServerBrowser.delegate=self;
    }
}

// Cleanup
- (void)dealloc {
    self.serverBrowser = nil;
    [self.serverBrowser release];
    self.peerServerBrowser=nil;
    [self.peerServerBrowser release];
    lockImg=nil;
    [lockImg release];
    [super dealloc];
}


// View became active, start your engines
- (void)activate {
    // Start browsing for services
    if ([AppConfig getInstance].networkUsingWifi) {
        [serverBrowser start];
    }
    else
        [peerServerBrowser start];
    [self updateServerList];
}
-(void)stopBrowser
{
    if ([AppConfig getInstance].networkUsingWifi) {
        [serverBrowser stop];
    }
    else
        [peerServerBrowser stop];
}

// User is asking to create new chat room
- (IBAction)createNewChatRoom:(id)sender {
    // Stop browsing for servers
    //    if ([AppConfig getInstance].networkUsingWifi) {
    //        [serverBrowser stop];
    //    }else{
    //        [peerServerBrowser stop];
    //    }        
        LocalRoom* room = [[LocalRoom alloc] initWithGameInfo:[[[GameInfo alloc] initWithGameSetting:[[[ServerSetting alloc] initWithDefault] autorelease]] autorelease]];
       
        [self stopBrowser];
        [[ChattyAppDelegate getInstance] showScoreBoard:room];
    return;
    
    GameSettingViewController *settingView= [[GameSettingViewController alloc] initWithNibName:@"GameSettingView" bundle:nil];
    self.settingViewController=settingView;
    [settingView release];
    [self.view addSubview:settingView.view];
    [self.view bringSubviewToFront:settingView.view];
    // Create local chat room and go
    //LocalRoom* room = [[[LocalRoom alloc] init] autorelease];
    //[[ChattyAppDelegate getInstance] showScoreBoard:room];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [AppConfig shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

// User is asking to join an existing chat room
- (void)joinChatRoom:(NSIndexPath*)currentRow {
    // Figure out which server is selected
    //NSIndexPath* currentRow = [serverList indexPathForSelectedRow];
    RemoteRoom* room ;
    if ([AppConfig getInstance].networkUsingWifi) {
        if ( currentRow == nil ||serverBrowser.servers==nil||[serverBrowser.servers count]<currentRow.row+1) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Which server?" message:@"Please select which server you want to join from the list above" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        NSNetService* selectedServer = [serverBrowser.servers objectAtIndex:currentRow.row];
        
        // Create chat room that will connect to that chat server
        room = [[[RemoteRoom alloc] initWithNetService:selectedServer] autorelease];
        [serverBrowser stop];
    }else{
        if ( currentRow == nil ||peerServerBrowser.servers==nil||[peerServerBrowser.servers count]<currentRow.row+1) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Which server?" message:@"Please select which server you want to join from the list above" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        ServerRelateInfo* selectedPeerServer = [peerServerBrowser.servers objectAtIndex:currentRow.row];
        NSLog(@"Connect to Server:%@",[selectedPeerServer description]); 
        room=[[[RemoteRoom alloc] initWithPeerId:selectedPeerServer.peerId] autorelease];
        [peerServerBrowser stop];
    }
    // Stop browsing and switch over to chat room
    
    
    NSString* password = [AppConfig getInstance].password;  //要获取对应服务器的密码
    if(password==nil || password==@"")
    {
        [[ChattyAppDelegate getInstance] showScoreControlRoom:room];
    }
    else
    {
        [[ChattyAppDelegate getInstance] showPermitControl:room validatePassword:YES setServerPassword:password];
    }
}

#pragma mark -
#pragma mark ServerBrowserDelegate Method Implementations

- (void)updateServerList {
    [serverList reloadData];
}


#pragma mark -
#pragma mark UITableViewDataSource Method Implementations

// Number of rows in each section. One section by default.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([AppConfig getInstance].networkUsingWifi)
    {
        return [serverBrowser.servers count];
    }
    else
    {
        
        for (ServerRelateInfo *sr in peerServerBrowser.servers){
            if([[AppConfig getInstance].invalidServerPeerIds containsObject:sr.peerId])
            {
                [[AppConfig getInstance].invalidServerPeerIds removeObject:sr.peerId];            
                [peerServerBrowser.servers removeObject:sr];
            }
        }
        
        NSLog(@"%i",[peerServerBrowser.servers count]);
        return [peerServerBrowser.servers count];
    }
}


// Table view is requesting a cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* serverListIdentifier = @"serverListIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:serverListIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:serverListIdentifier] autorelease];
	}
    
    // Set cell's text to server's name
    if([AppConfig getInstance].networkUsingWifi)
    {
        NSNetService* server = [serverBrowser.servers objectAtIndex:indexPath.row];
        cell.textLabel.text = [server name];
    }
    else{
        ServerRelateInfo *sri =  [peerServerBrowser.servers objectAtIndex:indexPath.row];
        cell.textLabel.text= sri.displaySeverName;
        if([sri.password isEqualToString:@""] ||sri==nil)
            cell.imageView.hidden=YES;
        else{
            cell.imageView.image=lockImg;
            cell.imageView.hidden=NO;
        }    
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([AppConfig getInstance].networkUsingWifi)
    {
        [self joinChatRoom:indexPath];
    }
    else
    {
        ServerRelateInfo *sri =  [peerServerBrowser.servers objectAtIndex:indexPath.row];
        if([sri.password isEqualToString:@""] ||sri==nil)
            [self joinChatRoom:indexPath];
        else{
            __block UIPasswordBox *pwdBox= [[UIPasswordBox alloc] initWithLoading:@"Please input password" onComplete:^(id result){
                NSString *password=result;
                [pwdBox dismissWithClickedButtonIndex:0 animated:YES];
                if ([password isEqualToString:@""])
                {
                    ;//nothing to do   
                }
                else if ([[password uppercaseString] isEqualToString:[sri.password uppercaseString]]) {                    
                    [self joinChatRoom:indexPath];                    
                }
                else{
                    [UIHelper showAlert:@"Invalid Password" message:@"Can not connect to the game server" func:nil];                   
                }
            }];
            [pwdBox release];
        }
    }
    
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  indexPath;
}

@end
