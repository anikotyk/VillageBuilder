using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

#pragma warning disable 0649
namespace NepixSDK.NepixCore.Plugins.EasySave3.Nepix
{
    public static class NepixES3
    {
        private static readonly string AliasAttr = "[A]";
        
        private static Dictionary<string, Type> _aliasTypes = new Dictionary<string, Type>();
        private static Dictionary<Type, string> _aliasTypeStrings = new Dictionary<Type, string>();
        
        /// <summary>
        /// Should be called from ES3Reflection.GetType()
        /// </summary>
        /// <param name="typeString"></param>
        /// <param name="resultType"></param>
        /// <returns></returns>
        public static bool TryGetAliasType(string typeString, out Type resultType)
        {
            if (_aliasTypes.ContainsKey(typeString))
            {
                resultType = _aliasTypes[typeString];
                return true;
            }
            
            if (typeString.Contains(AliasAttr))
            {
                var aliasType = typeString.Replace(AliasAttr, "");
                foreach (var assembly in AppDomain.CurrentDomain.GetAssemblies())
                {
                    foreach (var type in assembly.GetTypes())
                    {
                        var attributes = type.GetCustomAttributes<ES3Alias>(false);
                        if (attributes.Count() == 1)
                        {
                            foreach (var attribute in attributes)
                            {
                                if (attribute.alias == aliasType)
                                {
                                    AddAlias(type, typeString);
                                    resultType = type;
                                    return true;
                                }
                            }
                        }
                        
                        foreach (var nestedType in type.GetNestedTypes())
                        {
                            attributes = nestedType.GetCustomAttributes<ES3Alias>(false);
                            if (attributes.Count() == 1)
                            {
                                foreach (var attribute in attributes)
                                {
                                    if (attribute.alias == aliasType)
                                    {
                                        AddAlias(nestedType, typeString);
                                        resultType = nestedType;
                                        return true;
                                    }
                                }
                            }
                        }
                    }
                }
            }

            resultType = null;
            return false;
        }

        /// <summary>
        /// Should be called from ES3Reflection.GetTypeString()
        /// </summary>
        /// <param name="type"></param>
        /// <param name="resultTypeSting"></param>
        /// <returns></returns>
        public static bool TryGetAliasTypeString(Type type, out string resultTypeSting)
        {
            if (_aliasTypeStrings.ContainsKey(type))
            {
                resultTypeSting = _aliasTypeStrings[type];
                return true;
            }
            
            var attributes = type.GetCustomAttributes<ES3Alias>();
            if (attributes.Count() == 1)
            {
                resultTypeSting = $"{AliasAttr}{attributes.First().alias}";
                AddAlias(type, resultTypeSting);
                return true;
            }

            resultTypeSting = null;
            return false;
        }

        private static void AddAlias(Type type, string typeString)
        {
            if (!_aliasTypes.ContainsKey(typeString))
            {
                _aliasTypes.Add(typeString, type);
            }
            if (!_aliasTypeStrings.ContainsKey(type))
            {
                _aliasTypeStrings.Add(type, typeString);
            }
        }
    }
}