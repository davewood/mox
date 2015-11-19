package Mox::Web::Controller::REST::Song;
use Moose;
use Try::Tiny;
use JSON qw/ to_json /;
use MIME::Base64 qw//;
use MIME::Types qw//;
extends 'Mox::Web::Controller::REST::Base';
has '+resultset_name' => (default => 'Song');

sub _process_upload {
    my ( $self, $params ) = @_;
    my $file = delete $params->{file};
    my $decoded = MIME::Base64::decode($file);
    use File::Temp qw//;
    my $fh = File::Temp->new( UNLINK => 1 );
    print $fh $decoded;
    # https://rt.cpan.org/Ticket/Display.html?id=109082
    seek $fh, 0, 0;
    $params->{file} = $fh;
}

sub _process_mime {
    my ( $self, $params ) = @_;
    my $filename = delete $params->{filename};
    my $mt = MIME::Types->new;
    my $mime = $mt->mimeTypeOf($filename);
    $params->{type} = $mime->type;
}

sub root_PUT {
    my ( $self, $req ) = @_;

    my $params = $req->parameters;
    $self->_process_upload($params);
    $self->_process_mime($params);

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
            [ 'Content-Type' => 'text/plain' ],
            [ "$e" ]
        ];
    };
    return $error if $error;

    return [
        200,
        [ 'Content-Type' => 'application/json' ],
        [ to_json( { $item->get_columns } ) ]
    ];
}

__PACKAGE__->meta->make_immutable;
1;
