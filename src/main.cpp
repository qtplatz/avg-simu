/**************************************************************************
** Copyright (C) 2019 Toshinobu Hondo, Ph.D.
** Copyright (C) 2019 MS-Cheminformatics LLC, Toin, Mie Japan
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
#include "threshold_finder.hpp"
#include <boost/format.hpp>
#include <boost/filesystem.hpp>
#include <boost/program_options.hpp>
#include <boost/math/distributions/normal.hpp>
#include <boost/math/distributions/cauchy.hpp>
#include <cmath>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <random>
#include <ratio>
#include <vector>

namespace po = boost::program_options;

static std::random_device __rd__;

struct single_trigger {
    size_t nions_;
    double pulsewidth_;
    double pulseheight_;
    double pulsedist_;
    single_trigger( size_t nions, double pulsewidth, double pulseheight, double pulsedist )
        : nions_( nions )
        , pulsewidth_( pulsewidth )
        , pulseheight_( pulseheight )
        , pulsedist_( pulsedist ) {
    }
};

class single_ion {
    double time_;             // tof average
    double detector_width_;   // 0.5 .. 2ns
    double analyzer_width_;   // 2ns .. ??
    double gain_;             // 10mV .. 500mV
    double gain_sigma_;       // 5mV .. 300mV
    std::normal_distribution<> time_gen_;
    std::normal_distribution<> peak_gen_;
public:
    single_ion( double time
                , double detector_width
                , double analyzer_width
                , double gain
                , double sigma ) : time_( time )
                                 , detector_width_( detector_width )
                                 , analyzer_width_( analyzer_width )
                                 , gain_( gain )
                                 , gain_sigma_( sigma )
                                 , time_gen_{ time_, analyzer_width_ }
                                 , peak_gen_{ gain_, gain_sigma_ / 2.0 } {
                                 }

    single_ion( const single_ion& t ) : time_( t.time_ )
                                      , detector_width_( t.detector_width_ )
                                      , analyzer_width_( t.analyzer_width_ )
                                      , gain_( t.gain_ )
                                      , gain_sigma_( t.gain_sigma_ )
                                      , time_gen_( t.time_gen_ )
                                      , peak_gen_( t.peak_gen_ ) {
    }

    const double time() const { return time_; }
    const double analyzer_width() const { return analyzer_width_; }
    const double detector_width() const { return detector_width_; }

    std::pair< double, double > operator ()( std::mt19937& gen ) {
        double h(0);
        do
            h = peak_gen_( gen );
        while ( h < 0 );
        return { time_gen_( gen ), h }; // time, height pair for single ion
    }

    double height( double t, const std::vector< std::pair< double, double > > & ions ) const {
        return std::accumulate( ions.begin(), ions.end(), 0.0
                                , [&]( const double a, const auto& pair ){
                                      boost::math::normal_distribution< double > nd( pair.first, detector_width_ / 2.0 );
                                      return a + boost::math::pdf( nd, t ) * detector_width_ * pair.second;
                                  });
    }
};

class waveform_generator {
    single_ion ion_;
    double vScale_;       // digitizer vartical scale
    double sampInterval_; // digitizer sampling interval
    double noise_;
    double offset_;
    std::pair< double, double > time_range_;
    std::mt19937 gen_;
    std::vector< double > waveform_;
public:

    waveform_generator( const single_ion& ion
                        , double noise                   // mV
                        , double offset
                        , double sampInterval // = 0.3125e-9       // 3.2GS/s
                        , double vFS    // = 1.0
                        , double vScale // = vFS/4096
                        , size_t size = 1000 ) : ion_( ion )
                                               , vScale_( vScale )
                                               , sampInterval_( sampInterval )
                                               , noise_( noise )
                                               , offset_( offset )
                                               , time_range_( { ion.time() - size / 2 * sampInterval
                                                       , ion.time() + size / 2 * sampInterval } )
                                               , gen_( __rd__() )
                                               , waveform_( size ) {
        std::fill( waveform_.begin(), waveform_.end(), 0 );
    }

    bool generate( size_t ionCounts ) {

        std::vector< std::pair< double, double > > ions;
        for ( auto i = 0; i < ionCounts; ++i )
            ions.emplace_back( ion_( gen_ ) );

        std::normal_distribution<double> noise( offset_, noise_ );

        for ( size_t i = 0; i < waveform_.size(); ++i ) {
            double t = time_range_.first + i * sampInterval_;
            waveform_[ i ] = ion_.height( t, ions ) + noise( gen_ );
        }
        return true;
    }
    const std::pair< double, double >& time_range() const { return time_range_; }
    const std::vector< double >& waveform() const { return waveform_; }
    int32_t toDigital( double d ) const { return int32_t( d / vScale_ ); }
    double toVolts( int32_t d, size_t nAvg ) const { return ( d * vScale_ ) / nAvg; }
    double time( int i ) const { return time_range_.first + i * sampInterval_; }
};

////////////////////// COUNTING ////////////////////////

class waveform_counting {
    std::vector< uint32_t > hist_;
    size_t nAvg_;
    double Vth_;
public:
    waveform_counting( double v = 0.010 ) : nAvg_( 0 ), Vth_( v ) {
    }

    bool operator += ( const waveform_generator& wform ) {
        if ( hist_.empty() ) {
            hist_.resize( wform.waveform().size() + 1 );
            std::fill( hist_.begin(), hist_.end(), 0 );
        }

        std::vector< uint32_t > indices;
        adportable::counting::threshold_finder( true, 0 )( wform.waveform().begin(), wform.waveform().end(), indices, Vth_ );
        for ( const auto& idx: indices ) {
            if ( idx < hist_.size() )
                hist_[ idx + 1 ]++;
        }
        ++nAvg_;
        return true;
    }
    uint32_t operator [] (size_t i) const { return hist_[ i ]; }
    const std::vector< uint32_t >& adder() const { return hist_; }
    std::vector< uint32_t >::const_iterator begin() const { return hist_.begin(); }
    std::vector< uint32_t >::const_iterator end() const { return hist_.end(); }
    size_t nAvg() const { return nAvg_; }
};

////////////////////// AVERAGE ////////////////////////
class waveform_averager {
    std::vector< int32_t > adder_;
    size_t nAvg_;
public:
    waveform_averager() : nAvg_( 0 ) {
    }

    bool operator += ( const waveform_generator& wform ) {

        const auto& w = wform.waveform();

        if ( adder_.empty() ) {
            adder_.resize( w.size() );
            std::fill( adder_.begin(), adder_.end(), 0 );
        }

        std::transform( w.begin(), w.end(), adder_.begin(), adder_.begin()
                        , [&]( const auto& a, const auto& b ){
                              return wform.toDigital( a ) + b;
                          });
        ++nAvg_;
        return true;
    }
    const std::vector< int32_t > adder() const { return adder_; }
    std::vector< int32_t >::const_iterator begin() const { return adder_.begin(); }
    std::vector< int32_t >::const_iterator end() const { return adder_.end(); }
    size_t nAvg() const { return nAvg_; }
};


int
main(int argc, char *argv[])
{
    po::variables_map vm;
    po::options_description description( argv[0] );
    {
        description.add_options()
            ( "help,h",      "Display this help message" )
            ( "width",       po::value< double >()->default_value(  1  ),    "analyzer peak width (ns)" )
            ( "time",        po::value< double >()->default_value( 10  ),    "averaged peak time-of-flight (us)" )
            ( "rate",        po::value< double >()->default_value( 3.2 ),    "digitizer sampling rate (GS/s)" )
            ( "offset",      po::value< double >()->default_value(  0  ),    "digitizer sampling offset (ns)" )
            ( "noise",       po::value< double >()->default_value(  1.2  ),  "noise (mV)" )
            ( "nions",       po::value< int >()->default_value( 100 ),       "number of ions per each tof trigger" )
            ( "pulsewidth",  po::value< double >()->default_value( 1.0 ),    "single ion pulse width" )
            ( "gain",        po::value< double >()->default_value( 25 ),     "single ion average pulse height(mV)" )
            ( "gain-sigma",  po::value< double >()->default_value( 25 ),     "single ion average pulse sigma(mV)" )
            ( "ntrig,N",     po::value< int >()->default_value( 1 ),         "number of triggers to be averaged" )
            ( "ztrig,Z",     po::value< int >()->default_value( 0 ),         "additional triggers w/o ion" )
            ( "nbits",       po::value< int >()->default_value( 12 ),        "ADC nbits" )
            ( "adfs",        po::value< double >()->default_value( 1.0 ),    "ADFS" )
            ( "counting,C",  "Counting" )
            ( "output",      po::value< std::string >()->default_value( "waveform" ),  "output data type [waveform|PHD]" )
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

    double interval   = 1.0 / ( vm[ "rate" ].as< double >() * std::giga::num );
    double time       = vm[ "time" ].as< double >() / std::micro::den;
    double width      = vm[ "width" ].as< double >() / std::nano::den;
    double offset     = vm[ "offset" ].as< double >();
    double pulsewidth = vm[ "pulsewidth" ].as< double >() / std::nano::den;
    double gain       = vm[ "gain" ].as< double >()       / std::milli::den;
    double gain_sd    = vm[ "gain-sigma" ].as< double >() / std::milli::den;
    double noise      = vm[ "noise" ].as< double >()      / std::milli::den;
    size_t nIons      = vm[ "nions" ].as< int >();
    size_t nTrig      = vm[ "ntrig" ].as< int >();
    size_t zTrig      = vm[ "ztrig" ].as< int >();
    uint32_t nBits    = vm[ "nbits" ].as< int >();
    uint32_t nADFS    = (1 << nBits);
    double adfs       = vm[ "adfs" ].as< double >(); // V

    single_ion si( time, pulsewidth, width, gain, gain_sd ); // tof, mcp-width, analyzer-width, gain, gain-sd

    waveform_generator wform( si, noise, offset, interval, adfs, adfs/nADFS, 300 );


    if ( vm[ "output" ].as< std::string >() == "waveform" ) {

        waveform_counting hist;
        waveform_averager avgr;

        for ( size_t i = 0; i < nTrig; ++i ) {
            wform.generate( nIons );
            hist += wform;
            avgr += wform;
        }

        for ( size_t i = 0; i < zTrig; ++i ) {
            wform.generate( 0 );
            hist += wform;
            avgr += wform;
        }

        size_t peak_pos = ( time - wform.time_range().first ) / interval + 0.5;
        size_t peak_w = ( std::max( width, pulsewidth ) * 5 ) / interval + 0.5;
        size_t spos = peak_pos - peak_w / 2;
        size_t epos = peak_pos + peak_w / 2;

        int count = 0;
        size_t counts = std::accumulate( hist.begin() + spos, hist.begin() + epos, 0
                                         , [&]( const auto& a, const auto& b ){
                                             return a + b;
                                         });
        double area = std::accumulate( avgr.begin() + spos, avgr.end() + epos, 0.0
                                       , [&]( const auto& a, const auto& b ){
                                           return wform.toVolts( b, avgr.nAvg() ) + a;
                                       });


        for ( size_t i = 0; i < avgr.adder().size(); ++i ) {
            auto t  = wform.time( i );
            auto a = avgr.adder()[ i ];
            auto h  = wform.toVolts( avgr.adder()[ i ], avgr.nAvg() );
            uint32_t c  = hist[ i ];

            int mark = 0;
            double bar = 0;
            if ( i == spos || i == epos )
                bar = area / 10;

            if ( i == peak_pos )
                bar = area;

            if ( i == spos || i == epos )
                mark = counts / 10;

            if ( i == peak_pos )
                mark = counts;

            std::cout << boost::format("%.7e") % t
                      << "\t" << boost::format("%8d") % a
                      << "\t" << h
                      << "\t" << c
                      << "\t" << bar
                      << "\t" << mark
                      << std::endl;
            // std::cout << boost::format( "%g\t%g\t%d\t%g\t%d" ) % t % h % c % bar % mark << std::endl;
        }
    } else if ( vm[ "output" ].as< std::string >() == "PHD" ) {
        std::mt19937 gen( __rd__() );
        std::array< double, 1000 > phd = { 0 };
        std::array< double, 1000 > thist = { 0 };

        for ( size_t i = 0; i < 1000'000; ++i ) {
            auto [t,h] = si( gen );
            phd[ size_t( h ) ]++;
        }

        for ( size_t i = 0; i < phd.size(); ++i )
            std::cout << i << "\t" << phd[ i ] << std::endl;
    }
}
