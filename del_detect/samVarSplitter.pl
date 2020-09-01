#!/usr/bin/env perl
use warnings;
use strict;

use Pod::Usage; ## uses pod documentation in usage code
use Getopt::Long qw(:config auto_help pass_through);

my $pos = -1;
my $seqName = "";
my $bestFlags = "";
my $bestID = "";
my $bestSeq = "";
my $bestQual = "";
my $bestLine = "";
my $seenCount = 0;
my $targetReference = "";
my $targetPos = -1;
my %posReads = ();
my %windowReads = ();
my $output = "sam"; # can be "sam" or "fastq" or "csv"

our $VERSION = "0.1";

=head1 NAME

samVarSplitter.pl
 - Split reads based on variant sequences

=head1 SYNOPSIS

samtools view -h mapped_reads.bam | ./samVarSplitter.pl [-ref <ref>] [-pos <int>] [options]

=head2 Options

=over 2

=item B<-help>

Only display this help message

=item B<-format> (sam|fastq)

Change output format (default: sam)

=item B<-reference> I<name>

Set I<name> as the reference sequence to target for read splitting

=item B<-position> I<location>

Set I<location> as the reference position to target for read splitting

=back

=head1 DESCRIPTION

Extracts all sequences that are mapped across a particular region,
separating them based on their variants across that region. Also
reports mapped start location and mapped length, which may be useful
for read boundary analysis (e.g. gene start/end points).

=cut

GetOptions("format=s" => \$output, "reference=s" => \$targetReference,
          "position=i" => \$targetPos)
  or pod2usage(1);

#if(!$targetReference || ($targetPos == -1)){
#  print(STDERR "Error: please specify both -ref and -pos\n");
#  pod2usage(1);
#}

sub rc {
  my ($seq) = @_;
  $seq =~ tr/ACGTUYRSWMKDVHBXN-/TGCAARYSWKMHBDVXN-/;
  # work on masked sequences as well
  $seq =~ tr/acgtuyrswmkdvhbxn/tgcaaryswkmhbdvxn/;
  return(scalar(reverse($seq)));
}

sub printSeq {
  my ($id, $seq, $qual) = @_;
  if($id){
    printf("@%s\n%s\n+\n%s\n", $id, $seq, $qual);
  }
}

sub dumpSamples {
  my %posReads = %{shift @_};
  ## Collect Read Group Names
  my %readGroups = ();
  foreach my $pos (keys(%posReads)){
    my $rgSeq = getPosSeq($posReads{$pos}{"seq"},
			  $posReads{$pos}{"flags"},
			  $posReads{$pos}{"pos"},
			  $targetPos,
			  $posReads{$pos}{"cigar"});
    $readGroups{$rgSeq}{"present"}++;
    $posReads{$pos}{"rgSeq"} = $rgSeq;
  }
  ## Print headers and assign read group IDs
  my $rgID = 0;
  foreach my $rgSeq (keys(%readGroups)){
    my $addedID = sprintf("%d_%s_%d%s",
			  $rgID,
                          ($targetReference ? $targetReference : "ALL"),
                          $targetPos, $rgSeq);
    $readGroups{$rgSeq}{"id"} = $addedID;
    if($output eq "sam"){
      printf("\@RG\tID:%s\tKS:%s\tDS:%s:%d[%s];count=%d\n", $addedID, $rgSeq,
             ($targetReference ? $targetReference : "ALL"), $targetPos, $rgSeq,
             $readGroups{$rgSeq}{"present"});
    }
    $rgID++;
  }
  if($output eq "fastq"){
    foreach my $pos (sort {$posReads{$a}{"pos"} <=>
			       $posReads{$b}{"pos"}} keys(%posReads)){
      printSeq($posReads{$pos}{"id"}.
               " var=".$readGroups{$posReads{$pos}{"rgSeq"}}{"id"}.
               " start=".$posReads{$pos}{"pos"}.
               " mappedLen=".$posReads{$pos}{"len"},
               $posReads{$pos}{"seq"},
               $posReads{$pos}{"qual"});
    }
  } elsif($output eq "sam"){
    foreach my $pos (sort {$posReads{$a}{"pos"} <=>
			       $posReads{$b}{"pos"}} keys(%posReads)){
      my $line = $posReads{$pos}{"line"}; chomp($line);
      printf("%s\tRG:Z:%s\tXL:i:%s\n", $line,
             $readGroups{$posReads{$pos}{"rgSeq"}}{"id"},
             $posReads{$pos}{"len"});
    }
  } elsif($output eq "csv"){
    foreach my $pos (sort {$posReads{$a}{"pos"} <=>
			       $posReads{$b}{"pos"}} keys(%posReads)){
      printf("%s,%s,%s,%s,%s\n",
             $readGroups{$posReads{$pos}{"rgSeq"}}{"id"},
             $pos,
             -((($posReads{$pos}{"flags"} & 0x10) >> 3) - 1),
             $posReads{$pos}{"pos"},
             $posReads{$pos}{"len"});
    }
  }
}

sub getPosSeq {
  my ($seq, $flags, $startPos, $targetPos, $cigar) = @_;
  if($targetPos == -1){
    return("-");
  }
  my $refPos = $startPos - 1;
  my $seqPos = 0;
  my $lastRef = $startPos - 1;
  my $posSeq = "";
  if($flags & 0x10){
    # Note: don't reverse complement - seq field is adjusted to match ref
  }
  while($cigar =~ s/^([0-9]+)([MIDNSHP=X])//){
    my $subLen = $1;
    my $op = $2;
    if($op =~ /[M=XDPN]/){
      $refPos += $subLen;
    }
    if($op eq "I"){
      if($lastRef == ($targetPos - 1)){
        $posSeq .= substr($seq, $seqPos, $subLen);
      }
    } elsif(($lastRef <= ($targetPos-1)) && ($refPos >= $targetPos)){
      # now we know precisely in the sequence where the variant is
      if($op =~ /[M=X]/){
        $posSeq .= substr($seq, $seqPos + ($targetPos - $lastRef) - 1, 1);
      } elsif($op =~ /[DPN]/){
	$posSeq .= "-";
      }
    }
    if($op =~ /[MIX=S]/){
      $seqPos += $subLen;
    }
    $lastRef = $refPos;
  }
  return($posSeq);
}

sub getMappedLength {
  my $cigar = shift @_;
  my $mappedLen = 0;
  while($cigar =~ s/^([0-9]+)([MIDNSHP=X])//){
    my $subLen = $1;
    my $op = $2;
    if($op =~ /[M=XD]/){
      $mappedLen += $subLen;
    }
  }
  return($mappedLen);
}

if($output eq "csv"){
  printf("group,readID,dir,start,mappedLength\n");
}

while(<>){
  if(/^@/){
    print;
    next;
  }
  my $line = $_;
  chomp;
  my @F = split(/\t/);
  if($targetReference && ($F[2] ne $targetReference)){
    next;
  }
  my $currentPos = $F[3];
  if($F[2] ne $seqName){
    ## New reference name, so dump buffered reads
    dumpSamples(\%posReads);
    ## then clear position buffer
    %posReads = ();
    %windowReads = ();
    $seenCount = 0;
  }
  if($currentPos != $pos){
    ##print("Changing position to $currentPos\n");
    ## New position, so dump sampled reads from the position buffer (if any)
    if((($pos <= $targetPos) && ($currentPos > $targetPos)) ||
       ($targetPos == -1)){
      ## all buffered reads must be within the target region
      dumpSamples(\%posReads);
      ## Clear position buffer
      %posReads = ();
    }
    ## Add sampled reads from position buffer to window buffer
    foreach my $readID (keys(%posReads)){
      $windowReads{$posReads{$readID}{"id"}}{"pos"} =
        $posReads{$readID}{"pos"};
      $windowReads{$posReads{$readID}{"id"}}{"len"} =
        $posReads{$readID}{"len"};
    }
    ## Count up all reads that cover the current location
    foreach my $readID (keys(%windowReads)){
      my $currentCov = 0;
      if($windowReads{$readID}{"pos"} +
         $windowReads{$readID}{"len"} < $currentPos){
        ## remove any reads that don't cover the current location
	# printf("Deleting %s, as %d + %d < %d; window read size: %d\n",
	#        ${readID}, $windowReads{$readID}{"pos"},
	#        $windowReads{$readID}{"len"}, $currentPos,
	#     scalar(keys(%windowReads)));
        delete($windowReads{$readID});
        delete($posReads{$readID});
      }
    }
    $seenCount = 0;
  }
  my $readID = $F[0];
  $posReads{$readID}{"line"} = $line;
  $posReads{$readID}{"id"} = $F[0];
  $posReads{$readID}{"flags"} = $F[1];
  $posReads{$readID}{"seq"} = $F[9];
  $posReads{$readID}{"pos"} = $F[3];
  $posReads{$readID}{"cigar"} = $F[5];
  $posReads{$readID}{"len"} = getMappedLength($F[5]);
  $posReads{$readID}{"qual"} = $F[10];
  $seqName = $F[2];
  $pos = $currentPos;
}
dumpSamples(\%posReads);
