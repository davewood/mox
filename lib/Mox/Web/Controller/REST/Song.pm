package Mox::Web::Controller::REST::Song;
use Moose;
use Try::Tiny;
use JSON qw/ to_json /;
use MIME::Base64 qw//;
extends 'Mox::Web::Controller::REST::Base';
has '+resultset_name' => (default => 'Song');

sub root_PUT {
    my ( $self, $req ) = @_;

    my $params = $req->parameters;
    my $file = $params->{file};
    my $filename =$self->resultset->result_source->column_info('file')->{fs_column_path};
    my $decoded = MIME::Base64::decode($file);

    # https://rt.cpan.org/Ticket/Display.html?id=109082
    use File::Temp qw//;
    my $fh = File::Temp->new( UNLINK => 1 );
    print $fh $decoded;
    seek $fh, 0, 0;

    $params->{file} = $fh;

    my ($error, $item);
    try {
        my $item_rs = $self->resultset;
        my $p = $item_rs->validate_create( $params );
        $item = $item_rs->create($p);
    }
    catch {
        my $e = shift;
        $error = [
            422,
            [ 'Content-type' => 'text/plain' ],
            [ "$e" ]
        ];
    };
    return $error if $error;

    return [
        200,
        [ 'Content-type' => 'application/json' ],
        [ to_json( { $item->get_columns } ) ]
    ];
}

__PACKAGE__->meta->make_immutable;
1;
