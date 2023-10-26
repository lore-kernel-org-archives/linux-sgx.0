Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46855C25B48
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Oct 2023 21:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbjJZVQg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 26 Oct 2023 17:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjJZVQf (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 26 Oct 2023 17:16:35 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB21E10E;
        Thu, 26 Oct 2023 14:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698354994; x=1729890994;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qNADSiaJCHP5H3UI/Sg9cFxGZsaKf7Sksr4L9njS0TU=;
  b=iWA1u1jfCjsrsLwnFS9EbeEqQb4pDntDQ9ITINz9sR+XcbOZNEvlFjMS
   TkZjVFSRMeIv7kCFC1GBzuKekvhlMxh11VtyWk5xhrDlZmOdC/q0tFJ05
   4AW1O4/XgG7oOLf/Q9SggRrUdz1G6ZL+NcD7o/RkMaccXhTvlmFs7kBj9
   X2D3Q8RaK6JkyT0hOrIlAFBxn0LeCZebxZC4Nkne9hDnIvv1/5lb7GP2q
   XPi96avY3Ww6FjkkYV2JY9VENdu0304lB0zSL18DB8YMGHAYYche94Y3x
   CmdYCJiPZbHAwnFuwQWO+1O+t64CDr8Kkq+QsK9gl687U1PDJpyMuKd3q
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="473893950"
X-IronPort-AV: E=Sophos;i="6.03,254,1694761200"; 
   d="scan'208";a="473893950"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 14:16:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,254,1694761200"; 
   d="scan'208";a="7425389"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Oct 2023 14:16:22 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 26 Oct 2023 14:16:32 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 26 Oct 2023 14:16:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Thu, 26 Oct 2023 14:16:32 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 26 Oct 2023 14:16:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k61WWDynZWjF1GBdvYeWxfCiihW4IrC0C9oMJKkF1+VlS1NdGztqM6mOnroWW2FmmXC9j0p1Z++8z4203YVjFzseBGWkQj8Vme8fML50wyrRt7APLWdecnCuiLERJWsU1amLuF51TQ2hbJUNAlR5ViQdrX2nIM/rkd+5RpHgLI5sd/j8KrJsC23rQuL7UUAQlK5VoQ/TgAFLmncZGEa9TagWRtfWxRxCijGYo+O6k2tedtsgO59w8spEJU4qf7ZwremJKkQRo5WI5CKvfEfdcCqYCyMXE0jQQT41WhJ+F27K07U8k9h3a/o8qrLEuoWAvwtiepPBO8CBe+bvRoeqVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qNADSiaJCHP5H3UI/Sg9cFxGZsaKf7Sksr4L9njS0TU=;
 b=b+go5gWkA+2G8Sl/ejbVWFJ1P/9HI6JwefnWWI7SpIh7D7/T/mQ2Djo9h4cyPrjZHsFezertqObKZTuFiQ4zNNP494AgVHUpcgCkwMhAVRo+vuyxy/s8iyrN2rzKhywoHnKDO4ChcTaRyF6uFMdpTLPARf0gmnJZx6dEyNBFTzx09ihKuYjBj6B2btrlobesRaF+Cj01PSBlY9ABZaNEYayY4fA11wfgVHPYcmE633fmxos/mE5xgXYrRJENhHHGp/vSOvxUTSswZWXhpt6yAeDzzk9z2rd+5xVEIVlO78CBNfT7c4rZpbiXx9PvsRu3IvukHCPwIAiSGLvykdJzfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB7108.namprd11.prod.outlook.com (2603:10b6:930:50::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Thu, 26 Oct
 2023 21:16:29 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::9704:bf7c:b79f:9981]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::9704:bf7c:b79f:9981%6]) with mapi id 15.20.6933.022; Thu, 26 Oct 2023
 21:16:28 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "mingo@kernel.org" <mingo@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/sgx: Return VM_FAULT_SIGBUS for EPC exhaustion
Thread-Topic: [PATCH] x86/sgx: Return VM_FAULT_SIGBUS for EPC exhaustion
Thread-Index: AQHaAwC5HZkcwOUwLUG/lq0JhfdEybBamgKAgACeRYCAAQ01gIAACQuAgABO0gA=
Date:   Thu, 26 Oct 2023 21:16:28 +0000
Message-ID: <504d71debc56c89860942283ae638e5950deb79c.camel@intel.com>
References: <20231020025353.29691-1-haitao.huang@linux.intel.com>
         <b8ec3061-436f-41d3-8bff-635a90774dfb@intel.com>
         <b389986bac0e65ce128c9553603436efdda24a58.camel@intel.com>
         <b709d680-5754-45ab-ae73-c812420f10e5@intel.com>
         <op.2dfkbh2iwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <op.2dfkbh2iwjvjmi@hhuan26-mobl.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY8PR11MB7108:EE_
x-ms-office365-filtering-correlation-id: 5726b157-d9c7-45ca-0a5b-08dbd668d1da
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /XdtxalKyB/NIsjIgSeDMXXOCvT6WCGRmAkcY/x3zVlxVjs5V6HthHv1zF9p9Cnbr8ugdL2ydAm8kibDMfuUMTC6SCH9RRS72uTsxUu5vSZVhmz/QTqeBHDlNo4Ckbqm1aT2bMBwI9/t7/oMJkB9JNZjfi/SaY0RPIhIH3PrKWUIyRxY1Wv3p58gYJVezb3gi70mNa7vr40I2N4wK7jH5jxe/hM19vlrUe9mW+1MIfO41vJ+6tXo37t0Z6uVb05cpWhPqt+vb/6dOks61PFM/OIiAwtnIuQ1L/+R8L1k6oIWPQBW1nQBJX3h2QW93LCpOtybZ5+YI9m9kteo9BIAw+BkgGkMHPQSYYbH3jtVijI1MN8gn9Qg52se/HWc9ROjoUXBhcjWntHDSUSHH98yCsoVRPpIWaNUJ1P/xgTor1+t4lPZ30datWu6cBMvx0YJUY0VheHfSkJkPhnMaMJz94i4JY3Yjo4TfQ5eRiw3bs94IVYdkuqRm6iK57M50m88rPNsdoKSEYRsufAzBTA2+chNmFw1SQzg7z/mWWAlA2Eh0uM76OKxObm2KwmXqp7gJtjWhkMms/wtXg7dvRibn7gryf/1oB/UcIUmK2mlzCw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(39860400002)(396003)(136003)(346002)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(38100700002)(6506007)(53546011)(2616005)(26005)(71200400001)(6512007)(6486002)(110136005)(66556008)(76116006)(54906003)(66946007)(82960400001)(316002)(122000001)(38070700009)(64756008)(66446008)(478600001)(83380400001)(66476007)(5660300002)(86362001)(4001150100001)(36756003)(91956017)(41300700001)(2906002)(4744005)(4326008)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VDZwRDBoOWJtaGxNZi9sOWNPRGRmV1FKMW56bFhlMEY1Zng3WGc5SFdBOXE4?=
 =?utf-8?B?cmppaHFMd28reEhmc3Y4YTQvK1pSVmhIb3E1YWJIUytaV0ErY3Y2K3E4aWEr?=
 =?utf-8?B?TEJqVjNhWUtKNjErRFAwQWc4Y2M0MnE3dmZLa0w3N2RxSWpiZlgwd2V5anIz?=
 =?utf-8?B?U3lxWStxRzNwSTY4dmdLaWk5U28zbXQ0N3A5WmU5UWswbWNmTk9XaElkSkJB?=
 =?utf-8?B?TFl5WlB6SWxsZmRBTE5UdmVtc0l4YWpreWRGSFlhVHBFVC9mQ3l2YWVaaFBZ?=
 =?utf-8?B?VFVZSkxGcHJ4c25tdWlJVEhkVG9WRmlDWUh0U2t5aGRKWlZjNlFybVpOYkE5?=
 =?utf-8?B?SHh1MzRhQXhGaHEvWk5wUnFvUzJKSHVPR3RXZHBNNFRGdDNCcHpjU253RjJW?=
 =?utf-8?B?YjVjWTQrQWF2aEJUWDNXVUgyMy9ick9yTUhJT2tJRnRHOEZJa2c0aDJUTDJZ?=
 =?utf-8?B?MnByZVg5Y092VzRsMkI4bG16MlpjemVpcTNpclJ3WUYwaFZYUyszMGk3QlI1?=
 =?utf-8?B?akJKRFhSQmRwZTBPVDIwV0I2LzFneU55bHpaMENuR2daOVAzamZWVlhldlhH?=
 =?utf-8?B?akdCNVRVUjFLUVAzNXBrZ2ZTRjhCOC9ZcWMreW92ckJwWndtTUdUTEVCMU1t?=
 =?utf-8?B?ekQyTlRTOCtsQStEY2RzeklIWkZsQVFyQ1RsRnJVTWMzeVYvQkp3SU9NZGhl?=
 =?utf-8?B?Yk9GRU54MGJIN2FJR2RlYVhQOEQzcWp6dlF6RVpGRGhpdDFVNXRxMUhoRmtq?=
 =?utf-8?B?L3FidFdINzJIUWcrSDNIejFOM3k4S2pqTmdNU2RZcTZRR1ozVjJpUUVSeFZq?=
 =?utf-8?B?eG9JNXBpMm9XOGs1d3NsUEN0eG9wWWVXZlVOa1A4ZUwxdjR6dWlXMzZIVjJi?=
 =?utf-8?B?WlBqME04SGVyUi81T2xlRGRpYUwvYnlpaS9ncS92K1Nndm44c3ZNcHBhdktu?=
 =?utf-8?B?V01KOHVzcVczdjBkL0ZvNThxaFRiT1VqMlBKQ1BMQzAydGpWNkcxU21FQVhz?=
 =?utf-8?B?Y21ibjI4cTV3ZmQ2M01KaTJITkQ3MXdwRlAvZktnemNJQ25WUUc2WTFOMHpY?=
 =?utf-8?B?Rzg1K29oQ1lFS3gxSlJRZEFhRUNUbzV1cHIvR1NHR01hVHNEQmhEcHJhRnBW?=
 =?utf-8?B?SzZlL1RnaHk1UXlINFVhSXkzMVRxRUV4ZG5DcXUvZFZlM28ydThOUXQ2cUdL?=
 =?utf-8?B?aG41L1Z5bklkRXhuMkRzRUtpbWVsbHJsU3h2ZmQ1MHJUaERnZEUvdHJvb0JN?=
 =?utf-8?B?VGFWSDRvNG9yTG1iTG1hRmFacDlWM1p0a054N1VBbVlrMGc5ajQvL2ZIUVY5?=
 =?utf-8?B?TEhTTFR1Ym9KKzJIMGhKajZSMjAzeS9lYXlKWE03NGpEVEd1aGh2azBMQUZ0?=
 =?utf-8?B?cmE0UHA3OEFkSEg1bnpjVHRQT1BrQlZVNkFyWWNVckxnQ2pKeE9FclJIWHlJ?=
 =?utf-8?B?dDBLU1NybTUyZkdPSFlSZ0NhRGlLWGVmOG5MTUJjWCtPVkhvMVprSFlOQ2M4?=
 =?utf-8?B?dzI3U1Y3SWpwb25MaENmcW05Z0JyLzR1RWVKYVZ1bG9TU2JhdFBwNEVLZ28r?=
 =?utf-8?B?UGFPdlFvYmhMN0EySXd6V2dsZW1STnRWTW1SdHBLaHFQSlY4UytnSCtyc3dX?=
 =?utf-8?B?bEkweEU5TUF3OU1IZEVkVFNrRFRTREM0eVdiRm9ZNmlHQUJKdjczUUZxa3dq?=
 =?utf-8?B?eFJTKzRpeUEvVE0zSmwxTTlidklxRUZlckdkZTlKNFhEZy91ZUxsbGJhblRi?=
 =?utf-8?B?WHlIVHZCalVpOW9KTEhaaHZ2NnpRd1FUQ1QzU1hheEoyRVlyUm9jMXM4SnE5?=
 =?utf-8?B?bWtRTmpYdXVUTmtLMTB1Y2FQS0p6ZUZ1eWNmUzJlU0xqd3prZWx6L2ZnQ1ln?=
 =?utf-8?B?V2RwM3ZwODgwYzZueW5FKytZV2UzUEZDODVZMVNyQ25zM2ZIem5oVG9pbzJI?=
 =?utf-8?B?cmpHMDZqZk90NXlMcEFraXg0QnJxMmw1Q1llUHJHaDFPOEpCMk93TGJEYlFG?=
 =?utf-8?B?aEFUNUhqeUg2emc5ck11bXFKRy8xRVI5TjBONDhMczRoSEVURTJWaGNoVDQ2?=
 =?utf-8?B?Q2UrNVJMRFd5eGVvZ1VtTnRYam9FYjIrRmp4TzZUL1NYVTdiRTZtUzVsR2ww?=
 =?utf-8?B?QjNtMXJ4UEVuM3Z0b0VIWk9KNlF1RVpNSWlMSmFGYWhIbmZ2M1pjN2dxcXo4?=
 =?utf-8?B?Ymc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E202DC0ED828B74B8B02A424C82243EF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5726b157-d9c7-45ca-0a5b-08dbd668d1da
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2023 21:16:28.8488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U7udtCSMvAwSoVGzDVLSpQsa2nCOXRnHTI10JfROvombcJqc79rrmJ96OazHmSN9zBqGOmol6D9qpaStjuLhVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7108
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gVGh1LCAyMDIzLTEwLTI2IGF0IDExOjM0IC0wNTAwLCBIYWl0YW8gSHVhbmcgd3JvdGU6DQo+
IE9uIFRodSwgMjYgT2N0IDIwMjMgMTE6MDE6NTcgLTA1MDAsIFJlaW5ldHRlIENoYXRyZSAgDQo+
IDxyZWluZXR0ZS5jaGF0cmVAaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gDQo+ID4gDQo+ID4g
T24gMTAvMjUvMjAyMyA0OjU4IFBNLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+ID4gT24gV2VkLCAy
MDIzLTEwLTI1IGF0IDA3OjMxIC0wNzAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+ID4gPiA+IE9u
IDEwLzE5LzIzIDE5OjUzLCBIYWl0YW8gSHVhbmcgd3JvdGU6DQo+ID4gPiA+ID4gSW4gdGhlIEVB
VUcgb24gcGFnZSBmYXVsdCBwYXRoLCBWTV9GQVVMVF9PT00gaXMgcmV0dXJuZWQgd2hlbiB0aGUN
Cj4gPiA+ID4gPiBFbmNsYXZlIFBhZ2UgQ2FjaGUgKEVQQykgcnVucyBvdXQuIFRoaXMgbWF5IHRy
aWdnZXIgdW5uZWVkZWQgT09NIGtpbGwNCj4gPiA+ID4gPiB0aGF0IHdpbGwgbm90IGZyZWUgYW55
IEVQQ3MuIFJldHVybiBWTV9GQVVMVF9TSUdCVVMgaW5zdGVhZC4NCj4gPiANCj4gPiBUaGlzIGNv
bW1pdCBtZXNzYWdlIGRvZXMgbm90IHNlZW0gYWNjdXJhdGUgdG8gbWUuIEZyb20gd2hhdCBJIGNh
biB0ZWxsDQo+ID4gVk1fRkFVTFRfU0lHQlVTIGlzIGluZGVlZCByZXR1cm5lZCB3aGVuIEVQQyBy
dW5zIG91dC4gV2hhdCBpcyBhZGRyZXNzZWQNCj4gPiB3aXRoIHRoaXMgcGF0Y2ggaXMgdGhlIGVy
cm9yIHJldHVybmVkIHdoZW4ga2VybmVsIChub3QgRVBDKSBtZW1vcnkgcnVucw0KPiA+IG91dC4N
Cj4gPiANCj4gDQo+IA0KPiBTb3JyeSBJIGdvdCBpdCBtaXhlZCB1cCBiZXR3ZWVuIHNneF9hbGxv
Y19lcGNfcGFnZSBhbmQgc2d4X2VuY2xfcGFnZV9hbGxvYyAgDQo+IHJldHVybnMuDQo+IFlvdSBh
cmUgcmlnaHQuIFBsZWFzZSBkcm9wIHRoaXMgcGF0Y2guDQo+IA0KDQpJdCdzIGFscmVhZHkgaW4g
dGlwL3g4Ni91cmdlbnQuICBQbGVhc2Ugc2VuZCBhIHBhdGNoIHRvIHJldmVydD8NCg==
