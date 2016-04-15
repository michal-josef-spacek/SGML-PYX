# Pragmas.
use strict;
use warnings;

# Modules.
use File::Object;
use SGML::PYX;
use Test::More 'tests' => 8;
use Test::NoWarnings;
use Test::Output;

# Directories.
my $data_dir = File::Object->new->up->dir('data');

# Test.
my $obj = SGML::PYX->new;
my $right_ret = <<'END';
(element
END
stdout_is(
	sub {
		$obj->parsefile($data_dir->file('start_element1.sgml')->s);
		return;
	},
	$right_ret,
	'Test start of element.',
);

# Test.
$obj = SGML::PYX->new;
$right_ret = <<'END';
(element
Apar val
END
stdout_is(
	sub {
		$obj->parsefile($data_dir->file('start_element2.sgml')->s);
		return;
	},
	$right_ret,
	'Test start of element with attribute.',
);

# Test.
$obj = SGML::PYX->new;
$right_ret = <<'END';
(element
Apar val\nval
END
stdout_is(
	sub {
		$obj->parsefile($data_dir->file('start_element3.sgml')->s);
		return;
	},
	$right_ret,
	'Test start of element with advanced attribute.',
);

# Test.
$obj = SGML::PYX->new;
$right_ret = <<'END';
(prefix:element
END
stdout_is(
	sub {
		$obj->parsefile($data_dir->file('start_element4.sgml')->s);
		return;
	},
	$right_ret,
	'Test start of prefixed element.',
);

# Test.
$obj = SGML::PYX->new;
$right_ret = <<'END';
(prefix:element
Aprefix:par val
END
stdout_is(
	sub {
		$obj->parsefile($data_dir->file('start_element5.sgml')->s);
		return;
	},
	$right_ret,
	'Test start of prefixed element with prefixed attribute.',
);

# Test.
$obj = SGML::PYX->new;
$right_ret = <<'END';
(element
Apar val
END
stdout_is(
	sub {
		$obj->parsefile($data_dir->file('start_element6.sgml')->s);
		return;
	},
	$right_ret,
	'Test start of element with attribute with extra spaces.',
);

# Test.
$obj = SGML::PYX->new;
$right_ret = <<'END';
(element
Achecked checked
END
stdout_is(
	sub {
		$obj->parsefile($data_dir->file('start_element7.sgml')->s);
		return;
	},
	$right_ret,
	'Test start of element with attribute without value.',
);
