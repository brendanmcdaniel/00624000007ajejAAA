global class receiveRepo {
    
    
    global class Repo {
	      webservice String name;
	      webservice boolean auto_init;
	      webservice String description;
          webservice boolean has_downloads;
	      webservice Id planId;
          webservice boolean isPrivate;
	   }
    
    
    webservice static Repo receiveRepo(List<Opportunity> opps){
        Repo theRepo = new Repo();
	return theRepo;
        
        
    }

}