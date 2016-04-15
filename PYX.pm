package SGML::PYX;

# Pragmas.
use strict;
use warnings;

# Modules.
use Class::Utils qw(set_params);
use Encode qw(encode_utf8);
use Error::Pure qw(err);
use Tag::Reader::Perl;
use PYX qw(comment end_element char instruction start_element);
use PYX::Utils qw(decode entity_decode);

# Version.
our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my $self = bless {}, $class;

	# Output callback.
	$self->{'output'} = sub {
		my (@data) = @_;
		print join "\n", map { encode_utf8($_) } @data;
		print "\n";
		return;
	};

	# Process params.
	set_params($self, @params);

	# Object.
	$self->{'_tag_reader'} = Tag::Reader::Perl->new;

	# Object.
	return $self;
}

# Parse file.
sub parsefile {
	my ($self, $sgml_file) = @_;

	# Set file.
	$self->{'_tag_reader'}->set_file($sgml_file);

	# Process.
	while (my ($data, $tag_type, $line, $column)
		= $self->{'_tag_reader'}->gettoken) {

		# Data.
		if ($tag_type eq '!data') {
			$self->{'output'}->(char(decode(entity_decode($data))));

		# Comment.
		} elsif ($tag_type eq '!--') {
			$data =~ s/^<!--//ms;
			$data =~ s/-->$//ms;
			$self->{'output'}->(comment($data));

		# End of element.
		} elsif ($tag_type =~ m/^\/(.*)$/ms) {
			$self->{'output'}->(end_element($1));

		# Begin of element.
		} elsif ($tag_type =~ m/^\w+/ms) {
			$data =~ s/^<//ms;
			$data =~ s/>$//ms;
			my $end = 0;
			if ($data =~ s/\/$//ms) {
				$end = 1;
			}
			my @data = split m/(?<=[^=])\s+(?!=)/ms, $data;
			shift @data;
			my @attr;
			foreach my $data (@data) {
				my ($key, $val) = split m/\s*=\s*/ms, $data;
				$val =~ s/^["\']*\s*//ms;
				$val =~ s/\s*["\']*$//ms;
				push @attr, $key, $val;
			};
			$self->{'output'}->(start_element($tag_type, @attr));
			if ($end) {
				$self->{'output'}->(end_element($tag_type));
			}

		# Doctype.
		} elsif ($tag_type eq '!doctype') {
			# Nop.

		# CData.
		} elsif ($tag_type eq '![cdata[') {
			# Nop.

		# XML.
		} elsif ($tag_type eq '?xml') {
			my ($code) = $data =~ m/^<\?xml\s+(.*?)\s*\?>$/ms;
			$self->{'output'}->(instruction('xml', $code));

		} else {
			err "Unsupported tag type '$tag_type'.";
		}
	}

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

SGML::PYX - Convertor between SGML and PYX.

=head1 SYNOPSIS

 use SGML::PYX;
 my $obj = SGML::PYX->new(%params);
 $obj->parsefile($sgml_file);

=head1 METHODS

=over 8

=item C<new(%params)>

 Constructor.

=over 8

=item * C<output>

 Output callback, which prints output PYX code.
 Default value is subroutine:
   my (@data) = @_;
   print join "\n", map { encode_utf8($_) } @data;
   print "\n";
   return;

=back

=item C<parsefile($sgml_file)>

 Parse input SGML file and convert to PYX output.
 Returns undef.

=back

=head1 ERRORS

 new():
         From Class::Utils::set_params():
                 Unknown parameter '%s'.

 parsefile():
         Unsupported tag type '%s'.

=head1 EXAMPLE

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use File::Temp qw(tempfile);
 use IO::Barf qw(barf);
 use SGML::PYX;

 # Input file.
 my (undef, $input_file) = tempfile();
 my $input = <<'END';
 <html><head><title>Foo</title></head><body><div /></body></html>
 END
 barf($input_file, $input);

 # Object.
 my $obj = SGML::PYX->new;

 # Parse file.
 $obj->parsefile($input_file);

 # Output:
 # (html
 # (head
 # (title
 # -Foo
 # )title
 # )head
 # (body
 # (div
 # )div
 # )body
 # )html
 # -\n

=head1 DEPENDENCIES

L<Class::Utils>,
L<Encode>,
L<Error::Pure>,
L<Tag::Reader::Perl>,
L<PYX>,
L<PYX::Utils>.

=head1 SEE ALSO

=over

=item L<Task::PYX>

Install the PYX modules.

=back

=head1 REPOSITORY

L<https://github.com/tupinek/SGML-PYX>

=head1 AUTHOR

Michal Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

 © Michal Špaček 2015-2016
 BSD 2-Clause License

=head1 VERSION

0.01

=cut
