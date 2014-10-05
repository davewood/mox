var moxApp = angular.module('moxApp', []);

moxApp.controller('UserListCtrl', function ($scope, $http) {
  $http.get('/rest/users').success(function(data) {
    $scope.users = data;
  });
});
