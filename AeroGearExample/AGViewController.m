/*
 * JBoss, Home of Professional Open Source
 * Copyright Red Hat, Inc., and individual contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "AGViewController.h"
#import "AeroGear.h"

@implementation AGViewController {
    NSArray *_tasks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // NSURL object:
    NSURL* projectsURL = [NSURL URLWithString:@"http://todo-aerogear.rhcloud.com/todo-server"];
    
    id<AGPipe> tasksPipe;
    
    // create the 'todo' pipeline, which contains the 'projects' pipe:
    AGPipeline *todo = [AGPipeline pipelineWithBaseURL:projectsURL];
    
    tasksPipe = [todo pipe:^(id<AGPipeConfig> config) {
        [config setName:@"tasks"];
    }];

    [tasksPipe read:^(id responseObject) {
        
        _tasks = responseObject;
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"An error has occured during fetch! \n%@", error);
    }];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    
    cell.textLabel.text = [[_tasks objectAtIndex:row] objectForKey:@"title"];
    
    return cell;
}

@end
