function SessionService($http){
  var svc = this;

  svc.getSessionInfo = function(data){
    return $http.get('/sessions/info');
  }
}

angular
  .module('app')
  .service('SessionService',SessionService);
