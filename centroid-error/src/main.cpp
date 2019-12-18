/**************************************************************************
** Copyright (C) 2016 Toshinobu Hondo, Ph.D.
** Copyright (C) 2016 MS-Cheminformatics LLC, Toin, Mie Japan
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

#include "moment.hpp"
#include <boost/format.hpp>
#include <boost/filesystem.hpp>
#include <boost/program_options.hpp>
#include <boost/math/distributions/normal.hpp>
#include <cmath>
#include <fstream>
#include <random>
#include <ratio>
#include <iomanip>
#include <iostream>

namespace po = boost::program_options;

int centroid_error( boost::math::normal_distribution<>&, double, double
                    , std::normal_distribution<>&, std::mt19937&, bool random );

int
main(int argc, char *argv[])
{
    po::variables_map vm;
    po::options_description description( argv[0] );
    {
        description.add_options()
            ( "help,h",      "Display this help message" )
            ( "centroid",    "Centroid error simulation" )
            ( "width",       po::value< double >()->default_value( 2  ),  "peak width (ns)" )
            ( "time",        po::value< double >()->default_value( 10 ),  "peak time (us)" )
            ( "rate",        po::value< double >()->default_value( 1  ),  "sampling rate (GS/s)" )
            ( "offset",      po::value< double >()->default_value( 0  ),  "sampling offset (ns)" )
            ( "noise",       po::value< double >()->default_value( 0  ),  "noise level" )
            ( "random",       "apply random noise for centroid" )
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

    double interval = 1.0 / ( vm[ "rate" ].as< double >() * std::giga::num );
    double m = vm[ "time" ].as< double >() / std::micro::den;
    double s = vm[ "width" ].as< double >() / std::nano::den;

    boost::math::normal_distribution<> nd( m, s / 2.0 );

    //---------- noise ----------
    std::random_device rd;
    std::mt19937 gen(rd());
    std::normal_distribution<double> noise(0.00, vm[ "noise" ].as<double>() );
    // for ( int i = 0; i < 30; ++i )
    //     std::cerr << i << ", " << noise(gen) << std::endl;

    //---------- noise ----------

    double x0 = m - interval * 50;

    double max_y = boost::math::pdf( nd, m ) * 1.1;

    if ( vm.count( "centroid" ) ) {

        return centroid_error( nd, x0, interval, noise, gen, vm.count( "random" ) );

    } else {

        for ( int i = 0; i < 100; ++i ) {
            
            double x = x0 + i * interval;

            std::cout <<
                boost::format( "%.14e,\t%.14e" ) % x % ( noise( gen ) + boost::math::pdf( nd, x ) / max_y )
                      << boost::format( ",\t%.14e,\t%.14e" )
                % ( x + interval / 4 ) % ( noise( gen ) + boost::math::pdf( nd, x + interval / 4 ) / max_y )
                      << boost::format( ",\t%.14e,\t%.14e" )
                % ( x + interval / 2 ) % ( noise( gen ) + boost::math::pdf( nd, x + interval / 2 ) / max_y )
                      << std::endl;
        
        }
    }    
}

int
centroid_error( boost::math::normal_distribution<>& nd
                , double x0
                , double interval
                , std::normal_distribution<>& noise
                , std::mt19937& gen
                , bool random )
{
    const int div = 128;

    // prepare noise array for apply same profile between phase shift

    if ( !random ) {
        std::vector< double > noises;        
        for ( int i = 0; i < 100; ++i )
            noises.emplace_back( noise(gen) );

        for ( int offset = (-div/2); offset < (div/2); ++offset ) {
            std::vector< double > x, y;
            
            double max_y = boost::math::pdf( nd, nd.mean() );
            
            for ( int i = 0; i < 100; ++i ) {
                x.emplace_back( x0 + i * interval + (interval/div)*offset );
                y.emplace_back( noises[ i ] + boost::math::pdf( nd, x.back() ) / max_y );
            }
            
            adportable::Moment moment( [&]( int pos ){ return x[ pos ]; } );
            
            std::cout <<
                boost::format( "%.14le,\t%.14le,\t%.14le" )
                % (offset*interval/div)
                % moment.centreX( y.data(), 0.5, 35, 50, 65 )
                % ( moment.centreX( y.data(), 0.5, 35, 50, 65 ) - nd.mean() )
                      << std::endl;
        }

    } else {

        for ( int replicates = 0; replicates < div; ++replicates ) {
            std::vector< double > x, y;
            
            double max_y = boost::math::pdf( nd, nd.mean() );
            
            for ( int i = 0; i < 100; ++i ) {
                x.emplace_back( x0 + i * interval );
                y.emplace_back( noise(gen) + boost::math::pdf( nd, x.back() ) / max_y );
            }
            
            adportable::Moment moment( [&]( int pos ){ return x[ pos ]; } );
            
            std::cout <<
                boost::format( "%d,\t%.14le,\t%.14le" )
                % replicates
                % moment.centreX( y.data(), 0.5, 35, 50, 65 )
                % ( moment.centreX( y.data(), 0.5, 35, 50, 65 ) - nd.mean() )
                      << std::endl;
        }
    }
    
    return 0;
}



