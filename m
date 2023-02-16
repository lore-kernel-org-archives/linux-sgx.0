Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA05FC61DA4
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Feb 2023 07:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjBPH5H (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 16 Feb 2023 02:57:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjBPH5D (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 16 Feb 2023 02:57:03 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3558947435
        for <linux-sgx@vger.kernel.org>; Wed, 15 Feb 2023 23:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676534188; x=1708070188;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=PkaoYOCYL4rqehTLUG/JXqRPVhXOK62asrIoRhOmEkc=;
  b=IyzMD3xQ1AqApV5/Wz8N7HNWoG82WL7NoQUJUia6UCk783zZymy+yH4d
   ea1NzsindqOxxxx6nUzSDlAMNaOajfqOdabtib5pedcqDcBqP1d5prK+E
   f9/US+tJ4VX3QKa2NC248KEfFy/yPiOgx+rc4Os5D4xamcRxy3BNFw11c
   WG+z28jNgn2HUkSz1ixqTg5xuGYDGAdpuO4upaaku3rlCIXqRPN8vn6OD
   I0LxJXztY4Ty8GSTeAJhQ6sTaA+uhAqyWHviPdglvKb+U/MoLk3LFlAUq
   neZuJ4tItC/pfHHyEcSvRbehkcORvqqmhJ5mt6v8f83kGiIgLexKEi0Jp
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="315327667"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="315327667"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 23:53:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="647578647"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="647578647"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 15 Feb 2023 23:53:49 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 23:53:49 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 23:53:49 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 23:53:49 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 23:53:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhWHJRjcM/iYO2htwqvraRIDalk87GsnWwc+LUmyvq/UI2kjM4E57R4A9Iy0Xkzb598E4pkGOYc5xCAyYb8q2VYxtBNNJPVBrQwsJw2xG+8pnhk/hq5Ibzx4zqmrqMflXePyE8HTRdGGG0e15kECSN/44fZb4iNWNONUfwSZCF6BVkOEI3Wy0SWNJIoSeqPjBo+FivFjci+4CyR1fgdny82ERj86ChC1zNjZeHtrO4zAQ9u3VcNrzc+uct14GpH+MjfEcPz4gY2FY+Ot1AebAV071uoIdc6lQhnAboj+OjHynjvfBCssMMKPSflNPqhzbSOwY/2RPqJBK0+LqqJm3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PkaoYOCYL4rqehTLUG/JXqRPVhXOK62asrIoRhOmEkc=;
 b=cJC6p8aAdnPftADT0DalFyvrG775OwNbZuWXDbSyc9FUJdUIMS0+GbsmZVzYVQePD0IqfK3fvEOXCulcv4l45R862TbvlR3Oye51ZYf0e+6SPJTKY5mgRulrVJgfDuh5xZ+qqgkoxCYcDCDsV2Gnm4V5hzw8pwxZMrJKa7S+M8vH+7sO53AiycyhHW7KJDouOYWt47kzR8ONZCEeOaRZKgDp7wLBOcS3iYMAs4hWyGQkSR1kRuJM/6jIuUilC03MRYX+hw0DY4+8wJeUoURVqLll7UOkLHpblgOxQPpEtw3QT1c14RC0vt+pYB0DZBYrZ5HrUJfHNcZ5u08h7y6grA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6794.namprd11.prod.outlook.com (2603:10b6:510:1b8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Thu, 16 Feb
 2023 07:53:47 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%7]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 07:53:47 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Topic: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Index: AQHZMtTIU78a0A3o9UaUPrwPUmNX5q7OTQIAgACfroCAABrOAIAADTuAgAAPNoCAAFobgIAAUaaAgABy3wCAAQ9aAA==
Date:   Thu, 16 Feb 2023 07:53:47 +0000
Message-ID: <68d19c7bb8e28e85d503da53124fc57b916dcaf9.camel@intel.com>
References: <20230128045529.15749-1-haitao.huang@linux.intel.com>
         <20230128045529.15749-2-haitao.huang@linux.intel.com>
         <20230128045529.15749-3-haitao.huang@linux.intel.com>
         <3c7b4f7bf3e7c2a213662b1c9fdaa979050a9327.camel@intel.com>
         <op.10dekzjhwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <39903b057751d963e4e9b2a8cd5271fe3c102509.camel@intel.com>
         <op.10dk8lsjwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <c37bb20995f234aa724724a06c96c76f18252e66.camel@intel.com>
         <op.10d2otjlwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <ef4087489625b0f8403c38e61348010dba62f623.camel@intel.com>
         <op.10ey84qywjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <op.10ey84qywjvjmi@hhuan26-mobl.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6794:EE_
x-ms-office365-filtering-correlation-id: ae4ba71b-223b-4c6d-1712-08db0ff2ef1f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pPSHdBmO82t1CcWpStFUXYEYjPANwjz8NfUP/l/3H1sDYlkr7PWtkLrtX4EnKS+u4zc/Hxyac5Wg9dEWhjFB4Gpv2IRxNtDv7BXMjJGcrG5Rfr7mzXDGx6RlcE+uxYbTZ49XiD7OFeidmTr/gvkoo1mbem3BsyI0K2L9QNPvYG7PnM/YJAF7uy8tjPezLfM/+NeSwJd7Hn8sm5df8gaspccv8Kiw3oCkGy61xytjPUQ9C8DTuUupRUjw66TOODc+0dtxWIYAbbswFbMXZE7oKyYrf9vYeKhrnFUMfhGnpbqoHoQB37BoJvdYrA4B/VU9cwwMLXYTgjCiFau+Py50aZqfxIxmsl7JrFUnWGiqF+W/ktv3UFaAh0yR2fofNAmWsiMje75hd/Sw9SUYRhmSg5C+T8qEIHkETcrLSiZT1dEIVkASJDZ6XmjhM9lCvyLYygKPg5wFefBIe9u082MUxiV//VqH7wgXTyraUInvctVPvDgmjbcZL6KMI+hlPwy5hq6bJ/lKdNg9hIkNAkYhlFwoflwxbIdX3k6IJZaHsujCR13X7mzhkDH3hdHIcJRu1EIrEFOYmEYheEHej+ze9BFW+qelN6XyOZNc7gVrI5JntkF9u8SUKosxdo+pZniuexN5FRrX1LPYu9Zmx8MdSG8YR36RZVWEVvnLtbotCp+LxlnFOg1dx31+jeoCmN5MPLNE1A0hsxdgQd0Teja7Fw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(396003)(39860400002)(136003)(346002)(451199018)(316002)(8676002)(91956017)(186003)(26005)(38070700005)(478600001)(6486002)(66446008)(66476007)(110136005)(76116006)(66556008)(64756008)(66946007)(82960400001)(71200400001)(86362001)(2906002)(41300700001)(2616005)(36756003)(6506007)(38100700002)(6512007)(5660300002)(8936002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Vk9ZM0djbFF1dHhNVzRycUYvbXFIMzBmYkx1RGR3RHQwdXRIanlHSDFKcTg0?=
 =?utf-8?B?Ykx3c3R4YmtqWkk1Uk9EeDBxTk5GUEc2SmFSUkpQSEowaTVya2VPYzYrQVkz?=
 =?utf-8?B?UExiM2E2dkVLS0FxRXFRSUdEREVCZmlER3czdUZac3JxWWwveTVwM3JoQVZ1?=
 =?utf-8?B?Q29KY3oyNEFjak9iYS9PS2taenNYU1pNSTFzMjdvWUxZNDJQa25KZW93V0Yw?=
 =?utf-8?B?TlNwU1Fvbzc3NlYzNjBtSnVGTnBpN3M3M0RHUFRvcUZMNGdKUmNoc1RVWjE3?=
 =?utf-8?B?YXFXcHJLMk1GaFB6K3NRdDlTZFlLU0RJR2pmOW0wOWp6bWxYYUxDRlVKMUIv?=
 =?utf-8?B?QlVYTUhnTTlhZW42Vm9Db3lleEJwZWxaK0ZIcjNDQmxOdWZmNWVDK0Ftc1BJ?=
 =?utf-8?B?WGQ3L3dHUittZHZjZXlBMGFvaWRFNzh4d0F5c0g1Z002bmlMU3BZRnpnK3JM?=
 =?utf-8?B?YWkyQzB3SjZvQlN3V1NoRFhtOXp5YnNFRjVKV25pRGJaSVhaaDRNMDVnbUg3?=
 =?utf-8?B?NjNXM1dTN0M4K3YyUlRjZXArOTlRaGJIUTVSbCtVT0U2cTgxa1NRS0FGbW0v?=
 =?utf-8?B?bVFOeWhFVTlPd29WRHcyUnJ3d3BRakNPUmVsRzEvYkNqTVZmU2M0Vk9PbE1R?=
 =?utf-8?B?M05ZTlJzRkhUNWtFMzRMcDJJZHVteENZbjVNaVk2a3EwL1BrZjN6aWhZR2lw?=
 =?utf-8?B?allQRGkyS0loM2lMeUc4NmRGb1FEWHZyTzhsajBSY2RFSjR0L01OVHgyOEhE?=
 =?utf-8?B?aHJyd3Y3Vm1zT1YzVnUrRnlycVp2YnVsRmYrZE54Qlc1Tm16djZOejdYTHZT?=
 =?utf-8?B?YUh0Sk5oK21Ea2k3eVVSaEVxaHJSanFvRWx3Y09Ccngya25hRVlISEQyZkt6?=
 =?utf-8?B?OFpxQTEveGxWaGlKOHBqYzExWk5sNE85MTk2OXhuUFdRNTZaTjVpVXh1aFdP?=
 =?utf-8?B?UE1sdUVZMjNGejM1b3FTS0tvOXpzY1M4YmZqM28vQTlHbWNwemFkVU9BZG1O?=
 =?utf-8?B?MjJjQUt4SGljUUhYeFphOXBKOWNXR0cycWxVbkNUdllVOWZaeWFZMnpxZFla?=
 =?utf-8?B?N2podW5nQmc2dUJVTk9OaEQ5OWRYOE9JMVVJODVHN1AxaUw4MjFSR0R1aitj?=
 =?utf-8?B?YXcwS1hEOWRGaTR6Q1dWb3ZYVFF5Y2FPWU4xbFpYVVlZOEhRTVFvYWovNS84?=
 =?utf-8?B?cTF6ZnhoN0dJQ3NDUi9BODVjdytkV29NRUxnZGJIeVlQalJyQkI5c1ZmVkdB?=
 =?utf-8?B?ZHorNW1xcm5KYVNrVjFhYmxuYTE2U2piYlZieWp1T0V5QnFwWno2OXJMc2xR?=
 =?utf-8?B?aG1aWjlBaXlKbUxrQUQza0MrWVpRbzlYcHdpZ1NJeUFMM2dMRExqUllBdktq?=
 =?utf-8?B?TEdyQ2FUZzYrWDBLY2tLMDkwZE1zc2xVSlBnaGpoZkxsb0FyUGRidmhhcHRK?=
 =?utf-8?B?aTR0aXp2dkhETldmR3h2Z0JBOWVJclJDUW81NklSL3hZd291eXd4S1A1UjBh?=
 =?utf-8?B?cTFJaXlhWW84NkVwSUd1aEFxTktuVXBkTVFrMlZVUjlhWHRhS1BTbHVacldL?=
 =?utf-8?B?NENubUd5NTJWWjlyYXJ2KzVLZW1od0MvMlpFd2tmb1ZzOGlQZC9tNU5wODBv?=
 =?utf-8?B?M2xnc0NJQ0F1cTB0cHVZWUwrRExaOEsrZmJyUDcrb05vOEJhT2ZtV2tsZVh6?=
 =?utf-8?B?UUpuckdvUGdFbGgwM2JtR1piRzVRNmR4eFh2blZMUFNUakJ1bkdZd3BpMC8x?=
 =?utf-8?B?UFUzU0tyeWJxTXFObktVU0w4Y00xcEZsbFFVSWFqOW9vWXBKaVpxWmhUSmMv?=
 =?utf-8?B?cG5sS1FrTjdsVWRaVW1zdXVSM1Zpa0RVNU8zMFBrYTdSRUJ1ZVNkVWF4TGpX?=
 =?utf-8?B?eUxRR2xNVGJWdnQzcjMvaDAveFA4aktEZ1BTcE16ODhLUEJLR3JXYzhsVGxC?=
 =?utf-8?B?cjVCM1F0U3o4YUJZd3hNRFREWjcyUnUwVmVUYzhzSXNEZGo2UitmRXJWWUhS?=
 =?utf-8?B?RlhWUllCWmJva1hmRFAweSt0OGVtR3IyR0dLOWpmaFo2em81QXlzb1dUejM2?=
 =?utf-8?B?UWZNelkyUlVVOExRSFNFOEc2aTRhbHJtYWJBeFlvRWRDODFtMlpkWnVqV3ZM?=
 =?utf-8?B?Rnh6aStmSzNMVmtqaENMTlcranAwRmQwNlZxRXdHcm5BY0pQSDZzWkdlQ1dM?=
 =?utf-8?B?dmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F22421F62DD97F4EAF768374CF4C1474@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae4ba71b-223b-4c6d-1712-08db0ff2ef1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2023 07:53:47.0882
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ji7gmUEm/Wr5CQRnYctq4TB4PobycqKQ/g5vnUghVk/4bfxuPm1f9pZN4W51GztX6F6dGzbi1adpJO9qOAFu+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6794
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gV2VkLCAyMDIzLTAyLTE1IGF0IDA5OjQyIC0wNjAwLCBIYWl0YW8gSHVhbmcgd3JvdGU6DQo+
IE9uIFdlZCwgMTUgRmViIDIwMjMgMDI6NTE6MjMgLTA2MDAsIEh1YW5nLCBLYWkgPGthaS5odWFu
Z0BpbnRlbC5jb20+IHdyb3RlOg0KPiANCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiANCj4gPiA+ID4g
U2luY2Ugc2d4X21tYXAoKSBjYW4gaGFwcGVuIGJlZm9yZSBlbmNsYXZlIGlzIGNyZWF0ZWQsIGNh
bGN1bGF0aW5nIHRoZQ0KPiA+ID4gPiB2bV9wZ29mZg0KPiA+ID4gPiBmcm9tIGVuY2xhdmVfYmFz
ZSBpcyBjb25jZXB0dWFsbHkgd3JvbmcuICBFdmVuIGlmIHlvdSByZWFsbHkgd2FudCB0byAgDQo+
ID4gPiBkbw0KPiA+ID4gPiBpdCwgaXQNCj4gPiA+ID4gc2hvdWxkIGJlOg0KPiA+ID4gPiANCj4g
PiA+ID4gCWlmIChlbmNsYXZlX2hhc19pbml0aWFsaXplZCgpKQ0KPiA+ID4gPiAJCXZtYS0+dm1f
cGdvZmYgPSAuLi47DQo+ID4gPiANCj4gPiA+IEkgZ290IHlvdXIgcG9pbnQgbm93LiBJIGNhbiBh
ZGQgYSBjb25kaXRpb24gdG8gdGVzdCB0aGUgU0dYX0VOQ0xfQ1JFQVRFRA0KPiA+ID4gYml0LiBI
b3dldmVyLCB3ZSBzdGlsbCBoYXZlIGEgaG9sZSBpZiB3ZSBtdXN0IGhhbmRsZSB0aGUgc2VxdWVu
Y2UNCj4gPiA+IG1tYXAoLi4uLCBlbmNsYXZlX2ZkKSBiZWluZyBjYWxsZWQgYmVmb3JlIEVDUkVB
VEUgaW9jdGwuIFdlIGNhbid0IGxlYXZlDQo+ID4gPiB2bV9wZ29mZiBub3Qgc2V0IGZvciB0aG9z
ZSBjYXNlcy4NCj4gPiA+IA0KPiA+ID4gU2luY2Ugbm8gb25lIGRvZXMgdGhhdCBzbyBmYXIsIGNh
biB3ZSBleHBsaWNpdGx5IHJldHVybiBhbiBlcnJvciBmcm9tDQo+ID4gPiBzZ3hfbW1hcCB3aGVu
IHRoYXQgaGFwcGVucz8NCj4gPiA+IE90aGVyIHN1Z2dlc3Rpb25zPw0KPiA+IA0KPiA+IEFzIEkg
cmVwbGllZCB0byBwYXRjaCA0LzQsIEkgYmVsaWV2ZSB1c2Vyc3BhY2Ugc2hvdWxkIHBhc3MgdGhl
IGNvcnJlY3QgIA0KPiA+IHBnb2ZmIGluDQo+ID4gbW1hcCgpLiAgSXQncyB3cm9uZyB0byBhbHdh
eXMgcGFzcyAwIG9yIGFueSByYW5kb20gdmFsdWUuDQo+ID4gDQo+ID4gSWYgdXNlcnNwYWNlIGZv
bGxvdyB0aGUgbW1hcCgpIHJ1bGUsIHlvdSB3b24ndCBuZWVkIHRvIG1hbnVhbGx5IHNldCAgDQo+
ID4gdm1fcGdvZmYNCj4gPiBoZXJlICh3aGljaCBpcyBoYWNreSBJTUhPKS4gIEV2ZXJ5dGhpbmcg
d29ya3MgZmluZS4NCj4gPiANCj4gDQo+IFNHWCBkcml2ZXIgd2FzIGZvbGxvd2luZyBNQVBfQU5P
TllNT1VTIHNlbWFudGljcy4gSWYgd2UgY2hhbmdlIHRoYXQsIGl0J2QgIA0KPiBicmVhayBjdXJy
ZW50IHVzYWdlL0FCSS4NCg0KSXMgdGhlcmUgYW55IGRvYy9yZWZlcmVuY2UgbWVudGlvbmluZyB0
aGlzPyANCg0KPiANCj4gSSBzdGlsbCB0aGluayByZXR1cm5pbmcgZXJyb3IgZm9yIGNhc2VzIG1t
YXAoLi4uLCBlbmNsYXZlX2ZkKSBpZiBlbmNsYXZlICANCj4gaXMgbm90IGNyZWF0ZWQgd291bGQg
YmUgbGVzcyBpbnRydXNpdmUgY2hhbmdlLg0KDQpCdXQgeW91IG5lZWQgdGhlIGZpcnN0IG1tYXAo
KSB0byB3b3JrIGJlZm9yZSBJT0NUTChlY3JlYXRlKSB0byBnZXQgZW5jbGF2ZSdzDQpiYXNlIGFk
ZHJlc3MsIGNvcnJlY3Q/DQoNCj4gDQo+IEhhaXRhbw0KDQo=
