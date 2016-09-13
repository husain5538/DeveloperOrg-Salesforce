global class scheduledBatchforWeeklyTimeSheet implements Schedulable {
    global void execute(SchedulableContext sc) {
        date currrentWeek = system.TODAY().toStartofWeek();
        system.debug('currrentWeek--'+currrentWeek);
        String currWeek_startDate = currrentWeek.format().replace('/','-');
        String currWeek_endDate = currrentWeek.addDays(6).format().replace('/','-');
        createWeeklyTimeSheet_Batch b = new createWeeklyTimeSheet_Batch(currWeek_startDate,currWeek_endDate); 
        database.executebatch(b);
    }
}