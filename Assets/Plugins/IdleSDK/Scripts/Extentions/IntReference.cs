namespace IdleBasesSDK.Extentions
{
    public class IntReference
    {
        private int _value;
        public int Value
        {
            get => _value;
            set => _value = value;
        }
        public IntReference(int value = 0)
        {
            _value = value;
        }
    }
}