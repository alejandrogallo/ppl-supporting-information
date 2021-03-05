use v6

sub ex(Int $cnSmall, Int $cnLarge, $eSmall, $eLarge) {
  my $factor = $cnLarge**3.0*(1.0/$cnLarge**3.0 - 1/$cnSmall**3.0);
  return $eLarge - ( ($eLarge - $eSmall) / $factor) ;
}

class Container {
  has Int $.spin;
  has Int $.nrAtoms;
  has Str @.positions;
  has Str $.name;
  has Int $.charge;
  has Str @.atoms;
}



sub readmolecules (Str $molinfo, @molecules) {
  my Str @moldata=$molinfo.IO.slurp.split("\n");
  for @moldata.keys -> $i {
    @moldata[$i] ~~ /"** Molecule:" \s+ (\S+) \s+ "Wfn: wf,sym="\S",spin=" (\S+) {
      my Str $name = $/[0].Str;
      my Int $charge = 0;
      if ( $name.split(/<[\[\]]>/).[1]) {
        $charge = $name.split(/<[\[\]]>/).[1].Int
      };

      my Str @positions;
      my $nrAtoms = @moldata[$i-1].Int;
      my Str @atomList;
      for 1..$nrAtoms -> $j {
        @positions.push: @moldata[$i+$j];
        @atomList.push: @moldata[$i+$j].split(" ")[0];
      }
      @molecules.push: Container.new( spin => $/[1].Int
                                    , nrAtoms => $nrAtoms
                                    , positions => @positions
                                    , name => $name
                                    , charge => $charge
                                    , atoms => @atomList.unique );
      } /;
  }

}


sub getPplEnergies(Str $f) {
  my @o;
#  my Str $f = "output.ccsd."~$b;
  my @file = $f.IO.slurp.split(/\n/);
  for @file -> $l {
    $l ~~ / "Total Energy ="\s+(\S+) { @o[0] = $/[0] }/;
    $l ~~ / "CCSD corr. energy   ="\s+(\S+) { @o[1] = $/[0] }/;
    $l ~~ / "PPL corr. energy    ="\s+(\S+) { @o[2] = $/[0] }/;
    $l ~~ / "MP2 correlation energy                    ="\s+(\S+) { @o[3] = $/[0] }/;
  }
  @o[4] = @o[1] - @o[2] - @o[3];
  return @o;
}


sub getTEnergies(Str $f) {
  my $o;
  my @file = $f.IO.slurp.split(/\n/);
  for @file -> $l {
    $l.trim ~~ / ^"(T) energy"\s+"="\s+(\S+) { $o = $/[0] }/;
  }
  return $o;
}


sub checkfile(Str $string) of Bool {
  if !dir.grep(* ~~ $string) { return False;}
  else { return True; }
}

sub MAIN( Str $molfile) {
  my @molecules;
  readmolecules($molfile, @molecules);

  my @cn = [ 2, 3, 4, 5, 6];
  my @cnx = [ "[23]", "[34]", "[45]", "[56]"];
  my $basedir = $*CWD;
  
  for @molecules -> $molecule {
    my $mol = $molecule.name;


  
  
    my @fdata = "../psi4_ppl_data/$mol/output.ccsd.aug-cc-pv(D+d)z".IO.slurp.split(/\n/);
    my Bool $rhf = False; 
    for @fdata -> $l { $l ~~ / "RHF" { $rhf = True; } /; }
    my Str $output;
  
  
    my @e = ();
    @e.push: getPplEnergies("../psi4_ppl_data/$mol/output.ccsd.aug-cc-pv(D+d)z");
    @e.push: getPplEnergies("../psi4_ppl_data/$mol/output.ccsd.aug-cc-pv(T+d)z");
    @e.push: getPplEnergies("../psi4_ppl_data/$mol/output.ccsd.aug-cc-pv(Q+d)z");
    @e.push: getPplEnergies("../psi4_ppl_data/$mol/output.ccsd.aug-cc-pv(5+d)z");
    @e.push: getPplEnergies("../psi4_ppl_data/$mol/output.ccsd.aug-cc-pv(6+d)z");

    my @t = ();
    @t.push: getTEnergies("../psi4_triples_data/$mol/output.d.out");
    @t.push: getTEnergies("../psi4_triples_data/$mol/output.t.out");
    @t.push: getTEnergies("../psi4_triples_data/$mol/output.q.out");
    @t.push: getTEnergies("../psi4_triples_data/$mol/output.5.out");
    @t.push: getTEnergies("../psi4_triples_data/$mol/output.6.out");

    
    my Str $h = sprintf("%-4s   %-12s %-12s %-12s %-12s %-12s %-12s\n",
                   "#Cn","HF","Ccsd","Ppl","Mp2","Rest","(T)");
    $output = $h;
    for @e.keys -> $j {
      $output ~= sprintf("%4d ", @cn[$j]);
      for 0..4 -> $f { $output ~= sprintf("%12.6f ", @e[$j][$f].Rat); }
      $output ~= sprintf("%12.6f ", @t[$j].Rat);
      $output ~= sprintf("\n");
    }      
    for @cnx.keys -> $j {
      $output ~= sprintf("%4s      -       ", @cnx[$j]);
      for 1..4 -> $f {
        $output ~= sprintf("%12.6f ", ex(@cn[$j], @cn[$j+1], @e[$j][$f], @e[$j+1][$f]));
      }
      $output ~= sprintf("%12.6f ", ex(@cn[$j], @cn[$j+1], @t[$j], @t[$j+1]));
      $output ~= sprintf("\n");
    }
  
    my $outfile = $mol.Str;
    spurt $outfile, $output;
  }
}


