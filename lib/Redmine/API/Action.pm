#
# This file is part of Redmine-API
#
# This software is copyright (c) 2012 by celogeek <me@celogeek.com>.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
package Redmine::API::Action;

# ABSTRACT: Action to the API
use strict;
use warnings;
our $VERSION = '0.01';    # VERSION
use Moo;
use Carp;
use Data::Dumper;

use Net::HTTP::Spore;
use JSON::XS;

has 'request' => (
    is  => 'ro',
    isa => sub {
        croak "request should be a Redmine::API::Request object"
            unless ref $_[0] eq 'Redmine::API::Request';
    },
    required => 1,
);

has 'action' => (
    is       => 'ro',
    required => 1,
);

has '_spec' => ( is => 'lazy', );

sub _build__spec {
    my ($self) = @_;
    my $request = $self->request;

    my $spec = encode_json(
        {   version => 1.0,
            methods => {
                'create' => {
                    path           => '/' . $request->route . '.json',
                    method         => 'POST',
                    authentication => 1,
                },
                'all' => {
                    path           => '/' . $request->route . '.json',
                    method         => 'GET',
                    authentication => 1,
                },
                'get' => {
                    path           => '/' . $request->route . '/:id.json',
                    method         => 'GET',
                    authentication => 1,
                },
                'update' => {
                    path           => '/' . $request->route . '/:id.json',
                    method         => 'PUT',
                    authentication => 1,
                },
                'del' => {
                    path           => '/' . $request->route . '/:id.json',
                    method         => 'DELETE',
                    authentication => 1,
                },
            },
            api_format => [ 'json', ],
            name       => 'Redmine',
            author     => ['celogeek <me@celogeek.com>'],
            meta       => {
                "documentation" =>
                    "http://www.redmine.org/projects/redmine/wiki/Rest_api"
            },
        }
    );

    return $spec;
}

has '_spore' => ( is => 'lazy', );

sub _build__spore {
    my ($self) = @_;
    my $api = $self->request->api;

    my $spore = Net::HTTP::Spore->new_from_string(
        $self->_spec,
        base_url => $api->base_url,
        trace    => $api->trace
    );
    $spore->enable('Format::JSON');
    $spore->enable(
        'Auth::Header',
        header_name  => 'X-Redmine-API-Key',
        header_value => $api->auth_key,
    );

    return $spore;
}

sub create {
    my ( $self, %data ) = @_;
    return $self->_spore->create( payload => { $self->action => \%data } );
}

sub all {
    my ( $self, %options ) = @_;
    return $self->_spore->all(%options);
}

sub get {
    my ( $self, $id, %options ) = @_;
    return $self->_spore->get( id => $id, %options );
}

sub del {
    my ( $self, $id ) = @_;
    return $self->_spore->del( id => $id );
}

sub update {
    my ( $self, $id, %data ) = @_;
    return $self->_spore->update(
        id      => $id,
        payload => { $self->action => \%data }
    );
}
1;

__END__
=pod

=head1 NAME

Redmine::API::Action - Action to the API

=head1 VERSION

version 0.01

=head1 METHODS

=head2 create

Create entry into Redmine.

Args: %data

data is pass thought payload

=head2 all

Get all data from Redmine.

Args: %options

You can pass offset, limit ...

=head2 get

Get one entry from Redmine.

Args: $id, %options

=head2 del

Delete one entry from Redmine

Args: $id

=head2 update

Update one entry from Redmine

Args: $id, %data

data is pass thought payload to Redmine

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/celogeek/Redmine-API/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

celogeek <me@celogeek.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by celogeek <me@celogeek.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

