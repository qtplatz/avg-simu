/**************************************************************************
** Copyright (C) 2022-2023 Toshinobu Hondo, Ph.D.
** Copyright (C) 2022-2023 MS-Cheminformatics LLC, Toin, Mie Japan
*
** Contact: toshi.hondo@qtplatz.com
**
** Commercial Usage
**
** Licensees holding valid MS-Cheminfomatics commercial licenses may use this file in
** accordance with the MS-Cheminformatics Commercial License Agreement provided with
** the Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and MS-Cheminformatics.
**
** GNU Lesser General Public License Usage
**
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.TXT included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
**************************************************************************/

#include <boost/program_options.hpp>
#include <algorithm>
#include <cmath>
#include <iomanip>
#include <iostream>
#include <map>
#include <random>
#include <vector>
#include <boost/math/distributions/normal.hpp>
#include <boost/format.hpp>

namespace po = boost::program_options;

double area( const boost::math::normal_distribution<>& nd
             , const std::pair<double, double >& range
             , size_t ndiv = 1000 ) {
    double a = 0;
    double dw = (range.second - range.first) / ndiv;
    double x = range.first;
    for ( size_t i = 0; i <= ndiv; ++i ) {
        double y = boost::math::pdf( nd, x );
        a += y * dw;
        x = i * ((range.second - range.first)/ndiv) + range.first;
    }
    return a;
}

struct adc_linerity {
    static std::random_device rd_;
    const double adfs_;
    const size_t nrepl_;
    adc_linerity() : adfs_( 1.0 ), nrepl_( 100000 ) {}

    std::tuple< double, double, double, double > intensity( size_t nIons, double m ) { // nIons, volts for a single-ion
        if ( nIons * m <= 0 )
            return {};
        std::mt19937 gen(rd_());
        double sd = m * std::sqrt( nIons );
        double mean = nIons * m;
        std::normal_distribution< double > nd( mean, sd );
        double sum(0);
        for ( size_t i = 0; i < nrepl_; ++i ) {
            double v = nd(gen);
            double y = ( v <= 0 ) ? 0.0 : ( v >= adfs_ ) ? adfs_ : v;
            sum += y;
        }
        return { mean, sum / nrepl_, sd, 0 };
    }
};

std::random_device adc_linerity::rd_;

int
main(int argc, char *argv[])
{
    po::variables_map vm;
    po::options_description description( argv[0] );
    {
        description.add_options()
            ( "help,h",      "Display this help message" )
            ( "mean,m",      po::value< double >()->default_value( 0.0  ),  "mean" )
            ( "sd",          po::value< double >()->default_value( 1.0  ),  "dtandard deviation" )
            ( "left,l",      po::value< double >()->default_value( std::nan("") ),  "left" )
            ( "right,r",     po::value< double >()->default_value( std::nan("") ),  "right" )
            ( "output,o",    po::value< std::string >()->default_value( "area" ),  "output type [area|height]" )
            ( "step",        po::value< double >()->default_value( 0.1 ),   "step" )
            ( "ndiv,n",      po::value< size_t >()->default_value( 300 ),  "number of divisions for area calculation." )
            ( "adc",         "ADC saturation simulation" )
            ( "gain",        po::value< double >()->default_value( 0.050  ),  "detector gain (V)" )
            ;
        po::positional_options_description p;
        p.add( "args",  -1 );
        po::store( po::command_line_parser( argc, argv ).options( description ).positional(p).run(), vm );
        po::notify(vm);
    }

    if ( vm.count( "help" ) ) {
        std::cout << description;
        return 0;
    }

    boost::math::normal nd( vm[ "mean" ].as< double >(), vm[ "sd" ].as< double >() );

    const std::pair< double, double > c_range = { vm[ "left" ].as< double >(), vm[ "right" ].as< double >() };

    std::pair< double, double > range = { std::isnan(c_range.first) ? nd.mean() - nd.standard_deviation() * 5 : c_range.first
                                          , std::isnan( c_range.second ) ? nd.mean() + nd.standard_deviation() * 5 : c_range.second };

    const size_t ndiv = vm[ "ndiv" ].as< size_t >();
    const double step = vm[ "step" ].as< double >();

    if ( vm.count( "adc" ) ) {
        boost::format fmt( "%.4f\t" );
        auto gain = vm[ "gain" ].as< double >();
        adc_linerity adc;
        size_t i = 0;
        while ( i * gain < adc.adfs_ * 1.5 ) {
            auto [ mean, y, sd, b ] = adc.intensity( i++, gain );
            std::cout << fmt % mean << fmt % y << fmt % sd << std::endl;
        }
        return 0;
    }

    if ( vm[ "output" ].as< std::string >() == "area" ) {
        std::cout << "#mean\tsd\tr1\tr2\tarea" << std::endl;
        std::cout << nd.mean() << "\t" << nd.standard_deviation()
                  << "\t" << range.first << "\t" << range.second
                  << "\t" << area( nd, range ) << std::endl;
    } else {
        size_t i = 0;
        double x = range.first;
        while ( x <= range.second ) {
            std::cout << x << "\t" << boost::math::pdf( nd, x ) << std::endl;
            x = i++ * step + range.first;
        }

    }
}
