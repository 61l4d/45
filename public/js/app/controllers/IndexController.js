function IndexController(SessionService){
  var ctrl = this;

  ctrl.test = "hello";

  // get session info
  SessionService.getSessionInfo().then(function(resp){
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
}

angular
  .module('app')
  .controller('IndexController',IndexController);
