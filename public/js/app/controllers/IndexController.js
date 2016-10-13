function IndexController(SessionService,$window){
  var ctrl = this;

  ctrl.test = "hello";
    
  ctrl.postSessionInfo = function(location_data){
    SessionService.postSessionInfo(location_data).then(function(resp){
      var data = resp.data;
 
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
  };

  // post geolocation and get session info

  $window.navigator.geolocation.getCurrentPosition(
      // success
      function (position){
        ctrl.postSessionInfo({
          position: { 
            latitude: position.coords.latitude,
            longitude: position.coords.longitude
          }
        });
      },

      // error
      function (){ 
        ctrl.postSessionInfo({}); 
      }
    );
}

angular
  .module('app')
  .controller('IndexController',IndexController);
