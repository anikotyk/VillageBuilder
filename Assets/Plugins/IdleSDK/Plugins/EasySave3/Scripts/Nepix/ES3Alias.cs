using System;

namespace NepixSDK.NepixCore.Plugins.EasySave3.Nepix
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Struct | AttributeTargets.Enum)]
    public class ES3Alias : Attribute
    {
        public string alias;
    
        public ES3Alias(string alias)
        {
            this.alias = alias;
        }
    }
}