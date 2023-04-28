public with sharing class SchedulerDeleteOldOrderBatch implements Schedulable{
    public SchedulerDeleteOldOrderBatch() {}

    public void execute(SchedulableContext context){
        deleteOldOrderBatch batch = new deleteOldOrderBatch();
        Database.executeBatch(batch, 10);
    }
}