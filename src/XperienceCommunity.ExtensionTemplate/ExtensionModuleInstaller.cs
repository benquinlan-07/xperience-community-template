using CMS.DataEngine;
using CMS.FormEngine;
using CMS.Modules;
using XperienceCommunity.ExtensionTemplate.Models;

namespace XperienceCommunity.ExtensionTemplate;

internal class ExtensionModuleInstaller
{
    private readonly IInfoProvider<ResourceInfo> _resourceProvider;

    public ExtensionModuleInstaller(IInfoProvider<ResourceInfo> resourceProvider)
    {
        _resourceProvider = resourceProvider;
    }

    public void Install()
    {
        var resource = _resourceProvider.Get(Constants.ResourceName)
                       ?? new ResourceInfo();

        InitializeResource(resource);
        InstallCustomExtensionTemplateItemInfo(resource);
    }

    public ResourceInfo InitializeResource(ResourceInfo resource)
    {
        resource.ResourceDisplayName = Constants.ResourceDisplayName;
        resource.ResourceName = Constants.ResourceName;
        resource.ResourceDescription = Constants.ResourceDescription;
        resource.ResourceIsInDevelopment = false;

        if (resource.HasChanged)
            _resourceProvider.Set(resource);

        return resource;
    }

    public void InstallCustomExtensionTemplateItemInfo(ResourceInfo resource)
    {
        var info = DataClassInfoProvider.GetDataClassInfo(CustomExtensionTemplateItemInfo.OBJECT_TYPE) ?? DataClassInfo.New(CustomExtensionTemplateItemInfo.OBJECT_TYPE);

        info.ClassName = CustomExtensionTemplateItemInfo.TYPEINFO.ObjectClassName;
        info.ClassTableName = CustomExtensionTemplateItemInfo.TYPEINFO.ObjectClassName.Replace(".", "_");
        info.ClassDisplayName = CustomExtensionTemplateItemInfo.OBJECT_CLASS_DISPLAYNAME;
        info.ClassType = ClassType.OTHER;
        info.ClassResourceID = resource.ResourceID;

        var formInfo = FormHelper.GetBasicFormDefinition(nameof(CustomExtensionTemplateItemInfo.CustomExtensionTemplateItemId));

        var formItem = new FormFieldInfo
        {
            Name = nameof(CustomExtensionTemplateItemInfo.CustomExtensionTemplateItemGuid),
            AllowEmpty = false,
            Visible = true,
            Precision = 0,
            DataType = "guid",
            Enabled = true,
        };
        formInfo.AddFormItem(formItem);

        formItem = new FormFieldInfo
        {
            Name = nameof(CustomExtensionTemplateItemInfo.CustomExtensionTemplateItemPlaceholder),
            AllowEmpty = true,
            Visible = true,
            Size = 500,
            DataType = "text"
        };
        formInfo.AddFormItem(formItem);

        SetFormDefinition(info, formInfo);

        if (info.HasChanged)
        {
            DataClassInfoProvider.SetDataClassInfo(info);
        }
    }

    /// <summary>
    /// Ensure that the form is upserted with any existing form
    /// </summary>
    /// <param name="info"></param>
    /// <param name="form"></param>
    private static void SetFormDefinition(DataClassInfo info, FormInfo form)
    {
        if (info.ClassID > 0)
        {
            var existingForm = new FormInfo(info.ClassFormDefinition);
            existingForm.CombineWithForm(form, new());
            info.ClassFormDefinition = existingForm.GetXmlDefinition();
        }
        else
        {
            info.ClassFormDefinition = form.GetXmlDefinition();
        }
    }
}
