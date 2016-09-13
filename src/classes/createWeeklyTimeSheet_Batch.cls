// Batch class to create weekly time sheet recods for the users who have Weekly timesheet checkbox checked in their record.
// CreatedDate : 20 August 2016
global class createWeeklyTimeSheet_Batch implements Database.Batchable<sObject>{
global final Date dtStartDate;
global final Date dtEndDate;

global createWeeklyTimeSheet_Batch (String dtStartDt ,String dtEndDt){
     dtStartDate = Date.valueOf(dtStartDt);
    dtEndDate = Date.valueOf(dtEndDt);
    System.debug('what is the value in dtEndDate '+dtEndDate );
    System.debug('what is the value in dtStartDate '+dtStartDate );
}

global Database.QueryLocator start(Database.BatchableContext BC){
      String query = 'Select Id, Name, WeeklyTimesheet__c, isActive From User where IsActive = true AND WeeklyTimesheet__c = true';
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, 
                       List<sObject> scope){
      List<Weekly_Time_Entry__c> ListWeeklyTimeSheetToBeInserted = new List<Weekly_Time_Entry__c>();                 
      for(User oUser: (List<User>)scope){
          Weekly_Time_Entry__c oRecord = new Weekly_Time_Entry__c(Name = oUser.Name+'-Week-'+String.ValueOf(dtStartDate).substring(0,10)+'-'+String.ValueOf(dtEndDate).subString(0,10) ,OwnerID = oUSer.Id,Start_Date__c=dtStartDate,End_Date__c=dtEndDate);
          ListWeeklyTimeSheetToBeInserted.add(oRecord);
      }
      System.debug('what is the value in dtEndDate '+dtEndDate );
      System.debug('what is the value in dtStartDate '+dtStartDate );
      System.debug('what is the value in ListWeeklyTimeSheetToBeInserted'+ListWeeklyTimeSheetToBeInserted);
      if(ListWeeklyTimeSheetToBeInserted.size()>0){
          List<Database.SaveResult> dsrList = Database.Insert(ListWeeklyTimeSheetToBeInserted,false);
          System.debug('what is the value in dsrList '+dsrList );
      }
   }

   global void finish(Database.BatchableContext BC){
        
   }
}