package Dist::Zilla::Plugin::FFI {

  use strict;
  use warnings;
  use 5.020;

  # ABSTRACT: FFI related Dist::Zilla plugins

=head1 SYNOPSIS

 [FFI::Build]
 [FFI::CheckLib]

=head1 DESCRIPTION

This distribution contains some useful plugins for working with L<FFI::Platypus> and friends.

=head1 SEE ALSO

=over 4

=item L<Dist::Zilla::Plugin::FFI::Build>

Install the L<FFI::Build::MM> layer into your C<Makefile.PL>.

=item L<Dist::Zilla::Plugin::FFI::CheckLib>

Add L<FFI::CheckLib> checks into your C<Makefile.PL>.

=back

=cut

}

1;
