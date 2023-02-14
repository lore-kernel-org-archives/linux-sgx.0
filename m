Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6667C05027
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Feb 2023 22:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbjBNWhq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 Feb 2023 17:37:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbjBNWhp (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 14 Feb 2023 17:37:45 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FD12CC7A
        for <linux-sgx@vger.kernel.org>; Tue, 14 Feb 2023 14:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676414264; x=1707950264;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=oV4Pcs2gQ0I/LVVfFtYLURouKJEteZnEUN04ALTP5h8=;
  b=DZBS5PIQxtkwkKqJx9Z5Eawh6dqc8bB5f2cfukhqDM2FMaS4fhYUWjQM
   ZwovhPiAxIup8aaC+SgO/gDDos3+XzwOQOkHgB1eiiDZxyzcoHb+Z0XpA
   aptQ1kbU8oMf3AHnigbf0XDrM6B/nFjgVW7XkrYYmtZ9/0V1RacoQzB43
   d8scNUN8LOinV4yH2b/MpRtwLLfKLyZLy2qzmZsyGhKV4TXkxGwEQUUVS
   THA9OS4EpXjEkYqZfg0bnpm9moRG6bMDH0b5x4QsIRxVbgrnaIJ2xTZVH
   RGYewBf/2WNLfsO4g/KoSi4FOxUrHT/Zd7QCcd7QWjv1n2anHEI+3DzBe
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="333426316"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="333426316"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 14:37:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="998233231"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="998233231"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 14 Feb 2023 14:36:42 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 14:36:42 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 14:36:42 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 14:36:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akxXScKl+89lwp0w/vlq8CoYdsKFCqbGqPMhPNQRi0uRhy0xmTYVRW4fUrHeaaGXAhpfmd0yMYIL5RcFAGenK9eUHv3vVG8cWOYlEwRo8UpUaA5hKPwr79Bi+iwmqIZfodvTJl95ERRW+WhPK2ilodsM3b/XJ5DqssGUrxeyeMhtRQB5GQ12skCevmXhGerHH4wMd1QxB6Q8n1L+VDPJhk46Kgn9A7rJaRrtDPifla2IjXDV4Mj3yK8j+/TDTT06TS8oVl0goUmS98UQFjFhbGL8dD+9pSeZZSSy7MOowhyszXxSFf9j6tiVfiVOLw6bQ/tEhtUjkh5Jatz/LDDhwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oV4Pcs2gQ0I/LVVfFtYLURouKJEteZnEUN04ALTP5h8=;
 b=KR/gaaNlTQeB6K8Mis0H843DHLCuX7AZe3pymJz0xhlu08mO6dN0USBRlHNwamP8DvvwLZj8/ka2L8bK58YhGguOARlgBI6qPKSyHEa/9IU9KZEqqK2z4WKSZCKOtG/hSG66WTmu8vOKtOTe5w+pcHVd1bvn/uRXomrO/57ta21RbJkFXPPFx19foZxw3WL8n5JkGfgFo52n67zr5aQz50M9I1GYbtpklGpYoP3lIYaxEuf5BB2ua04JtoKWb59LK0mXOonlDjRVYFmCEycZW8cIt25zQ8BvS0dogDb9PGva+fKO1QrmHd/a30AAy+oZK3rMvIaXCVJA2kwI5cF3Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN6PR11MB8146.namprd11.prod.outlook.com (2603:10b6:208:470::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.22; Tue, 14 Feb
 2023 22:36:40 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%7]) with mapi id 15.20.6086.026; Tue, 14 Feb 2023
 22:36:40 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Topic: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Index: AQHZMtTIU78a0A3o9UaUPrwPUmNX5q7OTQIAgACfroCAABrOAIAADTuAgAAPNoA=
Date:   Tue, 14 Feb 2023 22:36:40 +0000
Message-ID: <c37bb20995f234aa724724a06c96c76f18252e66.camel@intel.com>
References: <20230128045529.15749-1-haitao.huang@linux.intel.com>
         <20230128045529.15749-2-haitao.huang@linux.intel.com>
         <20230128045529.15749-3-haitao.huang@linux.intel.com>
         <3c7b4f7bf3e7c2a213662b1c9fdaa979050a9327.camel@intel.com>
         <op.10dekzjhwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <39903b057751d963e4e9b2a8cd5271fe3c102509.camel@intel.com>
         <op.10dk8lsjwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <op.10dk8lsjwjvjmi@hhuan26-mobl.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN6PR11MB8146:EE_
x-ms-office365-filtering-correlation-id: 6bea8b4d-751b-490c-b022-08db0edbf0a1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OYJPs+e2bYfIa4GJiDw0b+FbZUxBqvWh9l9bM9IS1GHV1IHAWQ4cT4NaPPdzVfy3vl5NtzPLluV3hEIIC9iB6neZulmmFqTrz9mKj/Xq1UYMm/xCsUU5oprgz/8SgQf6njLJyTzdYAfyJDPN5m3TvhQ2pUEloAaLwdSKrWsZ25w9Uv4mh9Lr4FcTfwnfy/F8OAHDGxbCXc9RJiBfP6oJ1Y+Ql+URbXIiYiPr2+7LsL9FsTP3XrDLbxYhJbpMMiIcVDdmiKXoiP0vT6OwNpUjAHoPfGw7ccIioIxnYS0bP0hpuNH+/BRJa3+10lJSwuFt0qqyE5OYpZDun4MehFeifrj5Qz4ksPvntHaiLGLDABqH0dSvOaLNapqGqJwe4Kh5WYOy9S7l42wtyDX2jpxl89qqeYWxVZeujyclUbUoAwtT0IYgKo4OS3cXhvtdb3r0SFtWfXVZHPwGlVGdgs38Dreq6FwWLuKvQ4UKooEZywmSJAsT1yKNTwy0DAPj2oEIkMK0nYuTT+vCl3kHIUOqNmkdfccUVu/krgkhQkDiwd6Gc6csMpJ1t7y2xTdTQ6/7gcV3vG64JRAA3F+B/XJwML4x4qrUZ/LTxkZqeEeMW8H9iiW2CME2o0qqDTU8ikUebh/a50p4KHrpzlMmAvJtCgvEAq+EDvBh6HSK9/F/i9OmXkvNAStUARgfKK0QEGxd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199018)(186003)(2616005)(6512007)(38070700005)(26005)(110136005)(38100700002)(71200400001)(478600001)(6506007)(966005)(6486002)(122000001)(36756003)(82960400001)(41300700001)(86362001)(8936002)(5660300002)(316002)(76116006)(66946007)(2906002)(66446008)(66556008)(64756008)(91956017)(8676002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVNRRkxod1M1UGVDL3g0aFcxWmhKQnE0VWpwUEJ1ckYzbEhOYkVISG5ER0w0?=
 =?utf-8?B?TmxVTzZ5L2hWOSsvWTNzdDk2b1dnYU8zOERUbXlpMENIS2hjS2dFd0R6d3I0?=
 =?utf-8?B?dkd2R1lzdTVFNHQxTHZsTDh2T3VUVlJnci9NVzVMRlpZRDB2UU5YM2ZoTzAr?=
 =?utf-8?B?SXdUWEhzd1VuNEpGcXRjM0YrbCt2blJvbGt2USs0ZkIrVmdmMnNKb2lRMlU1?=
 =?utf-8?B?bHFaT3g5K0ZDcUtWRkdBaFZVTVhWVytLcWs4aXhyUGxLNWQzS1VEQmtLYmhW?=
 =?utf-8?B?dmtCR3FqTmhnaHhySjBxYUN3dlRBSkVTOGExMXgwOFd6bnNxTDN3dGlRYTZw?=
 =?utf-8?B?Vys0TlVsbTlVenJndHlwTlg1RllLcUNKT0l1UThhWHBOTzc0ZWxuL3hWY2xE?=
 =?utf-8?B?VlJFZkx3blkwQmVmR2RYWDg0aXk5NE50cGd4ZUxLMFR5NUREWWx3YW1ZcE1s?=
 =?utf-8?B?amxuQndXb21JWmNBZFN2bnprRlpQcFllL1E5TldkRHN3Q1dsNkw1cXZuTzE4?=
 =?utf-8?B?MzVnNmttSXl0anNrb0d3ZGxGVzI5RDMwK1FQMEowTEVYY1pMVm9PMEJTd3BZ?=
 =?utf-8?B?b0Zqc2prZDdyMXRrZ3BZcmdMS3ByUWFhVFJNRTFwRUNQVy9VNTR4UTE1Zkp6?=
 =?utf-8?B?UjROdW5LK1FCUzQ4ZUowQ2hKQnV2emR0Y1JjVllNRVlXWGpCeUVJT0YrNWFV?=
 =?utf-8?B?di9iVmxEcG5IdW9DUjZWd2t4cGNqeUMwZ21qRE51NUVoWGYwS2JPN2FpOGYx?=
 =?utf-8?B?U092SGJpWUk1RTF1MGFqbkZGV2JTcUkxTkpwa3hXYm1FWkhNbTE4OFFST3BO?=
 =?utf-8?B?dFJBdkpRcEdNODlRSlZuZmFnODhEKy9ibUV4c2d2TzZ3Z3gvSTBEQUErNDht?=
 =?utf-8?B?L3NPZld6Nm44cng4Ujh4R1hoWnlhd0lyZXRyMDdnNkhWSzdTdU9ZOXZORjIx?=
 =?utf-8?B?R0g5VUFTalQ4S2pwalNjQ3RlM0ttVU5RSmtpd0tqZ2crR3BrNTJmcTVVNFo0?=
 =?utf-8?B?TlVBckhDRktwc1RoTDFrUzdzRnZ0cWt0NnF6cmRVWUZ0Y0JqNHZLUE5hM1ZE?=
 =?utf-8?B?T083ZTI1K2JOdkJ6ZnFqekpXOFAraVVseDFYYnVXQXlEZFB1RFJsU3Q4dXJp?=
 =?utf-8?B?MHVBQXlWYzhvNDVFN21wcFdEdDdtTzFUR2tHbm1zczA3N1BnVWlxTE5jVXRk?=
 =?utf-8?B?cnNwK2s0N1hrZHhUOVhwVnBsNFBIQTY5aXB0bmU2YktJN29aVEZLVjNkalNB?=
 =?utf-8?B?YVVNMzFUNDU4MTVVNVBSQ3A5V05lUGczaUt0a1g0WXg2ZXJuVzJRcTVKNFJH?=
 =?utf-8?B?bkp5VHVZbmpud3V1UW1taE15WTZjeEQyZ2xETVBJbVljUlV5TlN0SzJNRDRN?=
 =?utf-8?B?OS9hOEQ3ZjdxTUtvUkw5bXRvODBOYncybk9UUkZ3MUcrL29PNjJjMmt3ZnVq?=
 =?utf-8?B?YXIvckttU0tuSk00cTBtVmI4RkdwOExLU0dUMjNTSzRmbDlUTzZsYmVuUnZF?=
 =?utf-8?B?aTU1emE2Z01zcnNSZnUyRDVkeEFPVUdha0QwNEdYY212eTd6ZmNHZXNzL3U0?=
 =?utf-8?B?S0Y3clc4SEgyYWt1ZURxbkhobTZlK2RpaXh2QitLUkNaTy8zeUhiSCtJd3Yr?=
 =?utf-8?B?ZVd5UkVlbjBmU2wwblRieGprVUtKaHU0MVo5UHNGV095UkR1VGFPZ1MrTnFa?=
 =?utf-8?B?TUgvQmYxd0hBbnZGai9OMjA5SWUwNUI1d1YxYkI2bDhKNXlSak9hU3NlVnBy?=
 =?utf-8?B?WU9UK0dzZzRiSURqTmJ3d2IvVFh0UWg4eHFxYXdCOVlQeGh6VjY5WStqdTBm?=
 =?utf-8?B?Y1lkQW5QK0ZQRUZZYlJ3ZjJ1WmpFQWRla3ZNSGwxd1lmOU5lcnFFUVpieFA2?=
 =?utf-8?B?VVY0cWIwV2M0KzRWNEhwbVF0N1Zic3lyMjVNYkdESllLOHlLSHRzRHFXcUFJ?=
 =?utf-8?B?SHZvZ0xaK2dXMjFqc2VkZEpJc2E2MGd3QUE2elg5NXpUR0txLzNscDh3Tnk5?=
 =?utf-8?B?OWxDRjduUitBM0x1Q2JndmlEWVNKWCtES082RktkU0gzQ2pCZ0JoYUhmWDNt?=
 =?utf-8?B?WDA4dGZQSFVxRzhQZEpad09Bd29jWkZLZkIyMHE0ZEhXOEFQNjNtZlBXUjZB?=
 =?utf-8?B?aExvYnQ4clRTdnFtcTJrcUVrZFBEMCsxTlhML2N2aHhpK0t6eG1TUHNqQ1VM?=
 =?utf-8?B?blE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <590D4FD98D1D3E4CB4B432F832AC22E2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bea8b4d-751b-490c-b022-08db0edbf0a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 22:36:40.0499
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iElz+wm9umUOEHgKrnAzW4vsDKRxhwUqrR+2SzyJtJsT2KFbauXXEaGH6j20WWPSC8wdrWB2yveUYIu0Nop16Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8146
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gVHVlLCAyMDIzLTAyLTE0IGF0IDE1OjQyIC0wNjAwLCBIYWl0YW8gSHVhbmcgd3JvdGU6DQo+
IE9uIFR1ZSwgMTQgRmViIDIwMjMgMTQ6NTQ6NTMgLTA2MDAsIEh1YW5nLCBLYWkgPGthaS5odWFu
Z0BpbnRlbC5jb20+IHdyb3RlOg0KPiANCj4gPiBPbiBUdWUsIDIwMjMtMDItMTQgYXQgMTM6MTgg
LTA2MDAsIEhhaXRhbyBIdWFuZyB3cm90ZToNCj4gPiA+IEhpIEthaQ0KPiA+ID4gDQo+ID4gPiBP
biBUdWUsIDE0IEZlYiAyMDIzIDAzOjQ3OjI0IC0wNjAwLCBIdWFuZywgS2FpIDxrYWkuaHVhbmdA
aW50ZWwuY29tPiAgDQo+ID4gPiB3cm90ZToNCj4gPiA+IA0KPiA+ID4gPiBPbiBGcmksIDIwMjMt
MDEtMjcgYXQgMjA6NTUgLTA4MDAsIEhhaXRhbyBIdWFuZyB3cm90ZToNCj4gPiA+ID4gPiBAQCAt
OTcsMTAgKzk5LDgxIEBAIHN0YXRpYyBpbnQgc2d4X21tYXAoc3RydWN0IGZpbGUgKmZpbGUsIHN0
cnVjdA0KPiA+ID4gPiA+IHZtX2FyZWFfc3RydWN0ICp2bWEpDQo+ID4gPiA+ID4gIAl2bWEtPnZt
X29wcyA9ICZzZ3hfdm1fb3BzOw0KPiA+ID4gPiA+ICAJdm1hLT52bV9mbGFncyB8PSBWTV9QRk5N
QVAgfCBWTV9ET05URVhQQU5EIHwgVk1fRE9OVERVTVAgfCBWTV9JTzsNCj4gPiA+ID4gPiAgCXZt
YS0+dm1fcHJpdmF0ZV9kYXRhID0gZW5jbDsNCj4gPiA+ID4gPiArCXZtYS0+dm1fcGdvZmYgPSBQ
Rk5fRE9XTih2bWEtPnZtX3N0YXJ0IC0gZW5jbC0+YmFzZSk7DQo+ID4gPiA+ID4gICAJcmV0dXJu
IDA7DQo+ID4gPiA+ID4gIH0NCj4gPiA+ID4gDQo+ID4gPiA+IFBlcmhhcHMgSSBhbSBtaXNzaW5n
IHNvbWV0aGluZywgYnV0IGFib3ZlIGNoYW5nZSBsb29rcyB3ZWlyZC4NCj4gPiA+ID4gQ29uY2Vw
dHVhbGx5LCBpdCBkb2Vzbid0L3Nob3VsZG4ndCBiZWxvbmcgdG8gdGhpcyBzZXJpZXMsIHdoaWNo
DQo+ID4gPiA+IGVzc2VudGlhbGx5DQo+ID4gPiA+IHByZWFsbG9jYXRlcyBhbmQgZG9lcyBFQVVH
IEVQQyBwYWdlcyBmb3IgYSAob3IgcGFydCBvZikgZ2l2ZW4gZW5jbGF2ZS4NCj4gPiA+ID4gVGhl
IEVBVUcNCj4gPiA+ID4gbG9naWMgc2hvdWxkIGFscmVhZHkgYmUgd29ya2luZyBmb3IgdGhlIG5v
cm1hbCBmYXVsdCBwYXRoLCB3aGljaCBtZWFucw0KPiA+ID4gPiB0aGUgY29kZQ0KPiA+ID4gPiBj
aGFuZ2UgYWJvdmUgZWl0aGVyOiAxKSBoYXMgYmVlbiBkb25lIGF0IG90aGVyIHBsYWNlOyAyKSBp
c24ndCBuZWVkZWQuDQo+ID4gPiA+IA0KPiA+ID4gPiBJIGhhdmUga2luZGEgZm9yZ290dGVuIHRo
ZSB1c2Vyc3BhY2Ugc2VxdWVuY2UgdG8gY3JlYXRlIGFuIGVuY2xhdmUuICAgDQo+ID4gPiBJZg0K
PiA+ID4gPiBJIHJlY2FsbA0KPiA+ID4gPiBjb3JyZWN0bHksIHlvdSBkbyBiZWxvdyB0byBjcmVh
dGUgYW4gZW5jbGF2ZToNCj4gPiA+ID4gDQo+ID4gPiA+IAkxKSBlbmNsX2ZkID0gb3BlbigiL2Rl
di9zZ3hfZW5jbGF2ZSIpOw0KPiA+ID4gPiAJMikgZW5jbF9hZGRyID0gbW1hcChlbmNsX2ZkLCBl
bmNsX3NpemUsIDAgLyogcGdvZmYgKi8pOw0KPiA+ID4gPiAJMykgSU9DVEwoRUNSRUFURSwgZW5j
bF9hZGRyLCBlbmNsX3NpemUpOw0KPiA+ID4gPiANCj4gPiA+ID4gV291bGQgdGhlIGFib3ZlIGNv
ZGUgY2hhbmdlIGJyZWFrIHRoZSAibW1hcCgpIiBpbiBhYm92ZSBzdGVwIDI/DQo+ID4gPiA+IAkN
Cj4gPiA+IA0KPiA+ID4gTm8sIHZtX3Bnb2ZmIHdhcyBub3QgdXNlZCBwcmV2aW91c2x5IGZvciBl
bmNsYXZlIFZNQXMuIEkgaGFkIHRvIGFkZCB0aGlzDQo+ID4gPiBiZWNhdXNlIHRoZSBvZmZzZXQg
cGFzc2VkIHRvIHNneF9mYWR2aXNlIGlzIHJlbGF0aXZlIHRvIGZpbGUgYmFzZSBhbmQNCj4gPiA+
IGNhbGN1bGF0ZWQgaW4gbW0vbWFkdmlzZS5jIGxpa2UgdGhpczoNCj4gPiA+IA0KPiA+ID4gICAg
ICAgICAgb2Zmc2V0ID0gKGxvZmZfdCkoc3RhcnQgLSB2bWEtPnZtX3N0YXJ0KQ0KPiA+ID4gICAg
ICAgICAgICAgICAgICAgICAgICAgICsgKChsb2ZmX3Qpdm1hLT52bV9wZ29mZiA8PCBQQUdFX1NI
SUZUKTsNCj4gPiANCj4gPiBCdXQgc2hvdWxkbid0ICdvZmZzZXQgaXMgcmVsYXRpdmUgdG8gdGhl
IGZpbGUgYmFzZScgYmUgY29uY2VwdHVhbGx5ICANCj4gPiBjb3JyZWN0IGZyb20NCj4gPiB0aGUg
ZmFkdmljZSgpJ3MgcG9pbnQgb2Ygdmlldz8NCj4gPiANCj4gPiBJIHRoaW5rIHlvdSBzaG91bGQg
ZG86DQo+ID4gDQo+ID4gCWVuY2xfb2Zmc2V0ID0gb2Zmc2V0ICsgZW5jbC0+YmFzZTsNCj4gPiAN
Cj4gPiBpbnNpZGUgc2d4X2ZhZHZpY2UoKT8NCj4gPiANCj4gPiA+IA0KPiBJZiB3ZSBkb24ndCBz
ZXQgdm1hLT52bV9wZ29mZiAoZGVmYXVsdCB0byB6ZXJvKSwgdGhlbiBvZmZzZXQgd2lsbCBiZSAg
DQo+IGNhbGN1bGF0ZWQgYXMgKHN0YXJ0IC0gdm1hLT52bV9zdGFydCkuIFRoZW4gdGhlIGFib3Zl
IGNhbGN1bGF0aW9uIGlzIHdyb25nICANCj4gaWYgd2UgaGF2ZSBtdWx0aXBsZSBWTUFzIGZvciB0
aGUgc2FtZSBlbmNsYXZlLCB3aGljaCBpcyB1c3VhbGx5IHRoZSBjYXNlLg0KDQpkb19tbWFwKCkg
LT4gbW1hcF9yZWdpb24oKSBpdHNlbGYgc2V0cyB2bWEtPnZtX3Bnb2ZmOg0KDQoJdm1hID0gdm1f
YXJlYV9hbGxvYygpOw0KCS4uLg0KCXZtYS0+dm1fcGdvZmYgPSBwZ29mZjsNCg0KCWlmIChmaWxl
KQ0KCQljYWxsX21tYXAoZmlsZSwgdm1hKTsJPC0gc2d4X21tYXAoKQ0KDQpJIHRoaW5rIHlvdSB3
aWxsIGFsd2F5cyBjYWxsIG1tYXAoKSBhZ2FpbnN0IGVuY2xhdmUncyBmZCB3aXRoICdwZ29mZicg
YmVpbmcgc2V0DQp0byB0aGUgb2Zmc2V0IHJlbGF0aXZlIHRvIHRoZSBmaWxlPw0KDQo+IA0KPiA+
ID4gSSBoYWQgYSBjb21tZW50IGluIGZpcnN0IHZlcnNpb24gYnV0IHJlbW92ZWQgaXQgYmFzZWQg
b24gSmFya2tvJ3MNCj4gPiA+IHN1Z2dlc3Rpb24gaGVyZTogIA0KPiA+ID4gaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvYWxsL1kyQjBqQnNHNkhFNEtWazdAa2VybmVsLm9yZy8NCj4gPiA+IA0KPiA+
ID4gVGhlIG9yaWdpbmFsIGNvbW1lbnRzIHByb2JhYmx5IHNlZW1lZCByZWR1bmRhbnQgdG8gdGhl
IGRlZmluaXRpb25zIG9mICANCj4gPiA+IHRoZQ0KPiA+ID4gdm1fcGdvZmYgZmllbGQgYW5kIHRo
ZSBmYWR2aXNlIGludGVyZmFjZS4gQnV0IGxldCBtZSBrbm93IGlmIHdlIG5lZWQgIA0KPiA+ID4g
YWRkIGENCj4gPiA+IG1vcmUgaGVscGZ1bCB2ZXJzaW9uIG9mIGNvbW1lbnRzIG9yIGFueSBzdWdn
ZXN0aW9uIG9uIHRoZSBjb21tZW50cy4NCj4gPiANCj4gPiBJIHN0aWxsIHRoaW5rIHRoaXMgY29k
ZSBjaGFuZ2UgaXMgd3JvbmcuDQo+ID4gDQo+ID4gRm9yIGluc3RhbmNlLCBJSVVDLCBpdCBhdCBs
ZWFzdCBicmVha3MgdGhlIGNhc2Ugd2hlcmUgZW5jbGF2ZSBoYXNuJ3QgYmVlbg0KPiA+IGNyZWF0
ZWQvaW5pdGlhbGl6ZWQsIHdoZXJlIGVuY2wtPmJhc2UgPT0gMCAoYWx0aG91Z2ggbm9ybWFsIGNv
ZGUgcGF0aCAgDQo+ID4gZG9lc24ndA0KPiA+IHVzZSB2bV9wZ29mZiwgY29uY2VwdHVhbGx5IGl0
J3Mgc3RpbGwgd3JvbmcgSUlVQykuDQo+ID4gDQo+ID4gTWF5YmUgSSBhbSBtaXNzaW5nIHNvbWV0
aGluZz8NCj4gDQo+IFRoZSBmYWR2aXNlIGludGVyZmFjZSBpcyBvbmx5IHVzYWJsZSBmb3IgYW4g
aW5pdGlhbGl6ZWQgZW5jbGF2ZSwgIA0KPiBzZ3hfZmFkdmlzZSB3aWxsIHJldHVybiBlcnJvciBv
dGhlcndpc2UuwqANCj4gDQoNClRydWUuICBCdXQgdGhhdCBjb2RlIGNoYW5nZSBpcyB1bmNvbmRp
dGlvbmFsbHkgY2FsbGVkIGZvciBhbGwgbW1hcCgpLCBldmVuIHdoZW4NCmVuY2xhdmUgaGFzbid0
IGJlZW4gY3JlYXRlZC4NCg0KPiBDb25jZXB0dWFsbHkgSSB2aWV3IGVuY2xhdmUgYmFzZSAgDQo+
IGFzICJmaWxlIGJhc2UiLCBpdCdzIGp1c3QgdGhhdCB3ZSBkb24ndCBldmVyIG5lZWQgaGFuZGxl
IHRoZSB6ZXJvIGNhc2UgIA0KPiBjYXVzZWQgYnkgdW5pbml0aWFsaXplZCBlbmNsYXZlIChraW5k
IG9mIGxpa2UgYSBmaWxlIG5ldmVyIG1hcHBlZCkuIElmIGFuICANCj4gaW5pdGlhbGl6ZWQgZW5j
bGF2ZSBoYXBwZW5zIHRvIGhhdmUgemVybyBiYXNlLCBpdCB3b3VsZCBhbHNvIHdvcmsuDQoNCkEg
bGl0dGxlIGJpdCBjb25mdXNlZCBhYm91dCB3aGF0IGRvZXMgImVuY2xhdmUgYmFzZSIgaGVyZS4N
Cg0KVG8gbWUsIEEgZmlsZSBpcyBhbiBlbmNsYXZlLCBtZWFuaW5nIHRoZSAiZmlsZSBvZmZzZXQi
IGVxdWFscyB0byAiZW5jbGF2ZQ0Kb2Zmc2V0Ii4gICJlbmNsYXZlIGJhc2UiIGlzIHRoZSBiYXNl
IGxpbmVhciBhZGRyZXNzIG9mIHRoZSBlbmNsYXZlLCBpdCBkb2Vzbid0DQptYXR0ZXIgd2hldGhl
ciBpdCBpcyAwIG9yIG5vdC4gIFlvdSBnZXQgYW4gImVuY2xhdmUgYWRkcmVzcyIgZnJvbSAiZW5j
bGF2ZSBiYXNlIg0KcGx1cyAiZW5jbGF2ZSBvZmZzZXQiIChvciAiZmlsZSBvZmZzZXQiKToNCg0K
CWVuY2xhdmVfYWRkciA9IGVuY2xhdmVfYmFzZSArIGVuY2xhdmVfb2Zmc2V0L2ZpbGVfb2Zmc2V0
Ow0KDQpBbmQgc3VjaCBjYWxjdWxhdGlvbiBpcyBvbmx5IHZhbGlkIGFmdGVyIGVuY2xhdmUgaGFz
IGJlZW4gY3JlYXRlZCAoZW5jbGF2ZV9iYXNlDQppcyB2YWxpZCAtLSBjYW4gYmUgMCBvciB3aGF0
ZXZlcikuDQoNClNpbmNlIHNneF9tbWFwKCkgY2FuIGhhcHBlbiBiZWZvcmUgZW5jbGF2ZSBpcyBj
cmVhdGVkLCBjYWxjdWxhdGluZyB0aGUgdm1fcGdvZmYNCmZyb20gZW5jbGF2ZV9iYXNlIGlzIGNv
bmNlcHR1YWxseSB3cm9uZy4gIEV2ZW4gaWYgeW91IHJlYWxseSB3YW50IHRvIGRvIGl0LCBpdA0K
c2hvdWxkIGJlOg0KDQoJaWYgKGVuY2xhdmVfaGFzX2luaXRpYWxpemVkKCkpDQoJCXZtYS0+dm1f
cGdvZmYgPSAuLi47DQoNCkJ1dCBhZ2FpbiBJIGFtIG5vdCBjb252aW5jZWQgd2h5IHlvdSBjYW5u
b3QgZ2V0IHRoZSBlbmNsYXZlX2FkZHIgaW5zaWRlDQpzZ3hfZmFkdmljZSgpLg0KDQo=
