$(document).ready(function(){

    function User(initialName) {
        var self = this;
        self.username = ko.observable(initialName);
    }

    function UsersViewModel() {
        var self = this;

        self.users = ko.observableArray([]);

        // Operations
        self.loadUsers = function() {
            $.get(
                    "/rest/users",
                    function( data ) {
                        for (var i = 0; i < data.length; i++) {
                            self.users.push(new User(data[i].username));
                        }
                    }
                );
        }
        self.loadUsers();
    }

    ko.applyBindings(new UsersViewModel());

});
