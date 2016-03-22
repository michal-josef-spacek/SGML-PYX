# Pragmas.
use strict;
use warnings;

# Modules.
use File::Object;
use SGML::PYX;
use Test::More 'tests' => 18;
use Test::NoWarnings;
use Test::Output;

# Directories.
my $data_dir = File::Object->new->up->dir('data');

# Test.
my $obj = SGML::PYX->new;
my $right_ret = <<'END';
-char
END
stdout_is(
	sub {
		$obj->parsefile($data_dir->file('char1.sgml')->s);
		return;
	},
	$right_ret,
	'Test single character data.',
);

# Test.
$obj = SGML::PYX->new;
$right_ret = <<'END';
-char\nchar
END
stdout_is(
	sub {
		$obj->parsefile($data_dir->file('char2.sgml')->s);
		return;
	},
	$right_ret,
	'Test advanced character data.',
);

# Test.
$obj = SGML::PYX->new;
$right_ret = <<'END';
_comment
END
stdout_is(
	sub {
		$obj->parsefile($data_dir->file('comment1.sgml')->s);
		return;
	},
	$right_ret,
	'Test single comment.',
);

# Test.
$obj = SGML::PYX->new;
$right_ret = <<'END';
_comment\ncomment
END
stdout_is(
	sub {
		$obj->parsefile($data_dir->file('comment2.sgml')->s);
		return;
	},
	$right_ret,
	'Test advanced comment.',
);

# Test.
$obj = SGML::PYX->new;
$right_ret = <<'END';
(element
)element
END
stdout_is(
	sub {
		$obj->parsefile($data_dir->file('element1.sgml')->s);
		return;
	},
	$right_ret,
	'Test single element.',
);

# Test.
$obj = SGML::PYX->new;
$right_ret = <<'END';
(element
Apar val
)element
END
stdout_is(
	sub {
		$obj->parsefile($data_dir->file('element2.sgml')->s);
		return;
	},
	$right_ret,
	'Test single element with attribute.',
);

# Test.
$obj = SGML::PYX->new;
$right_ret = <<'END';
(element
Apar val\nval
)element
END
stdout_is(
	sub {
		$obj->parsefile($data_dir->file('element3.sgml')->s);
		return;
	},
	$right_ret,
	'Test single element with advanced attribute.',
);

# Test.
$obj = SGML::PYX->new;
$right_ret = <<'END';
(element
Apar1 val1
Apar2 val2
)element
END
stdout_is(
	sub {
		$obj->parsefile($data_dir->file('element4.sgml')->s);
		return;
	},
	$right_ret,
	'Test single element with multiple attributes.',
);

# Test.
$obj = SGML::PYX->new;
$right_ret = <<'END';
(xml
-text
)xml
END
stdout_is(
	sub {
		$obj->parsefile($data_dir->file('element5.sgml')->s);
		return;
	},
	$right_ret,
	'Test element with one character data.',
);

# Test.
$obj = SGML::PYX->new;
$right_ret = <<'END';
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

SKIP: {
	skip 'No support for instruction.', 2;

# Test.
$obj = SGML::PYX->new;
$right_ret = <<'END';
?target code
END
stdout_is(
	sub {
		$obj->parsefile($data_dir->file('instruction1.sgml')->s);
		return;
	},
	$right_ret,
	'Test instruction.',
);

# Test.
$obj = SGML::PYX->new;
$right_ret = <<'END';
?target data\ndata
END
stdout_is(
	sub {
		$obj->parsefile($data_dir->file('instruction2.sgml')->s);
		return;
	},
	$right_ret,
	'Test advanced instruction.',
);
}

# Test.
$obj = SGML::PYX->new;
$right_ret = <<'END';
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
