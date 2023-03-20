Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E82EC6FD1D
	for <linux-sgx@archiver.kernel.org>; Mon, 20 Mar 2023 09:36:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbjCTJgy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 20 Mar 2023 05:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbjCTJgc (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 20 Mar 2023 05:36:32 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA19E20548
        for <linux-sgx@vger.kernel.org>; Mon, 20 Mar 2023 02:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679304978; x=1710840978;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gB2BKa5RDl8+Wu9aeEuN+RsyI1IxPiu8egcPMhcNMyU=;
  b=PnmGzXu3cPKQ5i9w2SYqr1ThDnKRlI9aMmoSt1Y2MJ+PHjCTPVpFITqb
   r51/PCqE2KxiNohqEYFtx/HVGTtFyhR1NSWqPiYGijqlGfThX4ruQcv2c
   ItWb8rOZrsJwlt1kqY1ArC8E2Tu3T9yI52M5r6PmQUbkzOhZeGJY5CzBN
   8Bl4OT2sFunXxjkjEAVHqtS55Hf1LXOuWOgIsoJEcDTcCAcEb5YsKvo60
   qXUjN1+0xFvfgFsfHU9BzNVpNdOazyz9JfjTvFiOQdQs6cTB0ZEGhjhmw
   HBY+onmbdy06Z0lNZOy4FOOtYJdW/AzDKF+SYfrFew5ip6jjE6q7vZeyS
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="366333245"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="366333245"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 02:36:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="631064026"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="631064026"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 20 Mar 2023 02:36:17 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 02:36:17 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 02:36:17 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 02:36:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KOaqEWSn6mVfhEAj1qjD53nyfVi9Hwxh7QFLL29dOA6xiE1BhK7BgHifHwWJx6jdPafBZZFX1+DGNMXinXsRJ3tFO+VNhOPXNmEPPhrssys7iynpW1wtipZtJCOKP4PwnmHWO4aF1O3J9pcal3JhomyXK+Nlmn/9t5ex5khG1Tz5CUf03Vw4ViJ7eWNlUY64DPzwMAOs4jNX9XhKqQKuPf2eiVa11pOYAY/N3XIsDyS2fIlx3XRyIQxQAfE2miBdyYPAjYJ2YX4VtKYQLeJr6CG6Ts+1mOYOVnZwRHof5g6nGKaim5wWHM1xONaTXBw4D3nmFaY2uLNKdGBGtrkTQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gB2BKa5RDl8+Wu9aeEuN+RsyI1IxPiu8egcPMhcNMyU=;
 b=huWS/9UNm4qeTp14TGm3/m1bG16X0WxAyUv3TnQqoQU/curvTYgaDo7h25Nwq/4UyPFahaIKGyoFJ8BIEl+SZHAAAka+LawwKPiE5vDZfRnyDE87P4iVrCewCQjU5SyLykmrETS1bypYUfXkEl80pyTCol13oj/rGc+VtvephBVUrBc/Y4mxjegrt5zt76GVefQ0Qiz9AxssDRYc6Nqcjh8P46SxMUNso10egzR+NuSvYM9EhNip8CjLr9aRYqKSDXXU4tipW5nZDy+ZOMRjMWxCPs9/XNmthm5a3CXQTNn0MaEfXITcSDM3Fc/A0/CaYFEutmeCsXNVHkTpkQD99w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 09:36:15 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%4]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 09:36:15 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "jarkko@kernel.org" <jarkko@kernel.org>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Topic: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Index: AQHZMtTIU78a0A3o9UaUPrwPUmNX5q7OTQIAgACfroCAABrOAIAADTuAgAAPNoCAAFobgIAAUaaAgABy3wCAA5ciAIAACKGAgAY6gQCAADnpAIAV3bGAgAGoFwCAALMwAIAIFGUAgAfC9QCAAVIZAA==
Date:   Mon, 20 Mar 2023 09:36:14 +0000
Message-ID: <3766cb40f79b9fb931e3b254c01e45f56e2777e1.camel@intel.com>
References: <ef4087489625b0f8403c38e61348010dba62f623.camel@intel.com>
         <op.10ey84qywjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <Y/AAbC/j04aUkd8R@kernel.org>
         <op.10i8zfw3wjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <Y/VBOkmi7VbVuzAh@kernel.org>
         <op.10qusgctwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <5de607230294552829b075846a66688f65f3f74e.camel@intel.com>
         <op.11iklswmwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <e65d5e589e404f37b3f9ea15a2fd8e132d9040a1.camel@intel.com>
         <op.11sw04rxwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <20230319132606.yatircsujyj6got5@kernel.org>
In-Reply-To: <20230319132606.yatircsujyj6got5@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7345:EE_
x-ms-office365-filtering-correlation-id: c9c1a4c8-5a0c-46c2-675d-08db29268cc4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VU5kzt/D/qOnHSrgHbTtgrWFa6ph4gZu5C7kCmoRW5mNZwMkG6hRhJImam5KbMQHN3Vu6dYcjPJHB2NCRKzn1YxARumWCUcEzOCUN+zwIYF2nx6c9frpP14C9T7YBRX/mQh8N+KHeKCyHCAznuPcVxvdRup7KgsIfhRSgpqSZ4KajeYJXOCl/e/8GCSkDT8HRDNb+IcGcn/YAgRw1K3Zye4PB+ngWdfVBeBw27bQ5ksP150/QSP/rDRw9/aptmy+RNa8dI306LHGr+tsJBjiTLvk2JugVBdZ1D1TEwjZNftcypx6KkMmU/Fo/SW/AYokael15L4Wfge3RlsrubNi73OveF/ZeeDTLY0o6iSgGXPM6H2JRa2YH+FtTwoJUrbS4EfJZkJoJoprQJR1RPYOp0htrnRBiFafpnsSAIiMb61/XOY6m41JpaN5KWpP2cFlZpr8ey6A3IncnwVp1ZbgULjkLpTDIvx0vk/qBwHD/OD/KhD7OZvGYYxs2DHfTAksEOX37uS7WB8WsR5Hl7s8hU6uIz2iJSgoL0jfntOOi2Ql91qHJNk+7HPkGZaQn54jTKPfagsA1rVg65uE7wsuPKLCFDnM27A1qdPvVONnBamedqvuonkiTA3M5ytg3JRpgC4RpbKmtIdMxrBIb2Rj7T6P2Rz8gBYzZZzIdBfN7fgixFCerBTori37iVupmF+9+ppk2+5KyCn6gge8IJ+z/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(346002)(396003)(39860400002)(136003)(451199018)(5660300002)(8936002)(41300700001)(86362001)(38070700005)(38100700002)(122000001)(82960400001)(36756003)(2906002)(83380400001)(6512007)(26005)(478600001)(186003)(6506007)(4326008)(6486002)(71200400001)(91956017)(64756008)(66556008)(66446008)(66476007)(54906003)(76116006)(66946007)(316002)(2616005)(8676002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aXA0WkFIWDFTWGhnU0tBc21TQW5SOEVQOThyTisvRU10RkhORWUrNjM3R2xS?=
 =?utf-8?B?WCs0aXpvU3Fuc0tlSDBTQlRuMEVDamUveVVSVHhLY1pLQzB2UW1OVDJhU3hr?=
 =?utf-8?B?OE40Z0hzQVg1d2MweVlPK0M2bVMraTIvdTV4eGtHZDFSdHl1WkRZRFp5ZDNw?=
 =?utf-8?B?eWxWaUNZd21tQ3dnNkl1VEViSHpDUk9xSFVqU3hiUDlmZElJVU4zdDJzZ0dh?=
 =?utf-8?B?RDZmZXlFUzB3a3lGeDhTMTd0Q2lOZ0tNekUzUmRUZWtYbFpBNDlOZUw3djlJ?=
 =?utf-8?B?a3F4NlJkRXcrVTIxdVpuRlovZzhvU3poalpUeUF2WjVkODlBb2gxQXgyRWFq?=
 =?utf-8?B?U2ZmT3JiMzRudGxyZmhFaW1NVERyWlZNcllBRE0zMFFDeXJlUnp5dmQ4ZUo3?=
 =?utf-8?B?d1VHRWdEOTBjamQ1bDFscWgra2pnU0RWOGExdXNkOE9pdWFGdkMxdGV2L3Nl?=
 =?utf-8?B?dWYxTERuUkdOc3hYdnZwa3dsMGZqOHI3clNZc0FsV2ZINEJlRXBPTmNPTlpQ?=
 =?utf-8?B?VHhXTmV2UkpWZE16a1d0SXB5UVhRZHNiQklKNWhrd01GZlJwMDlxZkd0M0xm?=
 =?utf-8?B?YTliNEl0bXpjRjNTZkNEcG5Wd3hhQnZXQk85bjJGQTQ2U0wvdzdkbHZHa29I?=
 =?utf-8?B?WFlkSzE3eEE4ZFZXY3dXQnFIMkZ0TWdTalZYeW1tRHBtN3I4UWhCYVR2aVJm?=
 =?utf-8?B?akxLSExBTkZvOUQ0K1VYalNoT1ZlU1puSFhnV08vOGVjYWF1eUhhM1JZVjhw?=
 =?utf-8?B?NHpYTjlYbjdsYzEwL1hwNndvYmJtWTdESTdsTmc2T2c2VVdNQnFPcjFXNXFa?=
 =?utf-8?B?K0RhWkVWTHlHQjEyR2xvNUV0akhpUWt3Q1VFdjZjcjE2YjhXc2JaTnhGaURR?=
 =?utf-8?B?cWpuTFFneXpUb2tkUG5SczlZOEk4U2EwMDE4anAwVWN1N1pTSnRtWUt4TnRG?=
 =?utf-8?B?Sll1V0NNZmRPaWI0VkUyK3hscGZtRFJTdnY0RDgxdkFCSjBwcDk0b05jT29W?=
 =?utf-8?B?eDMxa3k2ZFgxRTV4Yk5iRTVMeGw0Ukt4UmRaZjBGWUZNNjRhT3paNDNwVFg3?=
 =?utf-8?B?R0YwMnhhTlNhcWxpY0VCL3hMZytqS09HUHNzSUNhK2VKTGxnZHRxNXAwMXc3?=
 =?utf-8?B?ZGFoRng2WUdoZkxYNUd5YmErVGplYklVL1JRbmk4eEEyMVJya3JRMWhRN0px?=
 =?utf-8?B?d3dqTjduUkdLbVh1R3RPTGNwRGtDZWFuWS9yNmtVVGhZS210NWdpQnNkR1Fi?=
 =?utf-8?B?U0JhVW5teGJSZlhXSTA2ZTRlNndZc1BqL2thVkswWkZ1YVBSY2xhdUFldVhV?=
 =?utf-8?B?RCthNkozNnR5dkxncytvY29oZk55MDhRenMyM2swY2xldkRhM25iQXlPRHR0?=
 =?utf-8?B?NWl1OEl2bjlCWHVGcFl4dENma3EwMlhFYzJ2NkorTW5QbXNzV21ZTTgxa2tY?=
 =?utf-8?B?eE5Ec0lrYXBET3I4L2daUzBzWDZheTB1TGRHdHRhMnl6N1dmczZlQTZhb1Zy?=
 =?utf-8?B?RVZxckNzT3VBNGU5ZjRTR2QyZDJFNFFjZkp2NkRzOXBLSHI1dHpsMzZLbFQv?=
 =?utf-8?B?Q1dIZUNsK2YzNWt3ck5KUEx0Vm80aldJVERQSURMaTdFaG1yK3ZiclNyT1Y3?=
 =?utf-8?B?N0M4Z1VwZVBFdDJML1MxUlVZajZKR1VKS29vcW5QWnp2ZkpFYlB0dnJzczU2?=
 =?utf-8?B?NTBsTU9DbXlmaWtMQXRucEd3cy9hMWc5VFpJNno0dHpaTGRzZ0R6LzUwNGVZ?=
 =?utf-8?B?RVk3cWVHOXNGWWZBQ0Jnd0xUYlZuYWR1R2VmdFZ4U0RVbXNDOVlkeU9XNUJa?=
 =?utf-8?B?SzQrRjNlME5SQ2JnbkNJeDhKZlBkTnVWZk51d3pBMFpRQithWGttZWdUNGJt?=
 =?utf-8?B?YmZTYThEeDFzajdyMzdPaCtHaytuTE85a1ZsWUNDdUFZNC80VFdLWCtkRDd3?=
 =?utf-8?B?ZlJiZUZVVE9TYXdseVNzV1BCTnQzVzBMYy91ZFJNVkVwR0RWbmpOaGxHU0xi?=
 =?utf-8?B?cHFLRkdFSis3WU02V1psT0FVamFnL3dlQ2cvZVpCd2s5bWJxYWZkV24yWHI4?=
 =?utf-8?B?U2xsaTh4cTFMWU1xSTRGZTNWaHltSjFHb0YwVkVPV1E0YVpBSmdnQWUzSHR4?=
 =?utf-8?B?U3ZnclhWNmEyWjEza2NITWJTZW9DMlIycWJQYml4Zld3RWFIQ0I2WU1uYVYy?=
 =?utf-8?B?emc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E79368FE1F4E8B47924DF742E9038E2F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9c1a4c8-5a0c-46c2-675d-08db29268cc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 09:36:14.9610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DlOVRyTdL5CzuRwVFu1kfT0NrqdTzscMH4Y8pJVxGbfYWECxUI5pbPIlYktQJP2t9F6ibyCLua5CvZ4aFkvGjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7345
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gU3VuLCAyMDIzLTAzLTE5IGF0IDE1OjI2ICswMjAwLCBqYXJra29Aa2VybmVsLm9yZyB3cm90
ZToNCj4gT24gVHVlLCBNYXIgMTQsIDIwMjMgYXQgMDk6NTQ6MzBBTSAtMDUwMCwgSGFpdGFvIEh1
YW5nIHdyb3RlOg0KPiA+IE9uIFRodSwgMDkgTWFyIDIwMjMgMDU6MzE6MjkgLTA2MDAsIEh1YW5n
LCBLYWkgPGthaS5odWFuZ0BpbnRlbC5jb20+IHdyb3RlOg0KPiA+ID4gPiANCj4gPiA+ID4gVGhl
biBpbiB2MjksIFBST1RfTk9ORSBtYXBwaW5nIHdhcyBkaXNhbGxvd2VkIGZvciBlbmNsX2ZkIGJl
Zm9yZSBwYWdlcw0KPiA+ID4gPiBFQUREZWQgc28gdXNlciBzcGFjZSBoYXMgdG8gbW1hcCBhbm9u
eW1vdXNseSB0byByZXNlcnZlIHRoZSByYW5nZS5UaGUNCj4gPiA+ID4gaW50ZW50IHdhcyBzdGls
bCBub3QgdG8gYWxsb3cgbW1hcCBiZWZvcmUgcGFnZXMgRUFERGVkICh0aGUgIXBhZ2UgY2hlY2sN
Cj4gPiA+ID4gd2FzIHN0aWxsIHRoZXJlIHVwIHRvIHYzOCkNCj4gPiA+IA0KPiA+ID4gRG8geW91
IGtub3cgdGhlIHJlYXNvbiBvZiBkaXNhbGxvd2luZyBQUk9UX05PTkUgbWFwcGluZyBhZ2FpbnN0
IGVuY2xfZmQ/DQo+ID4gPiANCj4gPiANCj4gPiBJIHRoaW5rIGl0IHdhcyB0byBhbGxvdyB1c2Vy
IHNwYWNlIHRvIGRvIGFub255bW91cyBtYXBwaW5nIHRvIHJlc2VydmUNCj4gPiBhZGRyZXNzIHNw
YWNlIGZvciBlbmNsYXZlLg0KPiA+IEJlZm9yZSB0aGlzIHBvaW50LCB5b3UgaGF2ZSB0byB1c2Ug
UFJPVF9OT05FIHRvIHJlc2VydmUgd2l0aCBlbmNsX2ZkLiBUaGVyZQ0KPiA+IG1pZ2h0IGJlIGFu
IGlzc3VlIHdpdGggaG93ICNQRiBhbmQgRVBDIHN3YXBwaW5nIHdhcyBoYW5kbGVkIG9yIHRoZSBl
bGVnYW5jZQ0KPiA+IG9mIHRob3NlIGZsb3dzIHRoYXQgbW90aXZhdGVkIHRoZSBtb3ZlIGJ1dCBJ
IGNhbid0IHJlbWVtYmVyLiBBQkkgd2FzIG5vdA0KPiA+IGZpeGVkIGF0IHRoYXQgdGltZSBzbyBp
dCB3YXMgT0sgdG8gY2hhbmdlLg0KPiANCj4gWWVzLCB0aGlzIHdhcyBkb25lIGJlY2F1c2UgZW5j
bGF2ZSBuYXR1cmFsbHkgYWxpZ25lZCBiYXNlIGFkZHJlc3MuDQo+IA0KPiANCg0KU29ycnkgZm9y
IGJlaW5nIGlnbm9yYW50LCBidXQgeW91IGNhbiBhbHNvIGdldCB0aGUgYWxpZ25lZCBiYXNlIGFk
ZHJlc3MgdmlhDQptbWFwKCkgYWdhaW5zdCBlbmNsX2ZkLCBjb3JyZWN0PyAgV2hhdCBpcyB0aGUg
ZnVuZGFtZW50YWwgZGlmZmVyZW5jZSBiZXR3ZWVuDQptbWFwKE1BUF9BTk9OWU1PVVMpIHZzIG1t
YXAoZW5jbF9mZCk/DQo=
