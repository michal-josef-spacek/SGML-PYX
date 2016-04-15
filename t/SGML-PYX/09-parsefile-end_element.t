# Pragmas.
use strict;
use warnings;

# Modules.
use File::Object;
use SGML::PYX;
use Test::More 'tests' => 2;
use Test::NoWarnings;
use Test::Output;

# Directories.
my $data_dir = File::Object->new->up->dir('data');

# Test.
my $obj = SGML::PYX->new;
my $right_ret = <<'END';
)element
END
stdout_is(
	sub {
		$obj->parsefile($data_dir->file('end_element1.sgml')->s);
		return;
	},
	$right_ret,
	'Test end of element.',
);
