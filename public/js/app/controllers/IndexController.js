function IndexController(){
  var ctrl = this;

  ctrl.test = "hello";
}

angular
  .module('app')
  .controller('IndexController',IndexController);
