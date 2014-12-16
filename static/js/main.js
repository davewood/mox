$(document).ready(function(){

    function User(initialUsrId, initialName) {
        var self       = this;
        self.usr_id    = initialUsrId,
        self.username  = ko.observable(initialName);
        self.dirty     = ko.observable(false);
        self.markDirty = function() { self.dirty(true); };
        self.unmarkDirty = function() { self.dirty(false); self.error(''); };
        self.error     = ko.observable("");
        self.save      = function() {
            $.ajax({
                url: '/rest/users/' + self.usr_id,
                type: 'POST',
                data: { username: self.username },
                success: function(data) { self.unmarkDirty(); },
                error: function(xhr) { self.error(xhr.responseText) },
                dataType: 'json'
            });
        };
    }

    function UsersViewModel() {
        var self = this;

        self.users = ko.observableArray([]);

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
        }
        self.loadUsers();
    }

    ko.applyBindings(new UsersViewModel());
});
