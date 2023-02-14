using IdleBasesSDK.Loading;

namespace IdleBasesSDK.Homa
{
    public class HomaLoadingOperation : LoadingOperation
    {
        public override void Load()
        {        
            /*
            Debug.Log("Start Init Homa");
            if (!HomaBelly.Instance.IsInitialized)
            {
                Events.onInitialized += OnInitialized;
            }
            else
            {
                OnInitialized();
            }
            */
        }

        private void OnInitialized()
        {
            /*
            Debug.Log("Inited");
            Events.onInitialized -= OnInitialized;
            Finish();
            */
        }
    }
}

