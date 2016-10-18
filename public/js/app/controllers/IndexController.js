function IndexController(SessionService,InteractionService,$window,$sce){
  var ctrl = this;

  ctrl.messageTitle = "Message from AppJoin:";
  ctrl.buttonText = "Send";
  // ctrl.buttonClick = function
  ctrl.inputRequested = false;
    
  // retrieve session information and post location
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
        ctrl.message = $sce.trustAsHtml('SE user <a href="http://stackexchange.com/users/' + data.confirm_update_se_account + '" target="_blank">' + data.confirm_update_se_account + '</a> is linked with this account, but you signed in with SE user <a href="http://stackexchange.com/users/' + data.se_data.se_id + '" target="_blank">' + data.se_data.se_id + '</a>. Please type "yes" below to update our records to the new SE account, or type "no" to be redirected back to login. Click "Send" when you\'re ready. Please note that if you are logged into SE through StackExchange OpenID you must log out of both Stack Exchange (<a href="https://stackexchange.com/users/logout" target="_blank">https://stackexchange.com/users/logout</a>) and Stack Exchange OpenId here: <a href="https://openid.stackexchange.com/user" target="_blank">https://openid.stackexchange.com/user</a> or clear the browser data to be able to log in as a new user to StackExchange.');
        ctrl.inputRequested = true;

        ctrl.buttonClick = function(){
          var input = ctrl.input.replace(/^\s+|\s+$/i,'').toLowerCase();

          if (input === 'yes'){
            var postData = {
              interaction: {
                command: 'update se account',
                parameters: []
              }
            };

            InteractionService.update(postData).then(function(resp){
console.log(resp.data);
              var data = resp.data;

              if (data.error !== undefined){
                alert(data.error.message);
              
              } else {
                ctrl.message = $sce.trustAsHtml(data.message);
                ctrl.input = '';
                ctrl.inputRequested = false;
                ctrl.buttonClick = null;
              }
            });

          } else if (input === 'no'){
            $window.location = '/t';
          }
        };

      // regular login without se update or error
      } else {
        ctrl.session = {
          fb: data.fb_data,
          se: data.se_data
        };

        ctrl.message = $sce.trustAsHtml("Welcome " + (data.new_user_created ? '' : 'back ') + ctrl.session.fb.name + '!');
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
        ctrl.postSessionInfo(); 
      }
    );


  // user location
  ctrl.regions = [''].concat(Object.keys(countries));
  ctrl.setRegion = function(){
    if (ctrl.region){
      ctrl.countries = countries[ctrl.region].split('|');
      ctrl.cityStates = [];
    }
  };

  ctrl.setCountry = function(){
    if (ctrl.country){
      ctrl.cityStates = city_states[ctrl.country].split('|'); 
    }
  }
}

angular
  .module('app')
  .controller('IndexController',IndexController);
