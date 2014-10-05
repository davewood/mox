var moxApp = angular.module('moxApp', []);

moxApp.controller('UserListCtrl', function ($scope) {
  $scope.users = [
    {'username': 'david' },
    {'username': 'john' },
    {'username': 'leni' }
  ];
});
