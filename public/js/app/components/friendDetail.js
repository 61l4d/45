var friendDetail = {
  templateUrl: '/templates/friend_detail_template.html',
  controller: IndexController,
  bindings: {
    friend: '<'
  }
}

angular
  .module('app')
  .component('friendDetail',friendDetail)
