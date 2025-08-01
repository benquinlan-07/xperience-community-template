using System;
using System.Data;
using CMS;
using CMS.DataEngine;
using CMS.Helpers;
using XperienceCommunity.ExtensionTemplate.Models;

[assembly: RegisterObjectType(typeof(CustomExtensionTemplateItemInfo), CustomExtensionTemplateItemInfo.OBJECT_TYPE)]

namespace XperienceCommunity.ExtensionTemplate.Models;

/// <summary>
/// Data container class for <see cref="CustomExtensionTemplateItemInfo"/>.
/// </summary>
[Serializable]
public partial class CustomExtensionTemplateItemInfo : AbstractInfo<CustomExtensionTemplateItemInfo, IInfoProvider<CustomExtensionTemplateItemInfo>>
{
    /// <summary>
    /// Object type.
    /// </summary>
    public const string OBJECT_TYPE = "xpcm.customextensiontemplateitem";
    public const string OBJECT_CLASS_NAME = "XPCM.CustomExtensionTemplateItem";
    public const string OBJECT_CLASS_DISPLAYNAME = "CustomExtensionTemplateItem";


    /// <summary>
    /// Type information.
    /// </summary>
    public static readonly ObjectTypeInfo TYPEINFO = new(typeof(IInfoProvider<CustomExtensionTemplateItemInfo>), OBJECT_TYPE, OBJECT_CLASS_NAME, nameof(CustomExtensionTemplateItemId), null, nameof(CustomExtensionTemplateItemGuid), null, null, null, null, null)
    {
        TouchCacheDependencies = true,
        ContinuousIntegrationSettings =
        {
            Enabled = true,
        },
    };


    /// <summary>
    /// Custom extension template item ID.
    /// </summary>
    [DatabaseField]
    public virtual int CustomExtensionTemplateItemId
    {
        get => ValidationHelper.GetInteger(GetValue(nameof(CustomExtensionTemplateItemId)), 0);
        set => SetValue(nameof(CustomExtensionTemplateItemId), value);
    }


    /// <summary>
    /// Custom extension template item GUID.
    /// </summary>
    [DatabaseField]
    public virtual Guid CustomExtensionTemplateItemGuid
    {
        get => ValidationHelper.GetGuid(GetValue(nameof(CustomExtensionTemplateItemGuid)), default);
        set => SetValue(nameof(CustomExtensionTemplateItemGuid), value);
    }


    /// <summary>
    /// Custom extension template item placeholder value.
    /// </summary>
    [DatabaseField]
    public virtual string CustomExtensionTemplateItemPlaceholder
    {
        get => ValidationHelper.GetString(GetValue(nameof(CustomExtensionTemplateItemPlaceholder)), default);
        set => SetValue(nameof(CustomExtensionTemplateItemPlaceholder), value);
    }


    /// <summary>
    /// Deletes the object using appropriate provider.
    /// </summary>
    protected override void DeleteObject()
    {
        Provider.Delete(this);
    }


    /// <summary>
    /// Updates the object using appropriate provider.
    /// </summary>
    protected override void SetObject()
    {
        Provider.Set(this);
    }


    /// <summary>
    /// Creates an empty instance of the <see cref="CustomExtensionTemplateItemInfo"/> class.
    /// </summary>
    public CustomExtensionTemplateItemInfo()
        : base(TYPEINFO)
    {
    }


    /// <summary>
    /// Creates a new instance of the <see cref="CustomExtensionTemplateItemInfo"/> class from the given <see cref="DataRow"/>.
    /// </summary>
    /// <param name="dr">DataRow with the object data.</param>
    public CustomExtensionTemplateItemInfo(DataRow dr)
        : base(TYPEINFO, dr)
    {
    }
}
