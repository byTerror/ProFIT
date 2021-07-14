@IsTest
public with sharing class LocationVerifyClass_Test {
    @IsTest
    static void testUpdateZip(){
        Location__c locTest = new Location__c();

        locTest.Name = '3301 South Greenfield Rd';
        locTest.Street__c = '3301 South Greenfield Rd';
        locTest.City__c = 'Gilbert';
        locTest.State__c = 'AZ';
        locTest.Postal_Code__c = '85297';
        locTest.Country__c = 'United States';
        Database.insert(locTest);
        
        try{
            Test.setMock(HttpCalloutMock.class, new ZipCalloutMock());
            Test.startTest();

            LocationVerifyClass.VerifyZip(locTest.Id);
        
            Test.stopTest();
        }
        catch(Exception ex){
            System.debug(ex);
        }
        Location__c retrievedLoc = [Select Zip_Verified__c from Location__c where Id =: locTest.Id];
        System.assertEquals(true, retrievedLoc.Zip_Verified__c);
    }
    @IsTest
    static void testUpdateLoc(){
        Location__c locTest = new Location__c();

        locTest.Name = '3301 South Greenfield Rd';
        locTest.Street__c = '3301 South Greenfield Rd';
        locTest.City__c = 'Gilbert';
        locTest.State__c = 'AZ';
        locTest.Postal_Code__c = '85297';
        locTest.Country__c = 'United States';
        Database.insert(locTest);
        
        try{
            Test.setMock(HttpCalloutMock.class, new LocationCalloutMock());
            Test.startTest();

            LocationVerifyClass.VerifyLocation(locTest.Id);
        
            Test.stopTest();
        }
        catch(Exception ex){
            System.debug(ex);
        }
        Location__c retrievedZip = [Select Verified__c from Location__c where Id =: locTest.Id];
        System.assertEquals(true, retrievedZip.Verified__c);
    }
}