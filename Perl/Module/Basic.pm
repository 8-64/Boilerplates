package Module::Basic;

# Target Perl version, enable stable features, strict mode & warnings 
use v5.16;
use warnings;

# Module version
our $VERSION = v0.1;

# Some inheritance, set by hand
our (@ISA) = ('Module::Any');

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

# Custom handling of entries in @INC array
# Will be called if nothing is found using entries in @INC before an object of 
# this class
sub Module::Basic::INC {
    my ($self, $module) = @_;

    print "Resolving module [$module], called on object [$self]\n";

    # This method should return either nothing, or list of up to four next
    # values:
    # 1) A reference to a scalar, containing any initial source code to prepend
    # to the file or generator output.
    # 2) A filehandle, from which the file will be read.
    # 3) A reference to a subroutine. If there is no filehandle (previous
    # item), then this subroutine is expected to generate one line of source
    # code per call, writing the line into $_ and returning 1, then finally at
    # end of file returning 0. If there is a filehandle, then the subroutine
    # will be called to act as a simple source filter, with the line as read in
    # $_ . Again, return 1 for each valid line, and 0 after all lines have been
    # returned.
    # 4) Optional state for the subroutine. The state is passed in as $_[1] .
    # A reference to the subroutine itself is passed in as $_[0] .
    return (
        \"print qq[Resolved inclusion of a module ($module).\n];"
    );
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

    # If a new method was auto-generated, it is often a good idea to jump
    # to it, erasing this step in the call stack, using "goto &sub;" form. 
}

sub DESTROY {
    my ($self) = @_;

    print qq[Object "$self" is about to be garbage collected.\n];
}

# ATTRIBUTES HANDLING
# Custom attributes should have at least one CaPiTaL letter in them in order
# to distinguish from any possible future reserved word
# Could be named UNIVERSAL::MODIFY_<TYPE>_ATTRIBUTES to apply for attributes
# of the particular data type
# Data types: "SCALAR", "ARRAY", "HASH", "CODE", (uc reftype $self)
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
