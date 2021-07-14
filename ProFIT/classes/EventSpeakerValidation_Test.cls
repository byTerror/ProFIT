@IsTest
private class EventSpeakerValidation_Test {

    static Id createTestRecordID(){
        Event__c evt = new Event__c();
        evt.Name__c = 'Test Event';
        evt.Live__c = true;
        evt.Start_Date_Time__c = datetime.newInstance(2021, 6, 21, 19, 30, 0);
        evt.End_Date_Time__c = datetime.newInstance(2021, 6, 22, 20, 30, 0);
        Database.insert(evt);
        return evt.Id;
    }

        @IsTest
      Static void checkEventEspeaker(){
        Test.startTest();

        try{
        Event_Speaker__c eS = new Event_Speaker__c();
        //Field Names
        //Create a new data to object
        eS.Event__c = createTestRecordID();
        eS.Speaker__c = 'a080l00000BCp3bAAD';
        
        Database.insert(eS);
        

        Event_Speaker__c retrievedES = [Select Id from Event_Speaker__c where Name =: eS.Speaker__c];

        System.assertEquals('a080l00000BCp3bAAD',retrievedES.Speaker__c);
        }
        catch (Exception ex){
            Test.stopTest();
        }
      }
}