#!/usr/bin/perl

use v5.24;

package Example {
    sub new {
        my ($package, %data) = @_;
        bless \%data => $package;
    }

    sub set_without_lvalue {
        my ($self, $what, $value) = @_;
        $self->{$what} = $value;
    }

    sub set_with_lvalue :lvalue {
        my ($self, $what) = @_;
        $self->{$what};
    }

    sub get {
        my ($self, $what) = @_;
        return $self->{$what};
    }
}

my $test = Example->new(foo => 100);
say $test->get('foo');

$test->set_without_lvalue(foo => 300);
say $test->get('foo');

$test->set_with_lvalue('foo') = 200;
say $test->get('foo');
