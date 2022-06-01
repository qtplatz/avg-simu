/**************************************************************************
** Copyright (C) 2022 Toshinobu Hondo, Ph.D.
** Copyright (C) 2022 MS-Cheminformatics LLC, Toin, Mie Japan
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

namespace po = boost::program_options;

int
main(int argc, char *argv[])
{
    po::variables_map vm;
    po::options_description description( argv[0] );
    {
        description.add_options()
            ( "help,h",      "Display this help message" )
            ( "location",    po::value< double >()->default_value( 0.0  ),  "location" )
            ( "gamma",       po::value< double >()->default_value( 0.5  ),  "𝛾 (gamma)" )
            ( "norm",        po::value< uint32_t >()->default_value( 1'00'00  ),  "norm" )
            ;
        po::positional_options_description p;
        p.add( "args",  -1 );
        po::store( po::command_line_parser( argc, argv ).options( description ).positional(p).run(), vm );
        po::notify(vm);
    }

    std::random_device rd{};
    std::mt19937 gen{rd()};

    auto cauchy = [&gen](const float x₀, const float 𝛾, int norm ) {

        std::cauchy_distribution<float> d{ x₀ /* a */, 𝛾 /* b */};

        // const int norm = 1'00'00;
        // const float cutoff = 0.005f;

        std::map<int, int> hist{};

        for ( int n = 0; n != norm; ++n ) {
            ++hist[ std::round( d(gen) ) ];
        }

        for ( const auto [n,p]: hist ) {
            std::cout << n << "\t" << p << std::endl;
        }
        std::cout << "\n\n";
    };

    cauchy(/* x₀ = */ vm["location"].as<double>(), /* 𝛾 = */ vm["gamma"].as<double>(), vm["norm"].as<uint32_t>() );
    //cauchy(/* x₀ = */ +0.0f, /* 𝛾 = */ 1.25f);
}
