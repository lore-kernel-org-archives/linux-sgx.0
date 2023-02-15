Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B661CC636D4
	for <linux-sgx@archiver.kernel.org>; Wed, 15 Feb 2023 08:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbjBOIvq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 15 Feb 2023 03:51:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjBOIvo (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 15 Feb 2023 03:51:44 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137232CC5F
        for <linux-sgx@vger.kernel.org>; Wed, 15 Feb 2023 00:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676451104; x=1707987104;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=LfvWDE4pliRIgyh/o3IpNXfmykPbg8NHqIh7uR6kWyY=;
  b=n/pv+ZAdWVDAoJKgYdGCEeZj5keuZDcWyV8S9H+ayqRmXY74OXCNKZ3Z
   blOCeGOseNtrkEyvoycfbIvibA4QAVU9IhEZzwQ4DDTvaAzWR1Aw26Vrx
   3KEA02np+9KgNVh7zgo0YuSF2lbZ2y3Ju2TPqCDkjT483xgqWbPnkkN/3
   bEO4rWsDOL1uavpUV1sdME7EArv5bi4IiqYf0H7UzBdqhQs4gfMKbQSrQ
   dtucppvwF18qOISiay+z/Fi4+iiDKlsQwZD2YvzkwTFR/6o8+clWtZWmJ
   EAQY3rYZ/3Bmexi9fX0jGrOvtRXq/d0+RGbaEnSK3YKin0NZ/0DOo8lRK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="311744026"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="311744026"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 00:51:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="758326841"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="758326841"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Feb 2023 00:51:42 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 00:51:41 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 00:51:41 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 00:51:41 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 00:51:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OT/GXOFsDKdR2jAcJzEZmaE/tmQtkrl7WACYoBnvCs5WkkZxpicP1bJxqS2E3Qq6TYPkLy+FMFSSopZgaKfX3uQD8AVQsmAXuxZzuhwxcrmHp+FLBtNTdDlRFDaE35enHfVfYFauJh9cryROnYV6AtIy62Vg0zCEvlS6xkiveGrweIzLyBGZK9gVkzulb+J9vrfu6wnoGFVodF1tVQ5XWx4ehi0PZbXBIhjFGREyN/LodIaNEGsfyJGONQ9787BkF3LrCMiE9oAP+BSqfEmjqUQbQOkFu7x1hdOXYPmC2ELtzWYLLeJBzaTr4oJutOH8QWsB0bmBRRefF5pNwUnXGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LfvWDE4pliRIgyh/o3IpNXfmykPbg8NHqIh7uR6kWyY=;
 b=Zo4PhrN6i8tcW5MNdSvJdRtdG850TsXIWkJ6sH/njVtVxTbxWdBmCRxy5kd1RDrzzyOK29jy9wC7k6LO5l2k/FMhtnkkK9v/Wd2xMZPUb+b5ZTx1H3ryuuAprzBjXDZ1CUc5to2rbdmWacPQpYgAEr/ZvTUxQjG0DrPpRSlON7Zxdj4Lt15VKGn0qbM9IFJXG/VXt1WCmHiSwQSZitMjiAJxO4ecgIecP5Yw6T0fW17NegmUPtRA4p4PC7nUlg1GasLjt8cd3aff20cCfYsPJDEr1NP5ooSDYIsVbo3blYVXeIQfwZfRxYdPqWTfIM/1qESywp7/ufZS1zizw4wbvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5062.namprd11.prod.outlook.com (2603:10b6:510:3e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 08:51:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%7]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 08:51:24 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Topic: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Index: AQHZMtTIU78a0A3o9UaUPrwPUmNX5q7OTQIAgACfroCAABrOAIAADTuAgAAPNoCAAFobgIAAUaaA
Date:   Wed, 15 Feb 2023 08:51:23 +0000
Message-ID: <ef4087489625b0f8403c38e61348010dba62f623.camel@intel.com>
References: <20230128045529.15749-1-haitao.huang@linux.intel.com>
         <20230128045529.15749-2-haitao.huang@linux.intel.com>
         <20230128045529.15749-3-haitao.huang@linux.intel.com>
         <3c7b4f7bf3e7c2a213662b1c9fdaa979050a9327.camel@intel.com>
         <op.10dekzjhwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <39903b057751d963e4e9b2a8cd5271fe3c102509.camel@intel.com>
         <op.10dk8lsjwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <c37bb20995f234aa724724a06c96c76f18252e66.camel@intel.com>
         <op.10d2otjlwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <op.10d2otjlwjvjmi@hhuan26-mobl.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB5062:EE_
x-ms-office365-filtering-correlation-id: 00f1b31c-3350-4e40-99a8-08db0f31d121
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KYaH0NFdrFopM8QcGd6ctR5i8gVLHn5HwuIrF6OT49zeyD67ntcxDl8yA8MwRACk8yAKYwV0CBSXkwfiSBbnqjnzrZhbWCSxkpgThyw0xWrDPuGXwijth3pt/7iTeWeaSNhVk5g4gFJNcqSVhr91Qa1LwthpXbi6bWKAgEXvXL+dkHFMjnJn4sszichY7FZoGoSMe4G6Cdq9f2kfoF0fXovASWsoLmlQsJ6X+G8O6Sptxrh2B11PVFbBJTWMm70mNgNhdxW4lu822zeZmyPN/8yHy+b2rCCwZM+Mdo1tNGzm6Xs7bPGQV9p27ufiRX9G1zxSsOrTiCGy7wocxqtTx9LfSa3DjiBEOBFEnxHEIA81H/RDu2HpSF/2qWMjfe3QHZDjaZBoRSx3z2W0KtLA7sAGoTND9E6v9/sVc0sy4lgCPZrPNwg0xkKlcYbKZ3jzbubLnA3OcDbZvDaOR7EG+5EBiwv+0rsUeDs/2zHM/ZtJQXRgNfqubrV/IMR1PRprmtUoHPNZRRhfRg9Wsqqm4H6ymLGPiZojHIK05IV69p67szdBOP5atXemDlRjf1fVpuMgfWtFKhylYHfLQ39+lMXtrDmSlfjwOszBNWxliuNTSe9Od3Sj4vA9VpShHLapzSj0VzBKIo5vg8PYCOCSBwQhL7uJtsvuvB5AmnPnov8wpETNzeBUDJRY0Zkbbwf+3ebLEp/Rpq5jiqvuLI56jw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199018)(478600001)(2906002)(6512007)(26005)(6506007)(186003)(82960400001)(316002)(2616005)(38100700002)(4744005)(71200400001)(36756003)(6486002)(5660300002)(86362001)(38070700005)(8936002)(110136005)(122000001)(64756008)(66556008)(66446008)(66946007)(76116006)(41300700001)(91956017)(8676002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bCtmdzNyaFZIZDJDMVpUQmh3RVRmbjkxeGd5a2IzL01PSmRJbGg5SXc2SHRw?=
 =?utf-8?B?TDI2aTIyVUQ5ZCtteElZWU85VjluQXVxU3JCZGRYMnBWTGNEUnAvR2NXM2F6?=
 =?utf-8?B?ZnluL0ZScjIxWmZjQlVMbXExYUYwNGQwYTdBc1ZING00eVp3RVBnNzlCSEZJ?=
 =?utf-8?B?bDZRWG5vL2JqVXl5aWNkR0JqV0xYY3luY0p0UTArOGJMNHhId1JZejVGMzF6?=
 =?utf-8?B?dlUxOWU0UEJ5bmFQc1lnREg4Rkdmak10dmw3ZUZnWVB6Wkgya2FicFhIRlhk?=
 =?utf-8?B?SnNDL2p2WklCSVYvUTdIT3pWZUczTk1Jcll3cm1GU0FvY1Q5UTJWVGpWYm9w?=
 =?utf-8?B?L2piZmN2RVQrT2t3MnF1NDg1MjRQbFFyd3ZVcUVVWFQyaU5jNFBrMTMrekM1?=
 =?utf-8?B?QmFmb3NXT2lnbUtSNnRoeVAyZ2FZcGJjYU1tMTh2dVlvdnFLTXp0NzAvcWlK?=
 =?utf-8?B?Z1NFMnkycDI2UlhCc0kvZkEzNHV6WjRVZXpBM2twSnVjZTgzbVJyOXM2d251?=
 =?utf-8?B?TEJXbVcrVm1BUHZnRFRqQ1NQdWFvMndldk40WWNXOTFlUzJBQjRSUG5UbDRQ?=
 =?utf-8?B?NXdGT0d5VmFmc3IyYjh2ZzNpN1QvazU1SStqMy96dFZ1RlU5OTk4eXZ6YWJT?=
 =?utf-8?B?Y0g0dS9UMlRIMFdjNmxNOGdnbEUyckRKRW8yaHZDUnUwMVdLOXh6azh6amRU?=
 =?utf-8?B?RmtoZ2p4NEZUbEgzZmtvaWNsT243eGtPUWhiVnZiVm16OXJ3Yk85SFJEWkZS?=
 =?utf-8?B?czNBSG9KQTdDUncvWGF0UnZ3c1dDdzJ1dDlEQU9uZWFmSDduWlBickhqVnds?=
 =?utf-8?B?WUUxV1lTdDd1T0VFL1RXc08xTjVVd2JkYTVNSEV0bXJBQlNPTmFXd0JZWnEx?=
 =?utf-8?B?VE4yWmdzdHlNVytiVDI3MjA0TmtDZHluZVphMG5xa1hKSkkvTElkdkhmZ2sz?=
 =?utf-8?B?SUNwS1hQd1V0L3M2Nnd5RkczZVNaWkNaVjM1N0p4WGtITDc1anhKVzhiL212?=
 =?utf-8?B?UklWS0dJQVRMeVAvWW9MNDRPK1FzU1M3UHVKMjluWDZyUHZUVllXRmxZZzVZ?=
 =?utf-8?B?UU9tNW1wQmE1VlgySkV6TWZZVW5kSUVCN0dPNDYwSk5rRElreFEwbVhsSlU3?=
 =?utf-8?B?aFoxc0c3TmE4d0tYdGMzU0ZoaTJyWS9VMFNiaHNPZE5ueE5rVFQrcGsydUJi?=
 =?utf-8?B?MjJjaHUrSHArZWZldUcwWEFtQkJFcFo3OFFxdHFUdkkrL0M3OTZzOCsyWlBx?=
 =?utf-8?B?QlRGb25obHZLamZtaUN5RTRjRGZKQlgvM1oreDFDNDJ3Ny92SFUyTjQrL09D?=
 =?utf-8?B?VTZ2YmhXOTUzNEE2Q2xWdWYwT29Ud0NHR0VmS2xNbmtCdkFoMExJM3ZsdDR2?=
 =?utf-8?B?K2xpaTZORnNjRzIzSnpBZjAxMHlqVTJtOXZpNi9xR3ZhcEhnZDU4Vm9MMmJD?=
 =?utf-8?B?S2t3ZUt4OHNqejZ0eVRHL0JtZDhtcmxSajN2clRJUEMyU0V1UmI5Q1lDdlVw?=
 =?utf-8?B?ZGE3V1B6ZnZ5MitjUE1FY2lUSU1KZkw4emp3WG80dzVIYWhOV3BWczBFUHhV?=
 =?utf-8?B?SGMyM1FNaUFwdG44c2huamMwaEVENGFFQjBXZW5Bb2ZDb3I5Yjd0dk8zOVVN?=
 =?utf-8?B?MTBRYWRaRTFXWkNYT3RPc3RmTWVySTN1UkRUbXlXOU9BYXUxdWpISkJzcFA4?=
 =?utf-8?B?akFkTzNUVG51YTEzbDRSeENEa21rUFRZUXdFUHlGYUpPYTRtbnhhV29OK1Zw?=
 =?utf-8?B?QzlKNFJ1NXlNc3Y2cStOYjdkajlFNnNnRGZVZk9aUVFjNnZDbnBnSGhwNnF6?=
 =?utf-8?B?YmttTG8zWlA3VVNiVGZUMUIyVmM4M0sxTHRYK200Nm00Qml1MHFPUy8wVVE1?=
 =?utf-8?B?Ny9QaStMTUZLR01Oc3ZkRzZJRmtZd0tIWDY3enA2Tm1wcVR0RUd1VWQwNWxm?=
 =?utf-8?B?dTZFODV5RzcySnYrK25GUG5zc0t3ME1wa2Z6ZFhsblFiRDJqM0pMS1I4cmtI?=
 =?utf-8?B?TDQ2cGVPS3JQY2RVSGQ2ekQydEJNT2lrSEp5R0RrTUF1bjJNeXJTdVRJNGt2?=
 =?utf-8?B?bGs0MllndWpBREM3WVZxaysvdVRTU3J5cHI1eVE3aGQzWnk2TVVHTTE1akcr?=
 =?utf-8?B?bFo1NDR0SCtUc1JURlI5QjNlTS9CelZmKzJTbDZNYUZZVTQwSi9DSU91eXo3?=
 =?utf-8?B?VWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <85D398182B3CD04AB7122EB65760F121@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00f1b31c-3350-4e40-99a8-08db0f31d121
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2023 08:51:23.8886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: APZaxg12raXz+YO9MhdptvHY5uJzFOb1kUPSVCUkoteRSl6uAf5z4HRwRmUC8/ksWAt+DraO/YHcPQhQOpP7QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5062
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

PiA+ID4gPiANCj4gPiANCj4gPiBTaW5jZSBzZ3hfbW1hcCgpIGNhbiBoYXBwZW4gYmVmb3JlIGVu
Y2xhdmUgaXMgY3JlYXRlZCwgY2FsY3VsYXRpbmcgdGhlICANCj4gPiB2bV9wZ29mZg0KPiA+IGZy
b20gZW5jbGF2ZV9iYXNlIGlzIGNvbmNlcHR1YWxseSB3cm9uZy4gIEV2ZW4gaWYgeW91IHJlYWxs
eSB3YW50IHRvIGRvICANCj4gPiBpdCwgaXQNCj4gPiBzaG91bGQgYmU6DQo+ID4gDQo+ID4gCWlm
IChlbmNsYXZlX2hhc19pbml0aWFsaXplZCgpKQ0KPiA+IAkJdm1hLT52bV9wZ29mZiA9IC4uLjsN
Cj4gDQo+IEkgZ290IHlvdXIgcG9pbnQgbm93LiBJIGNhbiBhZGQgYSBjb25kaXRpb24gdG8gdGVz
dCB0aGUgU0dYX0VOQ0xfQ1JFQVRFRCAgDQo+IGJpdC4gSG93ZXZlciwgd2Ugc3RpbGwgaGF2ZSBh
IGhvbGUgaWYgd2UgbXVzdCBoYW5kbGUgdGhlIHNlcXVlbmNlICANCj4gbW1hcCguLi4sIGVuY2xh
dmVfZmQpIGJlaW5nIGNhbGxlZCBiZWZvcmUgRUNSRUFURSBpb2N0bC4gV2UgY2FuJ3QgbGVhdmUg
IA0KPiB2bV9wZ29mZiBub3Qgc2V0IGZvciB0aG9zZSBjYXNlcy4NCj4gDQo+IFNpbmNlIG5vIG9u
ZSBkb2VzIHRoYXQgc28gZmFyLCBjYW4gd2UgZXhwbGljaXRseSByZXR1cm4gYW4gZXJyb3IgZnJv
bSAgDQo+IHNneF9tbWFwIHdoZW4gdGhhdCBoYXBwZW5zPw0KPiBPdGhlciBzdWdnZXN0aW9ucz8N
Cg0KQXMgSSByZXBsaWVkIHRvIHBhdGNoIDQvNCwgSSBiZWxpZXZlIHVzZXJzcGFjZSBzaG91bGQg
cGFzcyB0aGUgY29ycmVjdCBwZ29mZiBpbg0KbW1hcCgpLiAgSXQncyB3cm9uZyB0byBhbHdheXMg
cGFzcyAwIG9yIGFueSByYW5kb20gdmFsdWUuDQoNCklmIHVzZXJzcGFjZSBmb2xsb3cgdGhlIG1t
YXAoKSBydWxlLCB5b3Ugd29uJ3QgbmVlZCB0byBtYW51YWxseSBzZXQgdm1fcGdvZmYNCmhlcmUg
KHdoaWNoIGlzIGhhY2t5IElNSE8pLiAgRXZlcnl0aGluZyB3b3JrcyBmaW5lLg0KDQo=
