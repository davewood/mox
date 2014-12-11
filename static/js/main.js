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
            $.getJSON(
                    "/rest/users",
                    function( data ) {
                        var mappedUsers = $.map(
                                                data,
                                                function(item) { return new User(item.username); }
                                            );
                        self.users(mappedUsers);
                    }
                );
        }
        self.loadUsers();
    }

    ko.applyBindings(new UsersViewModel());

});
