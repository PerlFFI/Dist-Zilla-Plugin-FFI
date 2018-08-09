use strict;
use warnings;
use 5.014;

package Dist::Zilla::Plugin::FFI {

  use Moose;
  use namespace::autoclean;

  # ABSTRACT: FFI related Dist::Zilla plugins

  __PACKAGE__->meta->make_immutable;
}

1;