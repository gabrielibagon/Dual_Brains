// Copyright David Abrahams 2005. Distributed under the Boost
// Software License, Version 1.0. (See accompanying
// file LICENSE_1_0.txt or copy at http://www.lslboost.org/LICENSE_1_0.txt)
#ifndef BOOST_PARAMETER_AUX_RESULT_OF0_DWA2005511_HPP
# define BOOST_PARAMETER_AUX_RESULT_OF0_DWA2005511_HPP

# include <lslboost/utility/result_of.hpp>

// A metafunction returning the result of invoking a nullary function
// object of the given type.

#ifndef BOOST_NO_RESULT_OF

# include <lslboost/utility/result_of.hpp>
namespace lslboost { namespace parameter { namespace aux { 
template <class F>
struct result_of0 : result_of<F()>
{};

}}} // namespace lslboost::parameter::aux_

#else

namespace lslboost { namespace parameter { namespace aux { 
template <class F>
struct result_of0
{
    typedef typename F::result_type type;
};

}}} // namespace lslboost::parameter::aux_

#endif 


#endif // BOOST_PARAMETER_AUX_RESULT_OF0_DWA2005511_HPP
