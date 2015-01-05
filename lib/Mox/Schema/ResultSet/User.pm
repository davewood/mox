package Mox::Schema::ResultSet::User;
use base 'DBIx::Class::ResultSet';
use strict;
use warnings;
use Params::Validate qw/ :all /;

my $validate_create =  {
    username => { type => SCALAR, regex => qr/^[a-zA-Z0-9]{5,}$/ },
};
my $validate_update = {
    map { $_, { %{$validate_create->{$_}}, optional => 1 } } keys %$validate_create
};

sub validate_create {
    my $self = shift;
    my %p = validate_with(
        params  => \@_,
        spec    => $validate_create,
        on_fail => sub { die "$_[0]\n" },
    );
    return \%p;
}
sub validate_update {
    my $self = shift;
    my %p = validate_with(
        params  => \@_,
        spec    => $validate_update,
        on_fail => sub { die "$_[0]\n" },
    );
    return \%p;
}

1;
