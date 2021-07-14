public with sharing class LocationVerifyClass {

    @future(callout = true)
    public static void VerifyZip(string recId){
        Location__c locationRec = [Select Id, Name, Verified__c, Street__c, City__c, Postal_Code__c, State__c From Location__c Where Id =: recId];

        HttpRequest httpReqZip = new HttpRequest();
        httpReqZip.setMethod('GET');
        String endPtZip = 'https://us-zipcode.api.smartystreets.com/lookup?auth-id=9c1a638c-ac30-8c88-9daf-01e71231e629&auth-token=eQSuUeoTjiDVbjpFoxn3' + '&zipcode='+EncodingUtil.urlEncode(locationRec.Postal_Code__c, 'UTF-8');
        httpReqZip.setEndpoint(endPtZip);

        Http httpZip = new Http();
        HttpResponse httpRespZip = new HttpResponse();
        httpRespZip = httpZip.send(httpReqZip);

        try{

            if(httpRespZip.getStatusCode() == 200){

                String zipCode;

                List<Object> resultsZipList = (List<Object>)JSON.deserializeUntyped(httpRespZip.getBody());
                    for(Object obj : resultsZipList){
                        
                        Map<String, Object> results = (Map<String, Object>) obj;
                        List<Object> zipObject = (List<Object>) results.get('zipcodes');
                        if((zipObject != null)){
                            locationRec.Verified__c = true;
                            Database.update(locationRec);
                            VerifyLocation(recId);
                        }
                        else{
                            locationRec.Verified__c = false;
                            Database.update(locationRec);
                        }
                    }
            }
        }
        catch(Exception ex){
            System.debug(ex);
        }
    }

    public static void VerifyLocation(string recId) {
        Location__c locationRec = [Select Id, Name, Verified__c, Street__c, City__c, Postal_Code__c, State__c From Location__c Where Id =: recId];

        //////////////////////Address Verify
        HttpRequest httpReqLocation = new HttpRequest();
        httpReqLocation.setMethod('GET');
        String endPtLoc = 'https://us-street.api.smartystreets.com/street-address?auth-id=9c1a638c-ac30-8c88-9daf-01e71231e629&auth-token=eQSuUeoTjiDVbjpFoxn3' + '&street=' + EncodingUtil.urlEncode(locationRec.Street__c, 'UTF-8') + '&city=' + EncodingUtil.urlEncode(locationRec.City__c, 'UTF-8') + '&state='+EncodingUtil.urlEncode(locationRec.State__c, 'UTF-8');
        httpReqLocation.setEndpoint(endPtLoc);

        Http httpLoc = new Http();
        HttpResponse httpRespLoc = new HttpResponse();
        
            httpRespLoc = httpLoc.send(httpReqLocation);


            try{

            if((httpRespLoc.getStatusCode() == 200)){

                    String streetName;
                    String cityName;
                    String stateAbbr;

                    List<Object> resultsLocList = (List<Object>)JSON.deserializeUntyped(httpRespLoc.getBody());
                    for(Object obj : resultsLocList){
                        Map<String, Object> results = (Map<String, Object>) obj;
                        Map<String, Object> address = (Map<String, Object>)results.get('components');
                        streetName = ((String)address.get('primary_number') + ' ' + (String)address.get('street_predirection') + ' ' + (String)address.get('street_name') + ' ' + (String)address.get('street_suffix'));
                        cityName = (String)address.get('city_name');
                        stateAbbr = (String)address.get('state_abbreviation');
                        // System.debug(resultsLocList);
                        // System.debug(results);
                        // System.debug(address);
                        // System.debug(locationRec.Street__c);
                        // System.debug(cityName);
                        // System.debug(stateAbbr);
                        
                        //((!String.isBlank(httpRespLoc.getBody())) && (!String.isBlank(streetName)) && (!String.isBlank(cityName)) && (!String.isBlank(stateAbbr)))
                        if((!String.isBlank(httpRespLoc.getBody())) && (address != null)){
                            // UpdateLocation(recId, check);
                            // locationRec.Verified__c = true;
                            locationRec.Verified__c = true;
                            Database.update(locationRec);
                        }
                        else{
                            locationRec.Verified__c = false;
                            Database.update(locationRec);
                        }
                    }
            }
        }
        catch(Exception ex){
            System.debug(ex);
        }
    }
}