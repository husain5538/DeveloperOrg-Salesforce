@isTest
private class createWeeklyTimeSheet_Batch_isTest {
    
    @testSetup static void testSetup() {
        
         ID profId = UserInfo.getProfileId();
        // Create common test User
        List<User> usrList = new List<User>();
        Integer counter = 50;
        for(Integer count=0;count<counter;count++){
            String hashString = 'Q4%@' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
            Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
            String hexDigest = EncodingUtil.convertToHex(hash) + count;
            system.debug('##########' + hexDigest );
            User usr = new User(Alias = 'st'+count,WeeklyTimesheet__c= true, Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = ProfID,TimeZoneSidKey='America/Los_Angeles', UserName='testUser.'+hexDigest+'@testorg.com');
            usrList.add(usr);
        }
        insert usrList;
    }
    static testmethod void testcreateWeeklyTimeSheet_Batch() {
    // The query used by the batch job.
        String query = 'Select Id, Name, WeeklyTimesheet__c, isActive From User where IsActive = true AND WeeklyTimesheet__c = true';
         date currrentWeek = system.TODAY().toStartofWeek();
        system.debug('currrentWeek--'+currrentWeek);
        String currWeek_startDate = String.valueOf(currrentWeek);
        String currWeek_endDate = String.valueOf(currrentWeek.addDays(6));
        system.debug('currWeek_startDate--'+currWeek_startDate);
        system.debug('currWeek_endDate--'+currWeek_endDate);
        Test.startTest();
       createWeeklyTimeSheet_Batch WeeklyBatch = new createWeeklyTimeSheet_Batch(currWeek_startDate,currWeek_endDate); 
        Database.executeBatch(WeeklyBatch);
       Test.stopTest();

       // Verify merchandise items got deleted 
       Integer count = [SELECT COUNT() FROM Weekly_Time_Entry__c];
       //System.assertEquals(count, 50);
    }
}