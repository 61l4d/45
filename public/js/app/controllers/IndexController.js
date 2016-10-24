function IndexController(SessionService,InteractionService,$window,$sce){
  var ctrl = this;

  ctrl.messageTitle = '';
  ctrl.buttonText = 'Send';
  // ctrl.buttonClick = function
  ctrl.inputRequested = false;
  ctrl.myLocationMessage = 'Retrieving data...';
    
  // retrieve session information and post location
  SessionService.getSessionInfo().then(function(resp){
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
    } else if (data.session.confirm_update_se_account){
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
      // session data
      ctrl.session = data.session

      // general message
      ctrl.message = $sce.trustAsHtml("Welcome " + (ctrl.session.new_user_created ? '' : 'back ') + ctrl.session.fb_data.name + '!');

      // my location message
      if (!ctrl.session.my_location){
        ctrl.myLocationMessage = 'Please consider setting your location to enable other nearby users to find you.';
      
      } else {
        ctrl.region = ctrl.session.my_location.region;
        ctrl.setRegion();

        if (ctrl.session.my_location.country){
          ctrl.country = ctrl.session.my_location.country;
          ctrl.setCountry();
        }

        if (ctrl.session.my_location.division){
          ctrl.cityState = ctrl.session.my_location.division;
        }
        ctrl.myLocationMessage = '';
      }
    }
  });

  // user location
  ctrl.regions = [''].concat(Object.keys(countries));
  ctrl.setRegion = function(){
    if (ctrl.region){
      ctrl.countries = countries[ctrl.region].split('|');
      ctrl.cityStates = [];
    
    } else {
      ctrl.countries = [];
      ctrl.cityStates = [];
    }
  };

  ctrl.setCountry = function(){
    if (ctrl.country){
      ctrl.cityStates = city_states[ctrl.country].split('|'); 
    }
  }

  // update user location
  ctrl.updateMyLocation = function(){
    if (!(ctrl.region === undefined || !ctrl.region.match(/\S/)) || confirm('Are you sure you want to unset your location details?')){
      var postData = {
            interaction: {
              command: 'update my location',
              parameters: [ctrl.region,ctrl.country,ctrl.cityState]
            }
          };

      InteractionService.update(postData).then(function(resp){
        var data = resp.data;
console.log(data)
        if (data.error !== undefined){
          alert ('There was an error updating location: \n' + data.error.message);
        
        } else {
          ctrl.myLocationMessage = data.location_string.match(/\S/) 
                                 ? 'Location updated to ' + data.location_string + '.'
                                 : 'Location details unset.';
        }
      });
    }
  }
}

angular
  .module('app')
  .controller('IndexController',IndexController);
