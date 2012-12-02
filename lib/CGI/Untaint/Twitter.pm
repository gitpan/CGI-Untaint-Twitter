package CGI::Untaint::Twitter;

use warnings;
use strict;
use Carp;

use base 'CGI::Untaint::object';
use Net::Twitter::Lite;

=head1 NAME

CGI::Untaint::Twitter - Validate a Twitter ID in a CGI script.

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

=head1 SYNOPSIS

CGI::Untaint::Twitter is a subclass of CGI::Untaint used to
validate if the given Twitter ID is valid.

    use CGI::Info;
    use CGI::Untaint;
    use CGI::Untaint::Twitter;
    # ...
    my $info = CGI::Info->new();
    my $params = $info->params();
    # ...
    my $u = CGI::Untaint->new($params);
    my $tid = $u->extract(-as_Twitter => 'twitter');
    # $tid will be lower case

=head1 SUBROUTINES/METHODS

=head2 is_valid

Validates the data.
Returns a boolean if $self->value is a valid twitter ID.

=cut

sub _untaint_re {
	# Only allow letters and digits
	# Remove the leading @ if any - leading spaces and so on will be
	# ignored
	return qr/\@?([a-zA-z0-9]+)/;
}

sub is_valid {
	my $self = shift;

	my $value = $self->value;

	if(!defined($value)) {
		return 0;
	}

	# Ignore leading and trailing spaces
	$value =~ s/\s+$//;
	$value =~ s/^\s+//;

	my $known_user = 0;

	eval {
		if(Net::Twitter::Lite->new(legacy_lists_api => 0)->show_user($value)) {
			$known_user = 1;
		}
	};
	if($@ =~ /exceeded/) {
		# Rate limit exceeded. Clients may not make more than 150 requests per hour.
		# Fall back assume it would have worked so as not to
		# incovenience the user
		return 1;
	}
	return $known_user;
}

=head1 AUTHOR

Nigel Horne, C<< <njh at bandsman.co.uk> >>

=head1 BUGS

Twitter only allows 150 requests per hour.  If you exceed that,
C<CGI::Untaint::Twitter> won't validate and will assume all ID's are valid.

Please report any bugs or feature requests to C<bug-cgi-untaint-twitter at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=CGI-Untaint-Twitter>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SEE ALSO

CGI::Untaint


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc CGI::Untaint::Twitter


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=CGI-Untaint-Twitter>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/CGI-Untaint-Twitter>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/CGI-Untaint-Twitter>

=item * Search CPAN

L<http://search.cpan.org/dist/CGI-Untaint-Twitter>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 Nigel Horne.

This program is released under the following licence: GPL


=cut

1; # End of CGI::Untaint::Twitter
