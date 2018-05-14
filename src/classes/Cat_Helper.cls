public class Cat_Helper {
    
    @future(callout=true)
    public static void catBreedFeedback(Id catId){
        System.debug('@@@ Cat_Helper catBreedFeedback()');
        
        Cat__c cat = [SELECT Id, modelId__c, Cat_Breed__c FROM Cat__c WHERE Id = :catId LIMIT 1];
        System.debug('*** cat.modelId__c ' + cat.modelId__c);
        System.debug('*** cat.Cat_Breed__c ' + cat.Cat_Breed__c);
        
        Einstein_PredictionService Service = new Einstein_PredictionService(Einstein_PredictionService.Types.IMAGE);
        
    }
    
}