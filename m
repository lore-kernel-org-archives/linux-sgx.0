Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B85BC4321E
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Nov 2022 08:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbiKGI41 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 7 Nov 2022 03:56:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbiKGI4U (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 7 Nov 2022 03:56:20 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A012C1582F
        for <linux-sgx@vger.kernel.org>; Mon,  7 Nov 2022 00:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667811379; x=1699347379;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JZyHfjNV6kgMnz96nBMW2bekSxpBLnPM2AeWL03N+e4=;
  b=BER99I6S/ZTOmAkMBsomorKwvfYHtlzTMigylVwo5tERT6PCEg3GiWUb
   uXSOPFOuVzjv9kfFwf3qaqNphnb7xEmYWhjD44GCjyH2ITk3jqIAIlXXC
   yqmSBL2klkCXPkbk7lpnAW6sSyGdTpxtTpgwYpnlgiBUVMjSpChLatC7u
   ypJFmtq7Ozyk2taAIArO7Q3ir0ZyR3WM4zqF28mnkyltKFQdtI1KgcaNb
   4XpI8ThZsNJEFcwwZ5ly4UHDVWIv4aAcHyyL4cgeC6oMsSgKn2mKfa6K+
   qUzx6XebBWh9J9QyvFYmcWLiVusjALD6JbmUq9xme3KPHK3y5jC+WSxMC
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="307985795"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="307985795"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 00:56:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="778409786"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="778409786"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 07 Nov 2022 00:56:19 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 00:56:18 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 7 Nov 2022 00:56:18 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 7 Nov 2022 00:56:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R/u+BAHHLYplSSl4hQIzgDaA1v1Z3lkYP8q9ZNApnGMPsFAPIOa9QOlgjJpk1kz2svuwj/kfSoOc093NEJoQF9RGMOU0EkzZ+ziBwl3ez3a5eP1F/ne0S/+ChMuYniU9mAxkavDLQzjIOEEWbbHcyuCKRWH0tZ6lbO8ixLRrJNGDN90vjPH7XfbyvAdbtLydqIMw2C2rnB2aMHVYb+myDUJT2gkEiqIcJ4DeF2D3/bNcVla4SKkTpf8eACUybtJp5wCxKEzmdDvvJ5r+61jVi3WJFpJJJ/1tAqDfc3yq8XyyctW/D+TQhzGQonHKQTL4V3jaKtCL9W7f7VM7qP7opQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JZyHfjNV6kgMnz96nBMW2bekSxpBLnPM2AeWL03N+e4=;
 b=OgQwloXhG1mZhyaU1Gx8aU7Kr23lBMs/kPtj3q3Dwltl45pFvHntDZA8qu0Z71ijLdEFu9cVNpGhX5S8O1jmj5c1oGn4R2ZyM6CeKRCOikFwY9cZoayXocRo8w6VNZuQEC4MinACcgzAVBBi1jvYckrO3ZAB26yTJxh6H/VIA64t6khMpULMnozv8VUXks7IvYbBGiFDwrlfjP92oEENXBoE69uu5NNo9ZK5hKQ5k9FFZ5CkI4Rwl4JXDa/4eV84QmhVX4MzSlKlOUiuK4dGOrWxcv1zyDpE4vblP19NAFGV6MNPeXfiJRpUZOScVU0GciRYyf/CqFgY5YWBvwOeEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB6050.namprd11.prod.outlook.com (2603:10b6:208:392::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Mon, 7 Nov
 2022 08:55:56 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 08:55:56 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Zhang, Cathy" <cathy.zhang@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>, "bp@suse.de" <bp@suse.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>, "Du, Fan" <fan.du@intel.com>,
        "Li, Zhiquan1" <zhiquan1.li@intel.com>
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Thread-Topic: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Thread-Index: AQHYzLsOovV5qYztIkquos7ZMS9Qjq4JWziAgAD86YCAAJ5RgIABk7IAgAARzYCAAGXuAIAAA7UAgAADhICAAAPHAIAAFAEAgAAE0QCAAAYhAIAIjmSAgAbrTACAAFHqgIAMhb0AgAVWwACAAGbvAIAAAmiAgAQ2x4A=
Date:   Mon, 7 Nov 2022 08:55:55 +0000
Message-ID: <544990c9adf34c196a1e9333f6cdefb4ba39f2e8.camel@intel.com>
References: <5ade54ce8e182307309426e1055dcc580c1dc5fc.camel@intel.com>
         <4930999a-888f-88bc-a05c-86762504f059@intel.com>
         <c8e7cff6f8d66ce4f8575caaf69f02b491ed7d90.camel@intel.com>
         <5afff147-dfb4-9033-6826-5965ba0bf3a0@intel.com>
         <061580727e503d092ca3867919fa0f26391568eb.camel@intel.com>
         <10c4b928a37fdf96df767fc7b8f1348f6af05984.camel@intel.com>
         <Y1WmZgqIkl8GkR/i@kernel.org>
         <e8f1e391-0362-33b7-aaf6-45a685eba0a4@intel.com>
         <Y2BsSCM1BWlsqPcK@kernel.org>
         <65924f603f88462eae6edd5ecb9f56aec1be1864.camel@intel.com>
         <Y2U9JJUBFiscIidn@google.com>
         <076291f2-4bff-e1ac-e590-74b94b5c03ef@intel.com>
In-Reply-To: <076291f2-4bff-e1ac-e590-74b94b5c03ef@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB6050:EE_
x-ms-office365-filtering-correlation-id: 8f25ad24-07ec-454d-7e67-08dac09de209
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9mWmygPY0hV7d0sanH4HLftqh0RjW8ycDcMABIJ4gtt8B+aWQyjQj6Dwb8bP2GG8nWbHffj37r+RiAcWWc/GOr9Wyb84P3FdE+CzN78Hz2qxSgVsqsN9khf1vy2HOWLjtvIG58KliYW35cflDg1x2ew2oQ8dKo2Oty+EmLwhb/cLdXKb42N39JU4Sar+sqG+/5UAVkkuDDv7cIyInfEyI2SRwUBuGmcepSrmDLdxyqi6wTXnDuLYwd1Hr+0kOQ4LFFZnHfIIwk2GbH02z0MrMpHSSDK8+2OEIE0DjvExB8v7qTjsly7hayRpbRLWOpSOtnBArq5U3Wms6d0la42UZdL8wNnlI/pxgAkHU5ccQezMlVOHRv7n2lOCV/aaq+hZiWRxI1y5T5U3bg2QSs77ViD1Eefyq0VrSOQ6CzRDsrZ4x4MFNpHXUsqLYlOMjWHM/8onY0FjzbJ5A0HwSGDUByO4DL/iGvQnPDKW8xA2AHrhmcsPSdRFjfaLsnI8HkjRubi22fPX0qcoIW7xowT9DQtH8pHtVOUIYvvKnFi/36tkyjHEnqI2YXt2VY8rNuJKTXJv4m5tpKte4XvL03qmxl7uNnHeh/WFvWyDaJuBrV78SlOaycUzZNZF6cwH8o3rjv+y24KB62BY+Hsu0k1JdvC6hGqJgSZlqGkRsbFqA5yWtALYHYjZQBZebyRPyhjtcaCjMBFERyIGCfNr8hwGvcN5v79o3gAFJ0xGFM2HZZDEcq5vBD9CW4o+SXGolaFKcIIowMZIdIHUj0w3M1VsmA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(366004)(39860400002)(396003)(451199015)(478600001)(53546011)(82960400001)(186003)(6512007)(4326008)(38070700005)(86362001)(38100700002)(2906002)(122000001)(4744005)(64756008)(8936002)(41300700001)(5660300002)(6486002)(66946007)(26005)(54906003)(2616005)(76116006)(91956017)(316002)(66556008)(66476007)(71200400001)(66446008)(8676002)(110136005)(6506007)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c1I1RmptamdIL2VXOUJURExmNzNiSGVJc01iaElySkRLRWpsZFFySnNJUncz?=
 =?utf-8?B?VjlscnRUb1hjUFdwYnBJKzFJeTBXSThrVmhta3BjZE9VUDJIQS9HUGtlM3pD?=
 =?utf-8?B?cUNmQXRZUW45WVdrU3dETi9zRm9Vbk1LZjJURmVXcExOSEpUVEM2NjJqWml4?=
 =?utf-8?B?RWRjTkJtTkw2b0UrOEpTdHBlNnlMM0NtTUdVMnhoMEhCWUhtdW9xOUM2QUVT?=
 =?utf-8?B?NWFObXY2bXNQL3VWRXJpOWxhdkJuVUMvbjVPdEc4em9Ba08vYUdENXYxRC9l?=
 =?utf-8?B?eDBBUDZJMTZONitLbEkrdENxSmhqbVplZmtYMEpHZ0tnSXh1ZkNzZXJVZFZH?=
 =?utf-8?B?SmZNNDI0ZWFpWng5STV6TDA4eHhsN3l1QXhNUTlLa1pTekUxN3FEeFgzcTBY?=
 =?utf-8?B?ZHhMbGdJbktGK2FrL2VGb0MrQ0F2UjFuQlI5cXUvNjhHdys4SW1yclJQRFcx?=
 =?utf-8?B?OVN4TWozREJVb2htWFpOUW9WMnFMN2VWRThuVkpSbmpWMFhnbDhHM2JZVk14?=
 =?utf-8?B?U3IxcXRUL09yQjJEVkNPVlJzYUN0M1lKcHBPZXIramJRcHhlZk5Obnp2bUV1?=
 =?utf-8?B?N04wRmJHbFZSbncxcTBLdEFEWkw1ZHpoeG9xL0xxRjljTVlON2ZUNTBxOXB4?=
 =?utf-8?B?NDROaUs3ZFQ5K1I2KzdTcWFQRUJydXAvQS9KV0dISFhqb0FHTE9IZTRodWpL?=
 =?utf-8?B?UkJsbkhjaW1FcEs1WFNpVjBiZFZqSHpEYUVrb0Rjd2ErcG5jdGV6U09HLzFK?=
 =?utf-8?B?clc5ZHZKRElyZ292Nzc0d2pEMG5WQjFPdUdjRFB1RzJOK3VKZENyYW5reFpM?=
 =?utf-8?B?UTJxZ3J1OXAxbTZHSndtOUd5QmF4T2hvbzdtRTF6MitUS05HUzloZEZjaFhL?=
 =?utf-8?B?Ylg5eGpSM1Z6b3czeUVSSjhCbkRYOXdPS0pIMmN3dlZRWnpHTUhHOVJVaTVQ?=
 =?utf-8?B?MHV3bTRTYVA3TkMzSGpTaThEMlgydXE1MlpXUU56RHVvQTVjdm91VXhKaU5S?=
 =?utf-8?B?Qmt6U2s3L1BDVEQ5WWFSYXZINE1GajRHZS9CMWtBaVhxK3hxc0tvUkRMczV2?=
 =?utf-8?B?dXFYRWNXTEJOQ0xMSjdkVDBzWTJYTjB5MU9aZXluU0FEVEN0UTAwQS9mT1JD?=
 =?utf-8?B?ZmgrcXEvV0VNMWd6a0M2Y1QrcmZFVHlPRlc2Uk5XVkhoV2VSRlBRRi9XaFly?=
 =?utf-8?B?TGlJRHRyUUNNOFhHRzdGRFdQTkdRZXJuM2NMeVUvaHJUM3UwZHFkcWNDNWJo?=
 =?utf-8?B?MjJuNG02V0x1czRwUFo0NTF0dSt4NFlyenpjUGYyZjRtdnBEa3ZEZ3MvRlRW?=
 =?utf-8?B?WGJCRlArQUNBQjJnY2F1UFhUMHR0OTlyYW1OaytGeXB5RkE2ZE1PVWl4WjlU?=
 =?utf-8?B?ZEtud2t1MzRzWE5ZM3hMalJuTWxMSlF4ZUJzZnF1Tk9nWHdVYkxMazlnTWU4?=
 =?utf-8?B?em0yemJEY3U5cWJMS0g1VklMdFVzM3Nsa3k0QXh2aDk2MUhJK2ZNY3h3SHc4?=
 =?utf-8?B?bG5PN1kvYUh5K1kyWXM2UlhrdUxCdDNmRTI4S3NkcENMZXM1dXBVc2Vabm4z?=
 =?utf-8?B?MW9TVWtVNlUrMWcyQmViaUlLSExCdCsvamZUSXdOc1NXSllaVXo4ckNZbVJC?=
 =?utf-8?B?TUhtcENHV2VNWncwMnhhdTQxWDFHS0wrQ0VEcmhGS00rSUV3OWxMTFd1cXhV?=
 =?utf-8?B?Y1RseGNGQUhUZFNTTWZ5UFRjZy9sUFlWNkdxNkgrOWx1TXlvU241SVdEREFt?=
 =?utf-8?B?eC9PN3JnSHhmMWRkYmplN0pVUjExTzFBUTFzOGs1N0k5dGNEN2NQeFI5VUtH?=
 =?utf-8?B?V3RnN1N4WnhWM3pldkZ3Tm1lMkNqSEhaOUROdGg3Ym81cE11RVhkQ2J6S3A1?=
 =?utf-8?B?WXVhclVEYTg4YlM2SjJPeVYrYU85SUpkSVMvQmpkMzN1aHlTZlFURko5ODZl?=
 =?utf-8?B?NE93OWIwU3NLUXhZMnJZdnpLSEFuc2ZSR3Fqa3Q4UDlkcDFyVEVNOC9PYnVY?=
 =?utf-8?B?VVpUWlBFRFNqNjZJSG5iM0JiaEU2c2xSbUQwdmErVDU5cmlIZXNlTE1kbXF3?=
 =?utf-8?B?N3F0aVZBdU9MK3hJOVNyNU9OUkx2bXFDTHA3WEViVDlxT252ZndoVjQrcUoz?=
 =?utf-8?B?K2lXZURjeFp2b0dmSnJqemF0OUpNM2RyNWV6YURMdXJoK0tOaDgrYmZXQ2Nj?=
 =?utf-8?B?ZGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <05F64C749356094787C398CD8F808F5F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f25ad24-07ec-454d-7e67-08dac09de209
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2022 08:55:56.0393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K6F+lHMETIhWZqFQU3U0lSWeO7WZRywyCvdt9c70ClbI52xjyqpARvsRROQVG5C1SUkyZvh4A7Z3T3j9pUmzhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6050
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gRnJpLCAyMDIyLTExLTA0IGF0IDA5OjM0IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvNC8yMiAwOToyNiwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gPiA+IEkndmUg
YmVlbiByZS10aGlua2luZyBhYm91dCB0aGlzICNNQyBoYW5kbGUgb24gdmlydHVhbCBFUEMgYnkg
c3RlcHBpbmcgYmFjayB0bw0KPiA+ID4gdGhlIGJlZ2lubmluZywgYW5kIEkgdGhpbmsgd2UgaGF2
ZSBtb3JlIHByb2JsZW1zIHRoYW4gdGhpcyAid2hldGhlciBrZXJuZWwNCj4gPiA+IHNob3VsZCBl
bmZvcmNlIGNoaWxkIGNhbm5vdCBtbWFwKCkgdmlydHVhbCBFUEMiLg0KPiA+IElNTywgdmlydHVh
bCBFUEMgc2hvdWxkIGJlIHJlc3RyaWN0ZWQgdG8gYSBzaW5nbGUgbW1fc3RydWN0LCB3aGljaCBp
cyB3aGF0IHdhcw0KPiA+IG9yaWdpbmFsbHkgcHJvcG9zZWQgbWFueSB5ZWFycyBhZ29bKl0uICBJ
IHNob3VsZCBoYXZlIHB1c2hlZCBiYWNrIGhhcmRlciwgYnV0IGJ5DQo+ID4gdGhhdCBwb2ludCBJ
IGhhZCBtb3N0bHkgc3RvcHBlZCBjYXJpbmcgYWJvdXQgU0dYLg0KPiANCj4gQ29uc2lkZXJpbmcg
dGhhdCB3ZSBoYXZlIFZNX0RPTlRDT1BZIHNldCBvbiB0aGUgdmVwYyBWTUEsIHRoaXMgc2hvdWxk
bid0DQo+IGJlIHRvbyBoYXJkIHRvIHB1bGwgb2ZmLiAgV2UgY291bGQganVzdCByZXR1cm4gLUVC
VVNZIGlmIGFub3RoZXIgbW0NCj4gY29tZXMgYXJvdW5kIGFuZCB0cmllcyB0byBtbWFwKCkgdGhl
IGZkLg0KDQpZZXMuICBXZSBjYW4gcmVjb3JkIHRoZSBNTSB3aGljaCBvcGVucyAvZGV2L3NneF92
ZXBjIGFuZCByZWplY3QgbW1hcCgpIGZyb20NCm90aGVyIE1Ncy4NCg==
