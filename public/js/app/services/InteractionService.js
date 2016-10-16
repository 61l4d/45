function InteractionService($http){
  var svc = this;

  svc.update= function(data){
    return $http.post('/update',data);
  }
}

angular
  .module('app')
  .service('InteractionService',InteractionService);
