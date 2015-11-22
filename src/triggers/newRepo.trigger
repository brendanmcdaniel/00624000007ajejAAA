trigger newRepo on Opportunity (after insert) {

    List<Opportunity> opps = new List<Opportunity>();
    List<Id> oppIds = new List<Id>();
    List<String> oppNames = new List<String>();
	opps = Trigger.new; 
    
    for(Opportunity opp: Trigger.new){
        oppIds.add(opp.Id);
        oppNames.add(opp.Name);  
        System.debug('TRIGGER: '+ Opp.Id);
    }

    github.createRepo(oppIds, oppNames);
    
}