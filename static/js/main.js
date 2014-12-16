$(document).ready(function(){

    function User(initialUsrId, initialName) {
        var self       = this;
        self.usr_id    = initialUsrId,
        self.username  = ko.observable(initialName);
        self.dirty     = ko.observable(false);
        self.error     = ko.observable("");
        self.username.subscribe(function(newName) { self.dirty(true) });
        self.save = function() {
            $.ajax({
                url: '/rest/users/' + self.usr_id,
                type: 'POST',
                data: { username: self.username },
                success: function(data) { self.dirty(false); self.error('') },
                error: function(xhr) { self.error(xhr.responseText) },
                dataType: 'json'
            });
        };
    }

    function UsersViewModel() {
        var self = this;

        self.users        = ko.observableArray([]);
        self.newUserName  = ko.observable("");
        self.newUserError = ko.observable("");

        // Operations
        self.loadUsers = function() {
            $.getJSON(
                    "/rest/users",
                    function(data) {
                        var mappedUsers = $.map(
                            data,
                            function(item) { return new User(item.usr_id, item.username); }
                        );
                        self.users(mappedUsers);
                    }
                );
        };
        self.create = function() {
            $.ajax({
                url: '/rest/users',
                type: 'PUT',
                data: { username: self.newUserName },
                success: function(data) {
                            self.users.push( new User(data.usr_id, data.username) );
                            self.newUserError("")
                         },
                error: function(xhr) { self.newUserError(xhr.responseText) },
                dataType: 'json'
            });
        };
        self.removeUser = function() {
            $.ajax({
                url: '/rest/users/' + this.usr_id,
                type: 'DELETE',
                context: this,
                success: function(data) { self.users.remove(this); },
                error: function(xhr) { this.error(xhr.responseText) },
                dataType: 'json'
            });
        };

        self.loadUsers();
    }

    ko.applyBindings(new UsersViewModel());
});
