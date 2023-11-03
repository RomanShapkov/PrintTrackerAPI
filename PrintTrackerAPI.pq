// This file contains your Data Connector logic
section PrintTrackerAPI;

apikey = Extension.CurrentCredential()[Key];

baseurl = "https://papi.printtrackerpro.com/v1/";

//url = Uri.Combine(baseurl, endpoint)

[DataSource.Kind="PrintTrackerAPI", Publish="PrintTrackerAPI.Publish"]

shared PrintTrackerAPI.Navigation = (entityId as text) as table =>
    let
        NavTable = (tb as table) => Table.ToNavigationTable(tb, {"Name"}, "Name", "Data", "ItemKind", "ItemName", "IsLeaf", "sort") ,
        table_header = {"Name", "Key", "Data", "ItemKind", "ItemName", "IsLeaf", "sort"},
        
        lv1 = #table(table_header, 
            {
                {"Get an entity", "GetEntity", PrintTrackerAPI.GetEntity, "function", "function", "true", 1},
                {"Get devices by entity", "GetDevicesByEntity", PrintTrackerAPI.GetDevicesByEntity, "function", "function", "true", 1},
                {"Get meters by entity", "GeMetersByEntity", PrintTrackerAPI.GetMetersByEntity, "function", "function", "true", 1},
                {"Get supplies by entity", "GetSuppliesByEntity", PrintTrackerAPI.GetSuppliesByEntity, "function", "function", "true", 1},
                {"Get meters by device", "GetMetersByDevice", PrintTrackerAPI.GetMetersByDevice, "function", "function", "true", 1}
             })
   in
        NavTable(lv1);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//GetSuppliesByEntity = (entityId as text, start as date, end as date, optional includeChildren as logical, optional replaced as logical, optional limit as number)

PrintTrackerAPI.GetSuppliesByEntity = Value.ReplaceType(PrintTrackerAPI.GetSuppliesByEntityImpl, type4("Get supplies by entity", "Returns all the supplies from all the devices belonging to the specified entity or its children."));
type4= (nm as text , descr as text) => type function (
                     entityId as (type text meta [
                        Documentation.FieldCaption = "entityId",
                        Documentation.FieldDescription = "The ID of the entity that we want to pull supplies"
                        ]),
                    start as (type date meta [
                        Documentation.FieldCaption = "start",
                        Documentation.FieldDescription = "The start of the meter read date range"
                        ]),

                    end as (type date meta [
                        Documentation.FieldCaption = "end",
                        Documentation.FieldDescription = "The start of the meter read date range"
                        ]),

                    optional includeChildren as (type logical meta [
                        Documentation.FieldCaption = "includeChildren",
                        Documentation.FieldDescription = "Default: false. If enabled, the response will include meters at this entity, and all child entities.",
                        Documentation.SampleValues = {true, false},
                        Documentation.AllowedValues = {true, false}
                        ]),

                    optional replaced as (type logical meta [
                        Documentation.FieldCaption = "replaced",
                        Documentation.FieldDescription = "Default: false If enabled, the response will only include replaced supplies",
                        Documentation.SampleValues = {true, false},
                        Documentation.AllowedValues = {true, false}
                        ]),

                    optional limit as (type number meta [
                        Documentation.FieldCaption = "limit",
                        Documentation.FieldDescription = "The maximum number of supplies to return in a single request.",
                        Documentation.SampleValues = {100}
                        ])
                   )
        as function meta [
            Documentation.Name = nm,
            Documentation.LongDescription = descr
    ];


PrintTrackerAPI.GetMetersByEntity = Value.ReplaceType(PrintTrackerAPI.GetMetersByEntityImpl, type3("Get meters by device", "Returns an array of meter reads for a single device"));
type3 = (nm as text , descr as text) => type function (
                     entityId as (type text meta [
                        Documentation.FieldCaption = "entityId",
                        Documentation.FieldDescription = "The ID of the entity that the device belongs to"
                        ]),
                    start as (type date meta [
                        Documentation.FieldCaption = "start",
                        Documentation.FieldDescription = "The start of the meter read date range"
                        ]),

                    end as (type date meta [
                        Documentation.FieldCaption = "end",
                        Documentation.FieldDescription = "The start of the meter read date range"
                        ]),
                    optional excludeDisabled as (type logical meta [
                        Documentation.FieldCaption = "excludeDisabled",
                        Documentation.FieldDescription = "Default: false If true, only managed devices will be returned.",
                        Documentation.SampleValues = {true, false},
                        Documentation.AllowedValues = {true, false}
                        ])
                   )
        as function meta [
            Documentation.Name = nm,
            Documentation.LongDescription = descr
    ];

    //////////////////
PrintTrackerAPI.GetMetersByDevice = Value.ReplaceType(PrintTrackerAPI.GetMetersByDeviceImpl, type5("Get meters by entity", "Returns an array of meter reads for the specified entity."));
type5 = (nm as text , descr as text) => type function (
                     entityId as (type text meta [
                        Documentation.FieldCaption = "entityId",
                        Documentation.FieldDescription = "The ID of the entity to load meters from."
                        ]),
                    start as (type date meta [
                        Documentation.FieldCaption = "start",
                        Documentation.FieldDescription = "The start of the meter read date range"
                        ]),

                    end as (type date meta [
                        Documentation.FieldCaption = "end",
                        Documentation.FieldDescription = "The start of the meter read date range"
                        ]),

                    optional excludeDisabled as (type logical meta [
                        Documentation.FieldCaption = "excludeDisabled",
                        Documentation.FieldDescription = "Default: If true, only meters form managed devices will be returned.",
                        Documentation.SampleValues = {true, false},
                        Documentation.AllowedValues = {true, false}
                        ])
                   )
        as function meta [
            Documentation.Name = nm,
            Documentation.LongDescription = descr
    ];

PrintTrackerAPI.GetDevicesByEntity = Value.ReplaceType(PrintTrackerAPI.GetDevicesByEntityImpl, type2("Get devices by entity", "Returns an array of devices that belong to the specified entity and (optionally) its children."));
type2 = (nm as text , descr as text) => type function (
                     entityId as (type text meta [
                        Documentation.FieldCaption = "entityId",
                        Documentation.FieldDescription = "The ID of the entity to load devices from."
                        ]),
                    optional includeChildren as (type logical meta [
                        Documentation.FieldCaption = "includeChildren",
                        Documentation.FieldDescription = "Default: falseIf enabled, the response will include devices at this entity, and all child entities.",
                        Documentation.SampleValues = {true, false},
                        Documentation.AllowedValues = {true, false}
                        ]),
                    optional limit as (type number meta [
                        Documentation.FieldCaption = "limit",
                        Documentation.FieldDescription = "Default: 100 The maximum number of devices to return in a single request.",
                        Documentation.SampleValues = {100}
                        ]),
                    optional excludeDisabled as (type logical meta [
                        Documentation.FieldCaption = "includeChildren",
                        Documentation.FieldDescription = "Default: false If true, only managed devices will be returned.",
                        Documentation.SampleValues = {true, false},
                        Documentation.AllowedValues = {true, false}
                        ])
                   )
        as function meta [
            Documentation.Name = nm,
            Documentation.LongDescription = descr
    ];


PrintTrackerAPI.GetEntity = Value.ReplaceType(PrintTrackerAPI.GetEntityImpl, type1("Get an entity", "Returns an entity object for the provided entity ID."));
type1 = (nm as text , descr as text) => type function (
                     entityId as (type text meta [
                        Documentation.FieldCaption = "entityId",
                        Documentation.FieldDescription = "The ID of the entity to retrieve"
                        ]),
                    optional includeChildren as (type logical meta [
                        Documentation.FieldCaption = "includeChildren",
                        Documentation.FieldDescription = "Default: false If enabled, the response will include an array of all child entity names and IDs at every hierarchical level under the entity specified in the request.",
                        Documentation.SampleValues = {true, false},
                        Documentation.AllowedValues = {true, false}
                        ])
                   )
        as function meta [
            Documentation.Name = nm,
            Documentation.LongDescription = descr
    ];

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

PrintTrackerAPI.GetDataFromEndpoint = (
    endpoint as text, 
    params as record
    ) =>
    let
        fn = (pg as number) => 
            let 
                add_page_to_p = Record.AddField(params, "page", Text.From(pg)),
                data = PrintTrackerAPI.GetData(endpoint, add_page_to_p, false)
            in
                data,
        tb1 =
           List.Combine(
            List.Generate( 
                ()=> [ x = 1 , y = fn(1)],
                each not(List.IsEmpty([y])),
                each [ x=[x] + 1, y = fn(x) ],
                each [y]
            )
            )
    in
        tb1;


PrintTrackerAPI.GetData = (endpoint as text, params as record, keepError as logical) =>
    let
        h = [#"x-api-key" = apikey],
        json = 
            if 
                keepError 
                then Json.Document(Web.Contents(endpoint, [Headers = h, Query = params, ManualCredentials = true, ApiKeyName="x-api-key"]))
                else 
                    try Json.Document(Web.Contents(endpoint, [Headers = h, Query = params, ManualCredentials = true, ApiKeyName="x-api-key"])) otherwise {}
    in 
        json;

PrintTrackerAPI.GetEntityImpl = (entityId as text, optional includeChildren as logical) =>
    let
        url = "https://papi.printtrackerpro.com/v1/entity/" & entityId,
        p = add_rec([], "includeChildren", Text.From(includeChildren)),
        json = PrintTrackerAPI.GetData(url, p, true),
        table = toTable({json})
    in
        table;

PrintTrackerAPI.GetDevicesByEntityImpl = (entityId as text, optional includeChildren as logical, optional limit as number, optional excludeDisabled as logical) =>
    let
        url = "https://papi.printtrackerpro.com/v1/entity/" & entityId & "/device",
        p =
            let
                p0 = add_rec([], "includeChildren", Text.From(includeChildren)),
                p1 = add_rec(p0, "limit", Text.From(limit)),
                p2 = add_rec(p1, "excludeDisabled", Text.From(excludeDisabled))
            in 
                p2,
        json = PrintTrackerAPI.GetDataFromEndpoint(url, p),
        table = toTable(json)
    in
        table;


PrintTrackerAPI.GetMetersByEntityImpl = (entityId as text, start as date, end as date, optional excludeDisabled as logical) =>
    let
        url = "https://papi.printtrackerpro.com/v1/entity/" & entityId & "/meter",
        dt1 = Date.ToText(start, "yyyy-MM-dd") &"T00:00:00.000Z",
        dt2 = Date.ToText(end, "yyyy-MM-dd")   &"T23:59:59.999Z",
        p =
            let
                p0 = [start = dt1, end = dt2],
                p1 = add_rec(p0, "excludeDisabled", Text.From(excludeDisabled))
            in 
                p1,
        
        json = PrintTrackerAPI.GetData(url, p, true),
        table = toTable(json)
    in
        table;


PrintTrackerAPI.GetMetersByDeviceImpl = (entityId as text, start as date, end as date, optional limit as number, optional excludeDisabled as logical) =>
    let
        getMeterByDevice = (deviceId as text) =>
            let
                url = "https://papi.printtrackerpro.com/v1/entity/" & entityId & "/"& deviceId &"/meter",
                dt1 = Date.ToText(start, "yyyy-MM-dd") &"T00:00:00.000Z",
                dt2 = Date.ToText(end, "yyyy-MM-dd")   &"T23:59:59.999Z",
                p =
                    let
                        p0 = [start = dt1, end = dt2],
                        p1 = add_rec(p0, "excludeDisabled", Text.From(excludeDisabled))
                    in 
                        p1,
                json = PrintTrackerAPI.GetDataFromEndpoint(url, p)
            in
                json,

        divices = PrintTrackerAPI.GetDevicesByEntity(entityId, true, null, excludeDisabled)[id],
        loop = List.Transform(divices, each getMeterByDevice(_) ),
        table = toTable(List.Combine(loop))
    in
        table;

PrintTrackerAPI.GetSuppliesByEntityImpl = (entityId as text, start as date, end as date, optional includeChildren as logical, optional replaced as logical, optional limit as number) =>
    let
        url = "https://papi.printtrackerpro.com/v1/entity/" & entityId & "/supplies",
        dt1 = Date.ToText(start, "yyyy-MM-dd") &"T00:00:00.000Z",
        dt2 = Date.ToText(end, "yyyy-MM-dd")   &"T23:59:59.999Z",
        p =
            let
                p0 = [start = dt1, end = dt2],
                p1 = add_rec(p0, "includeChildren", Text.From(includeChildren)),
                p2 = add_rec(p1, "replaced", Text.From(replaced)),
                p3 = add_rec(p2, "limit", Text.From(limit))
            in 
                p3,

        json = PrintTrackerAPI.GetDataFromEndpoint(url, p),
        table = toTable(json)
    in
        table;


// Data Source Kind description
PrintTrackerAPI = [
    TestConnection = (dataSourcePath) => {"PrintTrackerAPI.Navigation"},
    Authentication = [
        Key = [
                    KeyLabel = "x-api-key"
            ],
        // UsernamePassword = [],
        // Windows = [],
        Implicit = []
        ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
PrintTrackerAPI.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = PrintTrackerAPI.Icons,
    SourceTypeImage = PrintTrackerAPI.Icons
];

PrintTrackerAPI.Icons = [
    Icon16 = { Extension.Contents("PrintTrackerAPI16.png"), Extension.Contents("PrintTrackerAPI20.png"), Extension.Contents("PrintTrackerAPI24.png"), Extension.Contents("PrintTrackerAPI32.png") },
    Icon32 = { Extension.Contents("PrintTrackerAPI32.png"), Extension.Contents("PrintTrackerAPI40.png"), Extension.Contents("PrintTrackerAPI48.png"), Extension.Contents("PrintTrackerAPI64.png") }
];

Table.ToNavigationTable = (
    table as table,
    keyColumns as list,
    nameColumn as text,
    dataColumn as text,
    itemKindColumn as text,
    itemNameColumn as text,
    isLeafColumn as text,
    sort as text
) as table =>
    let
        tableType = Value.Type(table),
        newTableType = Type.AddTableKey(tableType, keyColumns, true) meta 
        [   
            NavigationTable.NameColumn = nameColumn, 
            NavigationTable.DataColumn = dataColumn,
            NavigationTable.ItemKindColumn = itemKindColumn, 
            Preview.DelayColumn = itemNameColumn, 
            NavigationTable.IsLeafColumn = isLeafColumn,
            NavigationTable.sort = sort
        ],
        navigationTable = Value.ReplaceType(table, newTableType)
    in
        navigationTable;

toTable = (lstrec as list, optional index as number, optional filds_name_sample as list) as table =>
    let
        fieldnames = 
            let
                list_combo = if filds_name_sample is null then lstrec else List.Combine( {filds_name_sample, lstrec} ),    
                toprows = if index is null then list_combo else List.FirstN(list_combo, index),
                listfields = List.Transform(toprows, Record.FieldNames),
                namesdistinct = List.Union(listfields)
            in
                namesdistinct,
        tbl = Table.FromRecords( lstrec, fieldnames, MissingField.UseNull)
    in
        tbl;

add_rec = (rec as record, recname as text, value as any) =>
    if value is null then rec else Record.AddField(rec, recname, value);