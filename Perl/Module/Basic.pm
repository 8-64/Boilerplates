package Module::Basic;

# Target Perl version, enable stable features, strict mode & warnings 
use v5.16;
use warnings;

# Module version
our $VERSION = v0.1;

# Some inheritance, set by hand
our (@ISA) = ('UNIVERSAL');

# Will be called when "use Module;" is used
sub import {
    my ($self, @args) = @_;

    print qq[Module "$self" with args "@args" was used\n];
}

# Will be called when "no Module;" is used
sub unimport {
    my ($self, @args) = @_;

    print qq[Module "$self" with args "@args" was unused\n];
}

# Constructor
sub new {
    my ($class, %data) = @_;
    %data = (
        default => 'value',
        %data
    );

    bless(\%data => $class);
}

# Autoloading undeclared methods
our $AUTOLOAD;
sub AUTOLOAD {
    my $method = $AUTOLOAD;
    $method    =~ s/.*:://;

    my ($object, @args) = (ref $_[0] eq __PACKAGE__) ?
                                                  @_ :
                                             ('', @_);

    print qq[Called undeclared method "$method" on object "$object" with arguments "@args"\n];
}

sub DESTROY {
    my ($self) = @_;

    print qq[Object "$self" is about to be garbage collected.\n];
}

# ATTRIBUTES HANDLING
# Custom attributes should have at least one CaPiTaL letter in them in order
# to distinguish from any possible future reserved word
# Could be named UNIVERSAL::MODIFY_<TYPE>_ATTRIBUTES to apply for everything
# Types: "SCALAR", "ARRAY", "HASH", "CODE", (uc reftype $self)
sub UNIVERSAL::MODIFY_SCALAR_ATTRIBUTES {
    my ($class, $self, @attributes) = @_;
    my @bad_attributes = ();

    print "Attributes [@attributes] for item [$self] of class [$class] are processed.\n";

    # Must return an empty list if everything is OK, otherwise - list of bad
    # attributes 
    @bad_attributes;
}

1;

__END__

More rare boilerplates of predefined methods:

# Fetch attributes
# Invoked via "attributes::get($self);"
sub UNIVERSAL::FETCH_SCALAR_ATTRIBUTES {
    my ($class, $self) = @_;
    my (@list_of_attributes) = ();

    # Should return list of associated attributes
    @list_of_attributes;
}

=pod

=encoding UTF-8

=head1 NAME

Module::Basic - short module description after hyphen

=head1 VERSION

Version 0.1

=head1 SYNOPSIS

	# Code sample(s) of how to use this module
	use Module;
	my $obj = Module->new(parameter => 'value');
	my $result = $obj->method;

=head1 DESCRIPTION

Detailed description of this module. What it does, what is idea behind it.

=head2 Introduction

Introductory info on this module

=head1 EXAMPLES

Some more examples of usage.

	# Additional examples
	# Besides the ones in the SYNOPSIS section
 
=head1 METHODS

=head2 new

Class constructor

=head3 new() PARAMETERS

=over 4

=item "Default"

What this parameter sets up

=back

=head1 VARIABLES

Any exposed by this module variables

=head1 CONSTANTS

Any exported by this module constants

=head1 OPTIONS

Any options related to this Module. Printed on level 1 or 2 of "pod2usage" verbosity

=head1 ARGUMENTS

Any arguments related to this Module. Printed on level 1 or 2 of "pod2usage" verbosity

=head1 CAVEATS

Any peculiarities on how to use this module.

=head1 SEE ALSO

Related information

=head1 FAQ

See link L<http://to.the.faq.com/> or list of Q and A.

=head1 AUTHORS

Name Surname, mail@host.com, year-year

=head1 COPYRIGHT AND LICENSE

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
