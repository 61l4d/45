function SessionService($http){
  var svc = this;

  svc.postSessionInfo = function(data){
    return $http.post('/sessions/info',data);
  }
}

angular
  .module('app')
  .service('SessionService',SessionService);
