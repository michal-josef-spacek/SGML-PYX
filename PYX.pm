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
			# TODO Tohle je spatne.
			my @data = split m/\s+/ms, $data;
			shift @data;
			my @attr;
			foreach my $data (@data) {
				my ($key, $val) = split m/=/ms, $data;
				$val =~ s/^["\']//ms;
				$val =~ s/["\']$//ms;
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
