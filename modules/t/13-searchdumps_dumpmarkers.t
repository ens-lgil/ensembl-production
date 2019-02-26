#!perl
# Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
# Copyright [2016-2019] EMBL-European Bioinformatics Institute
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

use strict;
use warnings;
use Test::More;

BEGIN {
	use_ok('Bio::EnsEMBL::Production::Search::GenomeFetcher');
}

diag("Testing ensembl-production Bio::EnsEMBL::Production::Search, Perl $], $^X");

use Bio::EnsEMBL::Production::Search::MarkerFetcher;
use Bio::EnsEMBL::Test::MultiTestDB;

my $test     = Bio::EnsEMBL::Test::MultiTestDB->new('homo_sapiens_dump');
my $core_dba = $test->get_DBAdaptor('core');

my $fetcher = Bio::EnsEMBL::Production::Search::MarkerFetcher->new();

my $markers = $fetcher->fetch_markers_for_dba($core_dba);
is(scalar @$markers, 9, "Expected number of markers");
my ($marker) = grep {$_->{name} eq '18581'} @$markers;
ok($marker,"18581 found");
is($marker->{seq_region},"6","Chr 6");
is($marker->{start},43640679,"Correct start");
is($marker->{end},43640820,"Correct end");
is(scalar(@{$marker->{synonyms}}),2,"2 synonyms");
is(scalar(grep {$_ eq 'stSG12664'} @{$marker->{synonyms}}),1,"stSG12664 synonym found");
is(scalar(grep {$_ eq 'RH36154'} @{$marker->{synonyms}}),1,"RH36154 synonym found");

done_testing;
