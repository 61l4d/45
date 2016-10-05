function SessionService($http){
  var svc = this;

  svc.getSessionInfo = function(){
    return $http.get('/sessions/info');
  }
}

angular
  .module('app')
  .service('SessionService',SessionService);
