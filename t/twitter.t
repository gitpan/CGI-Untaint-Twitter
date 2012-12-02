#!perl -wT

use Test::More tests => 13;

BEGIN {
	use_ok('CGI::Untaint::Twitter');
}

TWITTER: {
	# Check regular expression checker
	my $regex = CGI::Untaint::Twitter::_untaint_re();
	ok('nigelhorne' =~ $regex, 'valid Twitter ID');
	ok('@nigelhorne' =~ $regex, 'valid Twitter ID');
	ok('%%*%' !~ $regex, 'invalid Twitter ID');

	use_ok('CGI::Untaint');

	my $vars = {
	    twitter1 => 'nigelhorne',
	    twitter2 => '@nigelhorne',
	    twitter3 => ' @nigelhorne',
	    twitter4 => '  @nigelhorne ',
	    twitter5 => 'shf£*)',
	    twitter6 => ' ',
	    twitter7 => '@',
	};

	my $untainter = new_ok('CGI::Untaint' => [ $vars ]);
	my $c = $untainter->extract(-as_Twitter => 'twitter1');
	is($c, 'nigelhorne', 'nigelhorne');

	$c = $untainter->extract(-as_Twitter => 'twitter2');
	is($c, 'nigelhorne', '@nigelhorne');

	$c = $untainter->extract(-as_Twitter => 'twitter3');
	is($c, 'nigelhorne', '@nigelhorne');

	$c = $untainter->extract(-as_Twitter => 'twitter4');
	is($c, 'nigelhorne', '@nigelhorne');

	$c = $untainter->extract(-as_Twitter => 'twitter5');
	is($c, undef, 'Junk');

	# and what about empty fields?
	$c = $untainter->extract(-as_Twitter => 'twitter6');
	is($c, undef, 'Empty');

	$c = $untainter->extract(-as_Twitter => 'twitter7');
	is($c, undef, 'At sign');
}
