trigger Cat_Trigger on Cat__c (after update) {
    System.debug('@@@ Cat_Trigger');
    
    List<Cat__c> catList = new List<Cat__c>();
    for ( Integer i=0; i<Trigger.New.size(); i++ ){
        if(Trigger.New[i].Feedback__c && Trigger.New[i].modelId__c != null && Trigger.New[i].Cat_Breed__c != Trigger.Old[i].Cat_Breed__c){
            catList.add(Trigger.New[i]);
        }
    }
    for(Cat__c cat :catList){
        System.debug('*** cat ' + cat);
        Cat_Helper.catBreedFeedback(cat.Id);
    }
    
}