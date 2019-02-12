package Dist::Zilla::Plugin::FFI::Build {

  use 5.014;
  use Moose;
  use List::Util qw( first );

=head1 SYNOPSIS

 [FFI::Build]

=head1 DESCRIPTION

This plugin adds the appropriate hooks for L<FFI::Build::MM> into your
C<Makefile.PL>.  It does not work with L<Module::Build>.

=cut

  # TODO: also add build and test prereqs for aliens
  # TODO: release as separate CPAN dist
  with 'Dist::Zilla::Role::FileMunger',
       'Dist::Zilla::Role::MetaProvider',
       'Dist::Zilla::Role::PrereqSource',
  ;

my $mm_code_prereqs = <<'EOF1';
use FFI::Build::MM 0.83;
my $fbmm = FFI::Build::MM->new;
%WriteMakefileArgs = $fbmm->mm_args(%WriteMakefileArgs);
EOF1

my $mm_code_postamble = <<'EOF2';
BEGIN {
  # append to any existing postamble.
  if(my $old = MY->can('postamble'))
  {
    no warnings 'redefine';
    *MY::postamble = sub {
      $old->(@_) .
      "\n" .
      $fbmm->mm_postamble;
    };
  }
  else
  {
    *MY::postamble = sub {
      $fbmm->mm_postamble;
    };
  }
}
EOF2

  my $comment_begin = "# BEGIN code inserted by @{[ __PACKAGE__ ]}\n";
  my $comment_end   = "# END code inserted by @{[ __PACKAGE__ ]}\n";

  sub munge_files
  {
    my($self) = @_;
    my $file = first { $_->name eq 'Makefile.PL' } @{ $self->zilla->files };
    $self->log_fatal("unable to find Makefile.PL")
      unless $file;
    my $content = $file->content;
    my $ok = $content =~ s/(unless \( eval \{ ExtUtils::MakeMaker)/"$comment_begin$mm_code_prereqs$comment_end\n\n$1"/e;
    $self->log_fatal('unable to find the correct location to insert prereqs')
      unless $ok;
    $content .= "\n\n$comment_begin$mm_code_postamble$comment_end\n";
    $file->content($content);
  }

  sub register_prereqs {
    my ($self) = @_;
    $self->zilla->register_prereqs( +{
        phase => 'configure',
        type  => 'requires',
      },
      'FFI::Build::MM' => '0.83',
    );
  }

  sub metadata
  {
    my($self) = @_;
    my %meta = ( dynamic_config => 1 );
    \%meta;
  }
  
  __PACKAGE__->meta->make_immutable;
}

1;
