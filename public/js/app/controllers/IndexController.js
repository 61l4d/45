function IndexController(SessionService,$window,$sce){
  var ctrl = this;

  ctrl.messageTitle = "A message from AppJoin:";
  ctrl.message = $sce.trustAsHtml("hello");
  ctrl.buttonText = "Send";
    
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
        ctrl.message = $sce.trustAsHtml('SE user <a href="http://stackexchange.com/users/' + data.confirm_update_se_account + '" target="_blank">' + data.confirm_update_se_account + '</a> is linked with this account, but you signed in with SE user <a href="http://stackexchange.com/users/' + data.se_data.se_id + '" target="_blank">' + data.se_data.se_id + '</a>. Please type "yes" below to update our records to the new SE account, or type "no" to be redirected back to login. Click "Send" when you\'re ready.');

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
