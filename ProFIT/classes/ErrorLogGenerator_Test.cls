@isTest
//Test if there is 'Test Error Name' value in the Error_Log__c ErrorLogGenerator().
public with sharing class ErrorLogGenerator_Test {
    @IsTest
    static void testError(){
        
        Test.startTest();
        Date logDate = date.newInstance(2021, 6, 21);
        String logDetails = 'Error Test';
        String name = 'Test Error Name';
        ErrorLogGenerator.ErrorLogGenerator(logDate, logDetails, name);
        
        Test.stopTest();
        try{
            Error_Log__c eLog = [Select Id, Log_Date_Time__c,Log_Details__c,Process_Name__c from Error_Log__c];
            System.assertEquals('Test Error Name', eLog.Process_Name__c);
        }
        catch(Exception ex){
            System.debug(ex);
        }
    }
}