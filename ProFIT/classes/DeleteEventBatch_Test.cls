@IsTest
public with sharing class DeleteEventBatch_Test {
    @IsTest
    //Test if there 200 records were updated prior to their Status.
    static void DeleteEventBatch_Test() {
        List<Event__c> eventTestLst = new List<Event__c>();
        Integer count = 1;
        while(count <= 200){
            Event__c eventTest = new Event__c();
            eventTest.Name__c = 'Sample Event ' + count;
            eventTest.Status__c = 'Created';
            eventTest.Max_Seats__c = 50;
            eventTest.Live__c = false;
            eventTest.Start_Date_Time__c = Datetime.newInstance(2020, 12, 24, 12, 0, 0);
            eventTest.End_Date_Time__c = Datetime.newInstance(2020, 12, 25, 12, 0, 0);
            eventTestLst.add(eventTest);
            count++;
        }
        Database.insert(eventTestLst);
        System.debug(eventTestLst);
        Test.startTest();
        
        DeleteEventBatch delEvtBat = new DeleteEventBatch();
        Database.executeBatch(delEvtBat);

        System.assertEquals(200, [Select count() from Event__c]);

        Test.stopTest();       
    }
}