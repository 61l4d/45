function IndexController(SessionService,$window){
  var ctrl = this;

  ctrl.message = "hello";
  ctrl.buttonText = "Submit";
    
  ctrl.postSessionInfo = function(location_data){
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

      // confirmation is needed to change linked se account 
      } else if (data.confirm_update_se_account){
        ctrl.message = 'SE user # ' + data.confirm_update_se_account + ' is linked with this account, but you signed in with user # ' + data.se_data.se_id + '<br>Type "yes" and below and click "Update" to update our records to the new SE account.';
        ctrl.buttonText = 'Update';

      } else {
        ctrl.session = {
          fb: data.fb_data,
          se: data.se_data
        };
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
