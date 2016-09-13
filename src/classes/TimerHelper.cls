global class TimerHelper{
    /*
    Created By:
    Shadab Hussain
    Description:
    This method is called remotely to initialise the timer on load of recor page and starts Timer accordingly.
     */
    @RemoteAction
    global static string getCurrentTimeEntryDetailsremote(Id currentRecordId){
        //Id currentRecordId = apexpages.currentpage().getparameters().get('id');
        Long totalTimespent;
        string timeelapsed = '';
        String currentTimeEntryId='';
        String isPaused='OFF';
        String validateAssignedToUser='OFF';
        if(currentRecordId.getSobjectType().getDescribe().getName() == 'Assigned_Task__c'){
            Assigned_Task__c currentTask=[select id,name,Assigned_To__c,(select id,name, Start_Time__c,End_Time__c,Total_Time_Spent__c,Is_Paused__c, Last_Paused_Time__c ,IsCompleted__c,Time_Spent__c,CreatedById from Time_Entries__r Where IsCompleted__c=false ORDER BY CreatedDate DESC LIMIT 1) FROM Assigned_Task__c WHERE Id=:currentRecordId LIMIT 1];
            if(currentTask <> NULL){
                for(Time_Entry__c timeEntry : currentTask.Time_Entries__r ){
                    if(timeEntry.Is_Paused__c){
                        timeelapsed = String.ValueOf(timeEntry.Total_Time_Spent__c*3600000);
                    }
                    /*else if( !timeEntry.Is_Paused__c && Total_Time_Spent__c <> null){
                    
                    }*/
                    else if(timeEntry.IsCompleted__c <> true){
                        totalTimespent = (System.NOW()).getTime() - (timeEntry.Start_Time__c).getTime() ;
                        system.debug('@@@@ value in  totalTimespent? '+ totalTimespent);
                        system.debug('@@@@ value in  totalTimespent? '+ totalTimespent/3600000);
                        timeelapsed =timeEntry.Time_Spent__c;
                    }
                    else{
                        timeelapsed= '';
                    }
                    currentTimeEntryId=timeEntry.Id;
                    if(timeEntry.Is_Paused__c){
                    isPaused = 'ON';
                    }
                    else{
                        isPaused = 'OFF';
                    }
                }
                system.debug('loggedin User==='+ UserInfo.getUserId());
                system.debug('Assigned To User==='+ currentTask.Assigned_To__c);
                if(currentTask.Assigned_To__c != null && currentTask.Assigned_To__c == UserInfo.getUserId()){
                    validateAssignedToUser='ON';
                }
            }
        }
        
        return timeelapsed+'@@@@####@@@@'+currentTimeEntryId+'@@@@####@@@@'+isPaused+'@@@@####@@@@'+validateAssignedToUser; 
    }
    /*
    Created By:
    Shadab Hussain
    Description:
    This method is used to create a Time Entry record when user clicks the Start button.
     */
    @RemoteAction
    global static Id createTimeEntry(Id currentRecordId){
        try{
            Time_Entry__c timeEntry;
            if(currentRecordId.getSobjectType().getDescribe().getName() == 'Assigned_Task__c'){
                date currrentWeek = system.TODAY().toStartofWeek();
                system.debug('currrentWeek--'+currrentWeek);
                String currWeek_startDate = currrentWeek.format().replace('/','-');
                //currWeek_startDate.replace('/','-');
                String currWeek_endDate = currrentWeek.addDays(6).format().replace('/','-');
                //currWeek_endDate;
                String dynamicWeekName =UserInfo.getName()+'-'+'Week '+currWeek_startDate+'-'+currWeek_endDate;
                List<Weekly_Time_Entry__c> weeklyTE = [select id,name from Weekly_Time_Entry__c where Name=:dynamicWeekName LIMIT 1];
                String parentWeekRecId= '';
                if(!(weeklyTE).isEmpty()){
                    parentWeekRecId = weeklyTE[0].Id;
                }
                else{
                    
                    Weekly_Time_Entry__c newWeekTimeEntry = new Weekly_Time_Entry__c(
                                                               Name =  dynamicWeekName,
                                                               Start_Date__c = currrentWeek,
                                                               End_Date__c =   currrentWeek.addDays(6)         
                                                            );
                    insert newWeekTimeEntry;
                    parentWeekRecId = newWeekTimeEntry.Id;
                    
                }
                if(String.isNotBlank(parentWeekRecId)){
                timeEntry = new Time_Entry__c(
                                Start_Time__c = system.NOW(),
                                Related_Task__c = currentRecordId,
                                Weekly_Time_Entry__c = parentWeekRecId,
                                Related_User__c = UserInfo.getUserId()
                            );
                insert timeEntry;
                
                }
            }
            return timeEntry.Id;
        }
        catch(Exception ex){
        return null;
        }
    }
    /*
    Created By:
    Shadab Hussain
    Description:
    This method is used to updates a Time Entry record when user clicks the PAUSE/RESUME button.
     */
    @RemoteAction
    global static void updateTimerEntry(Id timeEntryId,String currentTime,string whatClicked){
        try{
            Time_Entry__c timeEntry;
            if(String.IsNotBlank(whatClicked)){
                Decimal currentTimeSpentinHrs = Decimal.valueOf(dateStringtomillsec(currentTime)).divide(3600000,2,System.RoundingMode.UP);
                if(whatClicked == 'Pause'){
                    if(timeEntryId <> null && String.isNotBlank(currentTime)){
                       
                       timeEntry = new Time_Entry__c(
                                        Id = timeEntryId,
                                        Total_Time_Spent__c = currentTimeSpentinHrs,
                                        Last_Paused_Time__c = System.Now(),
                                        Is_Paused__c= true
                                    );
                        
                       
                    }
                }
                else if(whatClicked == 'Stop'){
                    timeEntry = new Time_Entry__c(
                                    Id = timeEntryId,
                                    Total_Time_Spent__c = currentTimeSpentinHrs,
                                    IsCompleted__c = true
                                );
                }
                else if(whatClicked == 'Resume'){
                    timeEntry = new Time_Entry__c(
                                    Id = timeEntryId,
                                    Last_Paused_Time__c = null,
                                    Is_Paused__c= false
                                );
                }
            }
            update timeEntry;
        }
        catch(Exception ex){}
    }
    
    /*
    Created By:
    Shadab Hussain
    Description:
    This is helper method to calculate Millisec passed from currettime value
     */
    public static Long dateStringtomillsec(String dateString){
        string[] valArray= dateString.split(':');
        system.debug('value in valArray? '+valArray);
        integer days = Integer.valueOf(valArray[0]);
        system.debug('value in days? '+days);
        integer hours = Integer.valueOf(valArray[1]);
        integer minutes = Integer.valueOf(valArray[2]);
        integer seconds = Integer.valueOf(valArray[3]);
        
        Long totalTime=0;
        totalTime += days*24*60*60*1000;
        totalTime += hours*60*60*1000;
        totalTime += Minutes*60*1000;
        totalTime += seconds*1000;
       
        system.debug('value in totaltime? '+totalTime);
        
        return totalTime;
        
    }


}