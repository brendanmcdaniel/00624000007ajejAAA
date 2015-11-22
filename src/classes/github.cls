public class github {
    
    @future (callout=true)
    public static void createRepo(List<Id> OpportunityIds, List<String> OpportunityNames){       

        String user = 'brendanmcdaniel';
        String password = '';
        String token = '5666b97e93bc636eb5fcce8031740a82065ce683';
        String createRepo = '/user/repos'; 
        String searchRepo = '/repos/';
        String endPoint = 'https://api.github.com';
        Http http = new Http();
        Opportunity tempOpp = new Opportunity();
        Set<Opportunity> tempOpps = new Set<Opportunity>();

        HttpRequest searchRepoReq = new HttpRequest();  
  		HttpRequest createRepoReq = new HttpRequest(); 
        Blob headerValue = Blob.valueOf('token '+ token);
		String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);     
        
        for(Id theOpportunity : OpportunityIds){
        	searchRepoReq.setMethod('GET');
  			searchRepoReq.setHeader('content-type', 'application/json');
        	searchRepoReq.setHeader('User-Agent', 'salesforce');
  			searchRepoReq.setHeader('Connection','keep-alive');
  			searchRepoReq.setEndpoint(endPoint+searchRepo+user+'/'+theOpportunity+'/contributors');
  			searchRepoReq.setHeader('Date',String.valueOf(System.now())); 
        	searchRepoReq.setHeader('Authorization','token '+token);
 		try {
        	//Execute web service call here		
        	HTTPResponse searchRes = http.send(searchRepoReq);	
        	//Helpful debug messages
        	System.debug(searchRes.toString());
        	System.debug('STATUS:'+searchRes.getStatus());
        	System.debug('STATUS_CODE:'+searchRes.getStatusCode());
            System.debug(searchRes.getBody());
            String status = searchRes.getStatus();

            	if (status == 'Not Found'){
                    createRepoReq.setMethod('POST');
                    createRepoReq.setHeader('content-type', 'application/json');
                    createRepoReq.setHeader('User-Agent', 'salesforce');
                    createRepoReq.setHeader('Connection','keep-alive');
                    createRepoReq.setEndpoint(endPoint + createRepo);
                    createRepoReq.setHeader('Date',String.valueOf(System.now())); 
                    createRepoReq.setHeader('Authorization'  , 'token '+token); 
                    JSONGenerator gen = JSON.createGenerator(true);
                    gen.writeStartObject();
                    gen.writeStringField('name', theOpportunity);
                    gen.writeBooleanField('auto_init', true);
                    gen.writeBooleanField('private', false);
                    gen.writeBooleanField('has_downloads', true);
                    gen.writeBooleanField('has_issues', true);
                    gen.writeBooleanField('has_downloads', true);
                    gen.writeEndObject();     
                    String jsonRepos = gen.getAsString();
                    System.debug('jsonRepos: ' + jsonRepos);
                    createRepoReq.setBody(jsonRepos); 	
                    try {
        				//Execute web service call here		
        				HTTPResponse createRes = http.send(createRepoReq);	
        				//Helpful debug messages
        				System.debug(createRes.toString());
        				System.debug('STATUS:'+createRes.getStatus());
        				System.debug('STATUS_CODE:'+createRes.getStatusCode());
            			System.debug(createRes.getBody());
                        tempOpp = [SELECT Id FROM Opportunity WHERE Id = :theOpportunity];
        				JSONParser parser = JSON.createParser(createRes.getBody());
        					while (parser.nextToken() != null) {                
            					if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)&&(parser.getText() == 'id')) {              					   
                    				// Get the value.
                					parser.nextToken();
                					tempOpp.Git_ID__c = String.valueOf(parser.getIntegerValue());                                    
                    				System.debug('Git Name = ' + parser.getText());
                 					System.debug('ID Val: ' + String.valueOf(parser.getIntegerValue()));                                      
            					}//END IF
                                if (((parser.getCurrentToken() == JSONToken.FIELD_NAME)&&(parser.getText() == 'html_url'))){
                                    parser.nextToken();
                                    tempOpp.Git_Clone_URL__c = parser.getText();
                                }//END IF
                                                               
        					}//END WHILE  
                        tempOpps.add(tempOpp);
                    } catch(System.CalloutException e) {
                    //Exception handling goes here....
                    }//END TRY CATCH
                    }else{
                        System.debug('SHOULD HAVE IGNORED CODE (ONLY RELEVANT FOR UPDATE)');
                    	continue;
                    }
     }catch(System.CalloutException e) {
			//Exception handling goes here....
			}//END TRY CATCH         
        }//END FOR (Opportunity Itterations)
        	List<Opportunity> listTempOpps = new List<Opportunity>();
        
        listTempOpps.addAll(tempOpps);
        UPDATE listTempOpps;
	}//END METHOD
}//END CLASS