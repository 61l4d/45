function IndexController(SessionService,$q,$window){
  var ctrl = this;

  ctrl.test = "hello";

  // post geolocation and get session info

  var asyncGeolocationPermission = function (){
    var deferred = $q.defer();

    var getLocation = $window.navigator.geolocation.getCurrentPosition(
        // success
        function (position){
          deferred.resolve(position.coords);
        },

        // error
        function (){ 
          deferred.resolve(null); 
        }
      );
    
    return deferred.promise;
  };

  asyncGeolocationPermission().then(function(location_data){
    SessionService.postSessionInfo(location_data).then(function(resp){
      var data = resp.data;
  console.log(data)
      if (data.error !== undefined){
        alert (
            'There was an error retrieving session information: \n'
          + data.error.message
          + '\n\nClick OK to return to login page.'
        );
        
        window.location = "/t";

      } else {
        ctrl.session = {
          fb: data.fb_data,
          se: data.se_data
        };
  console.log(ctrl.session);
      }
    });
  });
}

angular
  .module('app')
  .controller('IndexController',IndexController);
