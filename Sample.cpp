#include <Kube/Object/Object.hpp>

using namespace kF::Literal;

namespace kF::Generated
{
    Var CreateSample(void)
    {
        Var root;
        root.construct("Item"_hash);
        auto &rootObject = root.as<Object>();
        auto &rootObject = root.as<Object>();
        { /* x: myProperty * 2; */

            rootObject.getDefaultSlotTable();
        }
        return root;
    }
}