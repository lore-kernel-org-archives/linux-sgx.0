Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87602EB64D7
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Jun 2023 03:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbjFPDto (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 15 Jun 2023 23:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjFPDtn (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 15 Jun 2023 23:49:43 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12CE269D
        for <linux-sgx@vger.kernel.org>; Thu, 15 Jun 2023 20:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686887381; x=1718423381;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UZdM1FSdvAJpV7hCr0ZKutEomxGmF4tuOTO2t4bQ5Z0=;
  b=Jh0LISgqwrlJs2xRGe8efHXXpceSBrvqXt3R8WjWBw2Ju+JVpH+0AF+m
   TFGJYaIjM1z4vmmYkOfIBmvHb1nC0204y66PcExgiujq7dJiym+6bfjhV
   lYx6HvGAFUkLixN+F4czGwHxLPTwmroyNlvV4xzVxEVBZ7BVBGiSYubGx
   HV2Qf0CAuzFnxPIu5X9E3F0E4+6xL78vTeDAtVGwdCMshRec/xT7drpPr
   BH6gyf0o0AIdZtRBCQ+45cQigCTah6OYDtwEVIO51PNs0IPw94tsCNy79
   gG+UHn9kIKW+PEfUjk1SlpCx2y75+7s+1MYeMEC/pq7kUyzTVgJluYv8F
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="445490159"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="445490159"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 20:49:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="825567823"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="825567823"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 15 Jun 2023 20:49:41 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 20:49:40 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 20:49:40 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 20:49:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hxoHd1DBDtTd2qyAvqWMHf4zU7yTbvdesvqIj2wnWqkd4Ux/SdUrCKpJyAfK4YmDujQ3qPeoyuSZWT0EyAoz3bI4EWK3kFped0VAOlfc+LDUUSh9qwTxaBpcN9LqyOr6dHHxiQLBG+u9nbzBoNg9wuC4z3vSY5n3qjY/koKJpK5Vx9cj6TVTF1td58dUFmHks40eMmNUwkPSqPO7krQE2SU9DI3O1Xgl7I+u5BFZ7b8JoKXmCQe3qBqNxfDo9ie7e6HjK0P+KDi66z7aSOvr8AgiL1IaM5QEpmMVeeRPMbcidp9opAynuao21UWh4KLXBlqAGNB+DByjF/7efD3Guw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UZdM1FSdvAJpV7hCr0ZKutEomxGmF4tuOTO2t4bQ5Z0=;
 b=hjyVfG2xeDU7cy+7KR/PHFZH/Eftf+VNtYrjXRl7/7xL14PjklI2XaebnHu0WQFg6H2kUJUrLQOTYG6SHrnMi4XumBjLnDUbodih+1p41zje+bb95ZGJCAw4cF/C2/AQcG+UsSZsF0ZIlMi7zDSZaG8M3OK+jE3Yi7tvXAPIg88HMC3/HV2oW7bE6HlaT1V+iVjZMeYGip2Vk1BkwG7XxLk0t+QfyFjWuvjs6ALULcpDXfe99K7UdoEvPYjhw6t18TuepeqAxq3NuKNEMFOxwkBlHY0Wf3eP1WHNU6ugeiVzYGazBlaYsIyK3MK7it+zBQCxWqxtplUaNk/Wkx8g6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB5863.namprd11.prod.outlook.com (2603:10b6:510:135::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Fri, 16 Jun
 2023 03:49:32 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6477.037; Fri, 16 Jun 2023
 03:49:31 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "jarkko@kernel.org" <jarkko@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Topic: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Index: AQHZMtTIU78a0A3o9UaUPrwPUmNX5q7OTQIAgACfroCAABrOAIAADTuAgAAPNoCAAFobgIAAUaaAgABy3wCAA5ciAIAACKGAgAY6gQCAADnpAIAV3bGAgAGoFwCAALMwAIB7cDIAgA/0eQCAD7ESgA==
Date:   Fri, 16 Jun 2023 03:49:31 +0000
Message-ID: <d0b65bbdd20a79a43d979b08972dd05bfc79b08c.camel@intel.com>
References: <3c7b4f7bf3e7c2a213662b1c9fdaa979050a9327.camel@intel.com>
         <op.10dekzjhwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <39903b057751d963e4e9b2a8cd5271fe3c102509.camel@intel.com>
         <op.10dk8lsjwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <c37bb20995f234aa724724a06c96c76f18252e66.camel@intel.com>
         <op.10d2otjlwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <ef4087489625b0f8403c38e61348010dba62f623.camel@intel.com>
         <op.10ey84qywjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <Y/AAbC/j04aUkd8R@kernel.org>
         <op.10i8zfw3wjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <Y/VBOkmi7VbVuzAh@kernel.org>
         <op.10qusgctwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <5de607230294552829b075846a66688f65f3f74e.camel@intel.com>
         <op.11iklswmwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <e65d5e589e404f37b3f9ea15a2fd8e132d9040a1.camel@intel.com>
         <op.15kug6t9wjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <5930de9d076d148ae572aa081c7dee8a5b696b61.camel@intel.com>
In-Reply-To: <5930de9d076d148ae572aa081c7dee8a5b696b61.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB5863:EE_
x-ms-office365-filtering-correlation-id: 104ac1a5-ead0-4bf5-d886-08db6e1cb14b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ch3mQOml4gSDCvkGpE2pUevrwR9v1dLLV1ucO47gNZr3mHwss3vM9NT/G1A9h+Hm2nuE4yBx8EJCtoCcKgiQvMF0f2wx2HB2DgjfG0MhdtPtnC3Fd2E2emhellr9cLUHdHaRTRwXa9Q2KsjPyisDshSxP2lcDOjJz7y1ouDxp03swsgpLkvG80T3/XWW2TqbxhXuC7vvWBV+/wUUt5o8NfA3gSNjHKlTDNKsUrBpTliIPMRmdx+3M3TDt1qQ4OnA+TxHmC8vy5bftj/fd5F52CrA60FPTpHI8hswotowoYHO2zVeEKCGTzct0h8qmXZFKWOIrlyLmU7OtkvLQXBKxClI5s091cgSm4csF4txrokudjg2XzRzXq+oWh0Azemq3yXt2pW7nXGBxzAOtlUtuKhSIuLXpvLhSrs4/4d2fP7/CPV29KoQlrZ6iVP/G08RIgimphNsD8rQ2wQxLsuPNw/c3dOWqOdV6i5sh8beh37s1OUocgIPVpNW7wgzsjRM1l4Ov4OoLUaUph29ci+RSMIRkfra3zbz4uiSh8N725DTJlIQtki+zq8ExXSngMGv4gZCC6Ha01aWRehr5xCaroM9FI4DSoHj5CSC6UVOfvQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199021)(122000001)(86362001)(38100700002)(38070700005)(8676002)(5660300002)(82960400001)(316002)(41300700001)(8936002)(66946007)(66556008)(66476007)(66446008)(4326008)(76116006)(91956017)(64756008)(110136005)(54906003)(83380400001)(2616005)(186003)(36756003)(478600001)(6506007)(6512007)(26005)(2906002)(6486002)(966005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aE1NaUNmTEpNVUU3U3ppYjlhbEtleVQ5eTNSZ1RwYXlPdGEzRHdncjMzUXY4?=
 =?utf-8?B?Sit2R3BHd0R4U1B2bzJDL01sdUREeHYxQkZ3NGVGVFI0TXBpc05jU2xielpP?=
 =?utf-8?B?RjZRTkdIOWxFUWw0Nm5reU81aGlhSnBRdGd2ME0yNVZ4bUxzaG1BbFE2SlFj?=
 =?utf-8?B?Y0VvbWpTWEJheDBqa0Ivb2I0TjVCTDVvWUZRS3dMM21PQmFCazUxNVh6UXZC?=
 =?utf-8?B?bWFxNG41SHBha2k1enhkZEcwcGxvQk1BRDk5d2NzZFpsU1VmTnBRYktFOHBN?=
 =?utf-8?B?RW9HQTNncGlFT0YrUElNczRHOHFjdmlTbWI2amM1U21MYmk3WGpuME9LRGJG?=
 =?utf-8?B?N3FUYSs3QklWVXlqZFo5cjBUdklqbFBPNjNkcHdkSmV5eGxVSHpYdE1rZ3ZG?=
 =?utf-8?B?UEpXSFZncjJIK25PYm5UNW5meFBUaVZWam94NUppaU9temtzV1NJRGNoTlRw?=
 =?utf-8?B?ZWZxaEQ2ZVVUQnUvaXEwZS9NaDRsRHJ0OUR1TFJTbk5WZVBoTGN1UmdlbGpE?=
 =?utf-8?B?bFU3T0J3OGRxUkIrekRVZDN0UnZqcWY3WlRCOTlIb2VLUUk5ZEZvMThUcFpR?=
 =?utf-8?B?dTE5MHdNOGtGUmwyeGQ3SHRlZ1BKdm9wQnNrbjVWNEprNElia0NmTVpQakxZ?=
 =?utf-8?B?SVVuWFBiSHc5WXprZW5QWHllNkxsNmNQT3NBb1ZvVUFocVZpaENEY3JzQ0Nl?=
 =?utf-8?B?ZlNDM1ZiR2FHRWhadzkvb2luNFNVWjkxRjI4Q0lHa3BwOHZTTFc4K3FTSUcy?=
 =?utf-8?B?czdsNkF2ek44RTB3aUZyL3loUzc2NnN5emo1U0k2MTJkTnpZS0hsS1k0S1h6?=
 =?utf-8?B?TE9QMEROWTJKWW1XZkxscU9iSDFKeGZxWDdQQ0xXN29XRTJNNEVHMzRSSkZw?=
 =?utf-8?B?U0hJVEo1eHRxUnVPWTN3NVFYNGMza3NNa240Q1FJSVlZV2FBM1A0Rmc5VVlO?=
 =?utf-8?B?THZTdkdhVDgxZy9KbUxDVjZGNExJb2xYd29tZXVRQW1UN3dMRTNrRmh3QkIv?=
 =?utf-8?B?N1ZBMS9lSlNENU5YRXY4aExWVDNBV200ZlREclAzbmtTbEx2Y2EyWWI4Vmli?=
 =?utf-8?B?M1JEM3N6RGtYWWUyTUxnaWh2cmRYclRwYmNiWGo4cVRHZm5nMTVEZHpnYits?=
 =?utf-8?B?TmFOU2ZNMmRBcThlY2pwMmh4cWdpZVlsZi94R3NTUG9jczdpWWdXbklJd3g4?=
 =?utf-8?B?ZlJFSnNXUW5Da081c0h1enRFOHFLZDhEUzIweDhLekNCNFVJVExqRTN1SGk3?=
 =?utf-8?B?Y3hwVmFaZjhBWWVaNWxlcWZUNTBuaGc2b2lkZERiWWs5Q2NNa0lsSmt0V3or?=
 =?utf-8?B?aS95YmdRWVFXVitGNjJFSGVVaTFLL05QdTJSMzFwUVczUW55Z0s2K1RmWVVa?=
 =?utf-8?B?TU5PWGxTbm1KREp2TVVmS0RHWHljaTVkbTZES1lUTW5OQlV4QU9JYkhBQ2ta?=
 =?utf-8?B?TFBJcG90YlA5VEVPSGMwSkZwK3RiN1BpODJJSTgrWDdzektheWNNd05wZTdx?=
 =?utf-8?B?dFc5bjZHUFgvbi8wQ3lwd0tyaHNwRWU3MGEvTXdKcjJ1cUJRSzRvTzliL08r?=
 =?utf-8?B?QStNZnZTUWJaWjVoNEVRQ3JzWGlWY3FPVG1jUVdyYU9TblVrTkJ4SzMzcEdl?=
 =?utf-8?B?Q3VJa2NPMDBtUkQxVHRZWkRjMWtocGc4RGxIK2FiVzZvTFc3ODNUaTFoR3Rk?=
 =?utf-8?B?enBWSE9vSHNlM25Zd3VSQllmVDdBak1nUUQ1QjhOWEtTUjVzWTVzc3I2TVRo?=
 =?utf-8?B?VUw2Mi9aUnVIRWp4T3pKQkc1NEJrdWhxUEVJcFp0bG5CdWhOQTZhWmpUMWtM?=
 =?utf-8?B?bjZ4SDMvTEN0UGlvUWRudytNNk1rbHBSeUd3R3ArTDdwSEJaNzVacHBwRk10?=
 =?utf-8?B?UTQ4NTJLam51ZjFhU3RDMkI1V3hFTmdMcUt6eExkM3pXTDkxdmlxd3I4UURl?=
 =?utf-8?B?MlpBb0hLRTRlRDZJTWVMZTJic1JCalE0dEtqQXZqRFdKMUpteUd0elVrUDB6?=
 =?utf-8?B?eTU0d09sTTJZUTdGZlBjNVkwOXo1Y0xnMzZuRUd6b1hTeUNNUHlPek5HdlhF?=
 =?utf-8?B?c1FUTlZJckIvZUhFL011S3E5T0xndXpQVmlMSDZzV2NLaCtyNjF6TlhLREVB?=
 =?utf-8?Q?zNPR3SYUzWn1wtue7OVLnIDmk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2E7368190D19F441A8392C1D61CD9CA9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 104ac1a5-ead0-4bf5-d886-08db6e1cb14b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 03:49:31.5523
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qzzWJfF9uyVcECNUApRL+sfVHC1PGUurzBTJanPiP5i5n8gjQboSdwAOeMSDBglRQVd5OFDNBwGkaoVdtHAH9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5863
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gVHVlLCAyMDIzLTA2LTA2IGF0IDA0OjExICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBGcmksIDIwMjMtMDUtMjYgYXQgMTk6MzIgLTA1MDAsIEhhaXRhbyBIdWFuZyB3cm90ZToNCj4g
PiBIaSBLYWksIEphcmtrbyBhbmQgRGF2ZQ0KPiA+IA0KPiA+IE9uIFRodSwgMDkgTWFyIDIwMjMg
MDU6MzE6MjkgLTA2MDAsIEh1YW5nLCBLYWkgPGthaS5odWFuZ0BpbnRlbC5jb20+IHdyb3RlOg0K
PiA+ID4gDQo+ID4gPiBTbyBJIGFtIHN0aWxsIGEgbGl0dGxlIGJpdCBjb25mdXNlZCBhYm91dCB3
aGVyZSBkb2VzICJTR1ggZHJpdmVyIHVzZXMNCj4gPiA+IE1BUF9BTk9OWU1PVVMgc2VtYW50aWNz
IGZvciBmZC1iYXNlZCBtbWFwKCkiIGNvbWUgZnJvbS4NCj4gPiA+IA0KPiA+ID4gQW55d2F5LCB3
ZSBjZXJ0YWlubHkgZG9uJ3Qgd2FudCB0byBicmVhayB1c2Vyc3BhY2UuICBIb3dldmVyLCBJSVVD
LCBldmVuICANCj4gPiA+IGZyb20NCj4gPiA+IG5vdyBvbiB3ZSBjaGFuZ2UgdGhlIGRyaXZlciB0
byBkZXBlbmQgb24gdXNlcnNwYWNlIHRvIHBhc3MgdGhlIGNvcnJlY3QgIA0KPiA+ID4gcGdvZmYg
aW4NCj4gPiA+IG1tYXAoKSwgdGhpcyB3b24ndCBicmVhayB1c2Vyc3BhY2UsIGJlY2F1c2Ugb2xk
IHVzZXJzcGFjZSB3aGljaCBkb2Vzbid0ICANCj4gPiA+IHVzZQ0KPiA+ID4gZmFkdmljZSgpIGFu
ZCBwZ29mZiBhY3R1YWxseSBkb2Vzbid0IG1hdHRlci4gIEZvciBuZXcgdXNlcnNwYWNlIHdoaWNo
ICANCj4gPiA+IHVzZXMNCj4gPiA+IGZhZHZpY2UoKSwgaXQgbmVlZHMgdG8gcGFzcyB0aGUgY29y
cmVjdCBwZ29mZi4NCj4gPiA+IA0KPiA+ID4gSSBhbSBub3Qgc2F5aW5nIHdlIHNob3VsZCBkbyB0
aGlzLCBidXQgaXQgZG9lc24ndCBzZWVtIHdlIGNhbiBicmVhayAgDQo+ID4gPiB1c2Vyc3BhY2U/
DQo+ID4gPiANCj4gPiANCj4gPiBTb3JyeSBmb3IgZGVsYXllZCB1cGRhdGUgYnV0IEkgdGhvdWdo
dCBhYm91dCB0aGlzIG1vcmUgYW5kIGxpa2VseSB0byAgDQo+ID4gcHJvcG9zZSBhIG5ldyBFQVVH
IGlvY3RsIGZvciB0aGlzIGFuZCBmb3IgZW5hYmxpbmcgU0dYLUNFVCBzaGFkb3cgc3RhY2sgIA0K
PiA+IHBhZ2VzLiBCdXQgcmVnYXJkbGVzcywgSSdkIGxpa2UgdG8gd3JhcCB1cCB0aGlzIGRpc2N1
c3Npb24gdG8ganVzdCBjbGFyaWZ5ICANCj4gPiB0aGlzIGFub255bW91cyBzZW1hbnRpY3MgZGVz
aWduIGluIGRvY3VtZW50YXRpb24gc28gcGVvcGxlIHdvbid0IGdldCAgDQo+ID4gY29uZnVzZWQg
aW4gZnV0dXJlLg0KPiA+IA0KPiA+IEkgdGhpbmsgd2UgYWxsIGFncmVlIHRvIGtlZXAgdGhpcyBz
ZW1hbnRpY3Mgc28gbm8gdXNlciBzcGFjZSB3b3VsZCBuZWVkICANCj4gPiBzcGVjaWZ5ICdvZmZz
ZXQnIGZvciBtbWFwIHdpdGggZW5jbGF2ZSBmZC4gQW5kIGhlcmUgaXMgbXkgcHJvcG9zZWQgIA0K
PiA+IGRvY3VtZW50YXRpb24gY2hhbmdlcy4NCj4gPiANCj4gPiAtLS0gYS9Eb2N1bWVudGF0aW9u
L3g4Ni9zZ3gucnN0DQo+ID4gKysrIGIvRG9jdW1lbnRhdGlvbi94ODYvc2d4LnJzdA0KPiA+IEBA
IC0xMDAsNiArMTAwLDIzIEBAIHBhZ2VzIGFuZCBlc3RhYmxpc2ggZW5jbGF2ZSBwYWdlIHBlcm1p
c3Npb25zLg0KPiA+ICAgICAgICAgICAgICAgICAgc2d4X2lvY19lbmNsYXZlX2luaXQNCj4gPiAg
ICAgICAgICAgICAgICAgIHNneF9pb2NfZW5jbGF2ZV9wcm92aXNpb24NCj4gPiANCj4gPiArRW5j
bGF2ZSBtZW1vcnkgbWFwcGluZw0KPiA+ICstLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gKw0K
PiA+ICtBIGZpbGUgZGVzY3JpcHRvciBjcmVhdGVkIGZyb20gb3BlbmluZyAqKi9kZXYvc2d4X2Vu
Y2xhdmUqKiByZXByZXNlbnRzIGFuDQo+ID4gK2VuY2xhdmUgb2JqZWN0LiBUaGUgbW1hcCgpIHN5
c2NhbGwgd2l0aCBlbmNsYXZlIGZpbGUgZGVzY3JpcHRvcnMgZG9lcyBub3QNCj4gPiArc3VwcG9y
dCBub24temVybyB2YWx1ZSBmb3IgdGhlICdvZmZzZXQnIHBhcmFtZXRlci4NCj4gDQo+IEkgdGhp
bmsgd2UgYWxsIG5lZWQgdG8gdW5kZXJzdGFuZCBiZXR0ZXIgd2h5IFNHWCBkcml2ZXIgcmVxdWly
ZXMgYW5vbnltb3VzDQo+IHNlbWFudGljcyBtbWFwKCkgYWdhaW5zdCAvZGV2L3NneF9lbmNsYXZl
LCBhbmQgYXMgYSByZXN1bHQgb2YgdGhhdCwgcmVxdWlyZXMNCj4gbW1hcCgpIHRvIHBhc3MgIDAg
YXMgcGdvZmYgKHdoaWNoIGxvb2tzIHdhc24ndCBldmVuIGRpc2N1c3NlZCB3aGVuIHVwc3RyZWFt
aW5nDQo+IHRoZSBkcml2ZXIpLg0KPiANCj4gSSdsbCBkbyBzb21lIGludmVzdGlnYXRpb24gYW5k
IHRyeSB0byBzdW1tZXJpemUgYW5kIHJlcG9ydCBiYWNrLiAgVGhhbmtzLg0KPiANCg0KKyBTZWFu
Lg0KDQpIaSBTZWFuLA0KDQpJZiB5b3Ugc2VlIHRoaXMgYW5kIGhhdmUgdGltZSwgcGxlYXNlIGhl
bHAgdG8gY29tbWVudC4gIFRoYW5rcy4NCg0KSSd2ZSBzcGVudCBwbGVudHkgb2YgdGltZSB0byBs
b29rIGludG8gdGhlIGRpc2N1c3Npb25zIGFyb3VuZCB2MjAvdjI4L3YyOSBhbmQNCnJvdWdobHkg
djM4L3YzOSB0byBmaW5kIG91dCB3aHkgU0dYIGRyaXZlciByZXF1aXJlcyBNQVBfQU5PTllNT1VT
IHNlbWFudGljcywgYW5kDQpBRkFJQ1QgaXQgdHVybnMgb3V0IGl0IHdhcyBuZXZlciBleHBsaWNp
dGx5IGRpc2N1c3NlZC4gIE9yIHBlcmhhcHMgdGhlDQoiTUFQX0FOT05ZTU9VUyBzZW1hbnRpY3Mi
IGFjdHVhbGx5IGp1c3QgbWVhbnMgIk1BUF9TSEFSRUQgfCBNQVBfRklYRUQgKyBwZ29mZiBpcw0K
aWdub3JlZCIsIGFuZCBldmVyeW9uZSBiZWxpZXZlZCB0aGVyZSB3YXMgbm8gbmVlZCB0byBleHBs
YWluIHdoYXQgZG9lcyAiU0dYDQpkcml2ZXIgdXNlcyBNQVBfQU5PTllNT1VTIHNlbWFudGljcyBm
b3IgbW1hcCgpIiBtZWFuLg0KDQpEZXRhaWxzOg0KDQpUaGUgdjIwIHN0b3J5ICh0aGF0IEkgc3Bl
bnQgbW9zdCBvZiBteSB0aW1lIG9uKSBtZW50aW9uZWQgYnkgSGFpdGFvIHdhcyBhY3R1YWxseQ0K
YWJvdXQgaG93IHRvIG1ha2UgU0dYIGFuZCBMU00gd29yayB0b2dldGhlciBidXQgbm90IHJlbGF0
ZWQgdG8gU0dYIGRyaXZlciBtbWFwKCkNCnNlbWFudGljLiANCg0KQWxzbyBIYWl0YW8gbWVudGlv
bmVkICJ0aGUgdXNlIG9mIGFub255bW91cyBtYXBwaW5nIGNhbiBiZSB0cmFjZWQgYmFjayB0byB2
MjkiDQpidXQgdGhpcyBhY3R1YWxseSB3YXMganVzdCBhYm91dCBob3cgdG8gdXNlIHRoZSBmaXJz
dCBtbWFwKCkgdG8gInJlc2VydmUgdGhlDQpFTFJBTkdFIGJlZm9yZSBFQ1JFQVRFIi4gIEl0IHdh
c24ndCBhYm91dCB0byBjaGFuZ2luZyBtbWFwKC9kZXYvc2d4X2VuY2xhdmUpDQpzZW1hbnRpY3Mg
YXQgYWxsLg0KDQpTZWFuIGFjdHVhbGx5IHN1Z2dlc3RlZCB0byBleHBsaWNpdGx5IGRvY3VtZW50
ICJob3cgZG9lcyBTR1ggZHJpdmVyIHJlY29tbWVuZA0KdGhlIHVzZXIgdG8gcmVzZXJ2ZSBFTFJB
TkdFIiwgYnV0IEphcmtrbyBkaWRuJ3QgdGhpbmsgd2Ugc2hvdWxkIGRvOg0KDQpodHRwczovL2xv
cmUua2VybmVsLm9yZy9saW51eC1zZ3gvMjAyMDA1MjgxMTE5MTAuR0IxNjY2Mjk4QGxpbnV4Lmlu
dGVsLmNvbS8NCg0Kd2hpY2ggaXMgYSBwaXR5IElNSE8sIGJlY2F1c2UgSSBiZWxpZXZlIGZvciBh
bnlvbmUsIG5hdHVyYWxseSwgdGhlIGZpcnN0DQppbnN0aW5jdCB0byByZXNlcnZlIEVMUkFOR0Ug
aXMgdG8gdXNlIG1tYXAoL2Rldi9zZ3hfZW5jbGF2ZSkgYnV0IG5vdA0KbW1hcChNQVBfQU5PTllN
T1VTKS4gIElmIHdlIHN1Z2dlc3QgdXNlciB0byB1c2UgdGhlIGxhdHRlciB0aGVuIHRoZXJlIG11
c3QgYmUNCnNvbWUgcmVhc29uIGFuZCBJTUhPIHN1Y2ggc3VnZ2VzdGlvbiBhbmQgcmVhc29uIHNo
b3VsZCBiZSBkb2N1bWVudGVkLg0KDQpBbHNvLCBpZiBJIGFtIG5vdCBtaXNzaW5nIHNvbWV0aGlu
ZywgdGhlIGN1cnJlbnQgZHJpdmVyIGRvZXNuJ3QgcHJldmVudCB1c2luZw0KbW1hcCgvZGV2L3Nn
eF9lbmNsYXZlLCBQUk9UX05PTkUpIHRvIHJlc2VydmUgRUxBTkdFLiAgU28gaGF2aW5nIGNsZWFy
DQpkb2N1bWVudGF0aW9uIGlzIGhlbHBmdWwgZm9yIFNHWCB1c2VycyB0byBjaG9vc2UgaG93IHRv
IHdyaXRlIHRoZWlyIGFwcHMuDQoNCkdvIGJhY2sgdG8gdGhlICJTR1ggZHJpdmVyIHVzZXMgTUFQ
X0FOT05ZTU9VUyBzZW1hbnRpY3MgZm9yIG1tYXAoKSIsIEkgYmVsaWV2ZQ0KdGhpcyBqdXN0IGlz
ICJTR1ggZHJpdmVyIHJlcXVpcmVzIG1tYXAoKSBhZnRlciBFQ1JFQVRFL0VJTklUIHRvIHVzZSBN
QVBfU0hBUkVEIHwNCk1BUF9GSVhFRCBhbmQgcGdvZmYgaXMgaWdub3JlZCIuICBPciBtb3JlIHBy
ZWNpc2VseSwgcGdvZmYgaXMgIm5vdCBfdXNlZF8gYnkgU0dYDQpkcml2ZXIiLg0KDQpJbiBmYWN0
LCBJIHRoaW5rICJwZ29mZiBpcyBpZ25vcmVkL25vdCB1c2VkIiBpcyB0ZWNobmljYWxseSB3cm9u
ZyBmb3IgZW5jbGF2ZS4NCg0KUGdvZmYgaXMgaWdub3JlZCBpbiBjYXNlIG9mIE1BUF9TSEFSRUQg
fCBNQVBfQU5PTllNT1VTIG1ha2VzIHNlbnNlLCBiZWNhdXNlIHlvdQ0KZ2V0IGEgbmV3IHNobWVt
IGZpbGUgZXZlcnl0aW1lIHlvdSBkbyBzby4gIEJ1dCB0aGlzIGlzbid0IHRoZSBjYXNlIGZvciBl
bmNsYXZlLg0KRm9yIGFsbCBtbWFwKClzIGFnYWluc3QgdGhlIHNhbWUgZW5jbGF2ZSwgcGdvZmYg
aGFzIGEgdmFsaWQgbWVhbmluZy4gIFNHWCBkcml2ZXINCmRvZXNuJ3QgdXNlIHZtYS0+cGdvZmYg
dGh1cyBpdCdzIE9LIHRvIG5vdCBoYXZlIHZhbGlkIHZtYS0+cGdvZmYgYnV0IHRoaXMNCmNvbmZ1
c2VzIHRoZSBjb3JlLU1NLCBiZWNhdXNlIG5vdyB3ZSBjYW4gZWFzaWx5IGVuZCB1cCBoYXZpbmcg
bXVsdGlwbGUgVk1Bcw0KbWFwcGluZyB0byBkaWZmZXJlbnQgcGFydCBvZiBlbmNsYXZlLCBidXQg
Y29yZS1NTSBiZWxpZXZlcyB0aGV5IGFsbCBtYXAgdG8gdGhlDQpzdGFydCBvZiB0aGUgZW5jbGF2
ZS4NCg0KRm9yIGluc3RhbmNlLCBoYXZlIHdlIHRlc3RlZCBhbGwgY29ybmVyIGNhc2VzIGFyb3Vu
ZCBWTUEgc3BsaXR0aW5nL21lcmdpbmcsIGV0Yz8NCg0KVG8gY29uY3VsZGU6DQoNCklNSE8gd2Ug
c2hvdWxkIHN0b3Agc2F5aW5nIFNHWCBkcml2ZXIgdXNlcyBNQVBfQU5PTllNT1VTIHNlbWFudGlj
cywgYmVjYXVzZSB0aGUNCnRydXRoIGlzIGl0IGp1c3QgdGFrZXMgYWR2YW50YWdlIG9mIE1BUF9G
SVhFRCBhbmQgY2FyZWxlc3NseSBpZ25vcmVzIHRoZSBwZ29mZg0KZHVlIHRvIHRoZSBuYXR1cmUg
b2YgU0dYIHcvbyBjb25zaWRlcmluZyBmcm9tIGNvcmUtTU0ncyBwZXJzcGVjdGl2ZS4NCiAgDQpB
bmQgSU1ITyB0aGVyZSBhcmUgdHdvIHdheXMgdG8gZml4Og0KDQoxKSBGcm9tIG5vdyBvbiwgd2Ug
YXNrIFNHWCBhcHBzIHRvIHVzZSB0aGUgY29ycmVjdCBwZ29mZiBpbiB0aGVpcg0KbW1hcCgvZGV2
L3NneF9lbmNsYXZlKS4gIFRoaXMgc2hvdWxkbid0IGltcGFjdCB0aGUgZXhpc3RpbmcgU0dYIGFw
cHMgYmVjYXVzZSBTR1gNCmRyaXZlciBkb2Vzbid0IHVzZSB2bWEtPnBnb2ZmIGFueXdheS4NCg0K
MikgRm9yIHRoZSBzYWtlIG9mIGF2b2lkaW5nIGhhdmluZyB0byBhc2sgZXhpc3RpbmcgU0dYIGFw
cHMgdG8gY2hhbmdlIHRoZWlyDQptbWFwKClzLCB3ZSBfb2ZmaWNpYWxseV8gc2F5IHRoYXQgdXNl
cnNwYWNlIGlzbid0IHJlcXVpcmVkIHRvIHBhc3MgYSBjb3JyZWN0DQpwZ29mZiB0byBtbWFwKCkg
KGkuZS4gcGFzc2luZyAwIGFzIGRpZCBpbiBleGlzdGluZyBhcHBzKSwgYnV0IHRoZSBrZXJuZWwg
c2hvdWxkDQpmaXggdGhlIHZtYS0+cGdvZmYgaW50ZXJuYWxseS4NCg0KSSBkbyBwcmVmZXIgb3B0
aW9uIDIpIGJlY2F1c2UgaXQgaGFzIG5vIGhhcm0gdG8gYW55b25lOiAxKSBObyBjaGFuZ2VzIHRv
DQpleGlzdGluZyBTR1ggYXBwczsgMikgSXQgYWxpZ25zIHdpdGggdGhlIGNvcmUtTU0gdG8gc28g
YWxsIGV4aXN0aW5nIG1tYXAoKQ0Kb3BlcmF0aW9ucyBzaG91bGQgd29yayBhcyBleHBlY3RlZCwg
bWVhbmluZyBubyBzdXJwcmlzZTsgMykgQW5kIHRoaXMgcGF0Y2hzZXQNCmZyb20gSGFpdGFvIHRv
IHVzZSBmYWR2aWNlKCkgdG8gYWNjZWxlcmF0ZSBFQVVHIGZsb3cganVzdCB3b3Jrcy4NCg0KQW5k
IEkgYmVsaWV2ZSB3ZSBzaG91bGQgZG9jdW1lbnQgYWxsIHRob3NlIHN0YWZmcyBzbyBldmVyeW9u
ZSBjYW4gdW5kZXJzdGFuZC4NCg==
