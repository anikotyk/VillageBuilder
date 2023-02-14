using UnityEngine;

#pragma warning disable 0649

namespace NepixSignals
{
    /// <summary>
    /// Default signals. If you don't want to create simple signals or use a hub.
    /// </summary>
    public class TheSignal : ASignal { }
    public class TheSignal<T> : ASignal<T> { }
    public class TheSignal<T, U> : ASignal<T, U> { }

    public class TheSignalInt : ASignal<int> { }
    public class TheSignalUint : ASignal<uint> { }
    public class TheSignalDouble : ASignal<double> { }

    public class TheSignalFloat : ASignal<float> { }

    public class TheSignalBool : ASignal<bool> { }
    public class TheSignalString : ASignal<string> { }

    public class TheSignalColor : ASignal<Color> { }
    public class TheSignalVector2 : ASignal<Vector2> { }
    public class TheSignalVector3 : ASignal<Vector3> { }
    public class TheSignalVector4 : ASignal<Vector4> { }

}