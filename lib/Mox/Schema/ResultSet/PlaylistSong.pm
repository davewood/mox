package Mox::Schema::ResultSet::PlaylistSong;
use base 'DBIx::Class::ResultSet';
use strict;
use warnings;
use Params::Validate qw/ :all /;

sub default_order {
    my ( $self ) = @_;
    my $alias = $self->current_source_alias;
    return $self->search_rs(
        undef,
        { order_by => { -asc => [ "$alias.playlist_id", "$alias.position" ] } }
    );
    return $self;
}

my $validate_create = {
    playlist_id => { type => SCALAR, regex => qr/^\d$/ },
    song_id     => { type => SCALAR, regex => qr/^\d$/ },
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
sub validate_move {
    my $self = shift;
    my %p = validate_with(
        params  => \@_,
        spec    => { position => { type => SCALAR, regex => qr/^\d$/ } },
        on_fail => sub { die "$_[0]\n" },
    );
    return \%p;
}

1;
