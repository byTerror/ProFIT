public with sharing class ErrorLogGenerator {
    //Inserts date, error logs, and the error name.
    public static void ErrorLogGenerator(Date errDateTime, String errorLog, String errorName) {
        Error_Log__c errorObj = new Error_Log__c();
        
        errorObj.Log_Date_Time__c = errDateTime;
        errorObj.Log_Details__c = errorLog;
        errorObj.Process_Name__c = errorName;
        
        Database.insert(errorObj);
    }
}