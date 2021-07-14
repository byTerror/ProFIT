public class DeleteEventBatch implements Database.Batchable<sObject> {
    //Database.QueryLocator is ued to generate the scope of objects in a batch.
    public Database.QueryLocator start(Database.BatchableContext batchContext){
        String Query = 'Select Id, Name__c From Event__c Where Live__c = false AND Status__c != \'Complete\' AND End_Date_Time__c < LAST_N_MONTHS:4';
        return Database.getQueryLocator(Query);
    }
    
    //Updates the Status inside the List of events to 'Deleted'
    public void execute(Database.BatchableContext batchContext, List<Event__c> eventList ){
        List<Event__c> updatedEventList = new List<Event__c>();
        for(Event__c eventRec: eventList){
            eventRec.Status__c = 'Deleted';
            updatedEventList.add(eventRec);
        }
        Database.update(updatedEventList);
    }
    
    //Sends an email to specific persons that the Batch has been processed
    public void finish(Database.BatchableContext batchContext){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setSubject('Batch Processing Completed');
        List<String> toAddress = new List<String>{'cjmamiado@gmail.com','zowee526@gmail.com'};
        mail.setToAddresses(toAddress);
        mail.setSenderDisplayName('Charles Salesforce Developer');
        
        mail.setHtmlBody('Event Has been deleted');
        Messaging.SingleEmailMessage[] emails = 
        new List<Messaging.SingleEmailMessage> {mail};
             Messaging.SendEmailResult[] results = Messaging.sendEmail(emails);
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: '
                + results[0].errors[0].message);
        }
    }
}