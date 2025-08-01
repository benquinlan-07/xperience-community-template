using System.Threading.Tasks;
using Kentico.Xperience.Admin.Base;

namespace XperienceCommunity.ExtensionTemplate.Components.Custom;

public class CustomComponent : ActionComponent<CustomComponentProperties, CustomComponentClientProperties>
{
    public override string ClientComponentName => "@xperiencecommunityextensiontemplates/web-admin/Custom";

    protected override Task ConfigureClientProperties(CustomComponentClientProperties clientProperties)
    {
        return base.ConfigureClientProperties(clientProperties);
    }
}
