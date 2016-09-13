@isTest
private class TimerHelper_isTest {

    @testSetup static void testSetup() {
        
         ID profId = UserInfo.getProfileId();
        // Create common test User
        List<User> usrList = new List<User>();
        Integer counter = 2;
        for(Integer count=0;count<counter;count++){
            String hashString = 'Q4%@' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
            Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
            String hexDigest = EncodingUtil.convertToHex(hash) + count;
            system.debug('##########' + hexDigest );
            User usr = new User(Alias = 'st'+count, Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = ProfID,TimeZoneSidKey='America/Los_Angeles', UserName='testUser.'+hexDigest+'@testorg.com');
            usrList.add(usr);
        }
        insert usrList;
        
        // Create common test Projects
        List<Project__c> testProjects = new List<Project__c>();
        for(Integer i=0;i<2;i++) {
            testProjects.add(new Project__c(Name = 'Technical Project'+i, Additional_Information__c ='Test project', Start_Date__c=System.Today(), Due_Date__c=System.Today().addDays(14), Scope__c='Test',Status__c='In Progress', OwnerId=usrList[i].id));
        }
        insert testProjects;
        
        // Create common test Project Members
        List<Project_Member__c> testProjectMembers = new List<Project_Member__c>();
        for(Integer i=0;i<2;i++) {
            testProjectMembers.add(new Project_Member__c(Project__c = testProjects[0].id, Member__c = usrList[i].id, Role__c='Developer'));
        }
        insert testProjectMembers;
        
        // Create common test Assigned Tasks
        List< Assigned_Task__c > testAssignedTasks = new List< Assigned_Task__c >();
        for(Integer i=0;i<2;i++) {
            testAssignedTasks.add(new Assigned_Task__c(Project__c = testProjects[0].id, Assigned_To__c = usrList[i].id, Description__c ='Developer Task', Hourly_Rate__c = 200.00, Status__c = 'Planning',Start_Date__c= System.Today().addDays(2), Due_Date__c = System.Today().addDays(7) , Subject__c= 'Test Task'+i));
        }
        insert testAssignedTasks;
        
        // Create common test Assigned Tasks
        List< Weekly_Time_Entry__c > testWeeklyTimeEntries = new List< Weekly_Time_Entry__c >();
        date currrentWeek = system.TODAY().toStartofWeek();
        String currWeek_startDate = currrentWeek.format().replace('/','-');
        String currWeek_endDate = currrentWeek.addDays(6).format().replace('/','-');
        for(Integer i=0;i<2;i++) {
            testWeeklyTimeEntries.add(new Weekly_Time_Entry__c(Start_Date__c = system.TODAY().toStartofWeek(), End_Date__c=system.TODAY().toStartofWeek().addDays(6), Name= usrList[i].Name+'-'+'Week '+currWeek_startDate+'-'+currWeek_endDate ));
        }
        insert testWeeklyTimeEntries;
        
        // Create common test Assigned Tasks
        List< Time_Entry__c > testTimeEntries = new List< Time_Entry__c >();
        for(Integer i=0;i<2;i++) {
            testTimeEntries.add(new Time_Entry__c(Related_Task__c = testAssignedTasks[i].id, Related_User__c = usrList[i].id, Start_Time__c =System.Now(), Weekly_Time_Entry__c= testWeeklyTimeEntries[0].id));
        }
        insert testTimeEntries;
        
    }
    static Id TimeEntryId;
     @isTest static void testCreateTimeEntryMethod() {
        Assigned_Task__c task = [select id,name, Subject__c from Assigned_Task__c where Subject__c='Test Task1' LIMIT 1];
        if(task != NULL){
        apexpages.currentpage().getparameters().put('id' , task.id);
        system.assertEquals(apexpages.currentpage().getparameters().get('id'),task.id);
       }
       TimeEntryId= TimerHelper.createTimeEntry(task.id);
       
     }
     
    @isTest static void testOnLoadMethod() {
        Assigned_Task__c task = [select id,name, Subject__c from Assigned_Task__c where Subject__c='Test Task1' LIMIT 1];
        if(task != NULL){
        apexpages.currentpage().getparameters().put('id' , task.id);
        system.assertEquals(apexpages.currentpage().getparameters().get('id'),task.id);
       }
       String returnVal = TimerHelper.getCurrentTimeEntryDetailsremote(task.id);
     }
     
     @isTest static void testUpdateTimeEntryMethod() {
        Time_Entry__C timeEntry = [select id,name , Related_Task__r.Subject__c from Time_Entry__c where Related_Task__r.Subject__c ='Test Task1' LIMIT 1];
        if(timeEntry != NULL){
        system.assertEquals(timeEntry.Related_Task__r.Subject__c,'Test Task1');
        TimerHelper.updateTimerEntry(timeEntry.Id,'00:24:45:16','Pause');
        TimerHelper.updateTimerEntry(timeEntry.Id,'00:24:45:16','Resume');
        TimerHelper.updateTimerEntry(timeEntry.Id,'00:24:45:16','Stop');
       }
       
     }
    
    }