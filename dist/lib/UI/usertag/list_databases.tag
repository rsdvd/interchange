
UserTag list-databases Order nohide extended
UserTag list-databases routine <<EOR
sub {
	my $nohide = shift;
	my $extended = shift || '';
	$extended = "=$extended" if $extended;
	my @dbs;
	my $d = $Vend::Cfg->{Database};
	@dbs = sort keys %$d;
	my @outdb;
	my $record =  ui_acl_enabled();
	unless ($record->{super}) {
		undef $record
			unless ref($record)
				   and $record->{yes_tables} || $record->{no_tables};

		for(@dbs) {
			next if $::Values->{ui_tables_to_hide} =~ /\b$_\b/;
			if($record) {
				next if $record->{no_tables}
					and ui_check_acl($_, $record->{no_tables});
				my $check = "$_$extended";
				next if $record->{yes_tables}
					and ! ui_check_acl($check, $record->{yes_tables});
			}
			push @outdb, $_;
		}

		@dbs = $nohide ? (@dbs) : (@outdb);
	}
	
	my $string = join " ", grep /\S/, @dbs;
	return $string;
}
EOR
