use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'DenaTraining',
    VERSION_FROM  => 'lib/DenaTraining.pm',
    PREREQ_PM     => {
        'Kossy' =>  '0.19',
    },
    MIN_PERL_VERSION => '5.008001'
);

