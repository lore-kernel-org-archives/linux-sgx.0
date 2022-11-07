Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79244C433FE
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Nov 2022 08:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbiKGIyT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 7 Nov 2022 03:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiKGIyR (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 7 Nov 2022 03:54:17 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A7B1261F
        for <linux-sgx@vger.kernel.org>; Mon,  7 Nov 2022 00:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667811256; x=1699347256;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LUusxygwItupPcks8hf4JKMXxwymihUhpsS0cyhJjds=;
  b=hD1Co/m0PxW08P6uo1HNv22D8ztCSBboYdKireK051DmcVCPtZvlmeAw
   lErUyJsdDsvVLsF1BV5euJb/r4cSoBheQRVFWHQ+714wCXTS9/oh0VhcI
   hZFA73dkEiOZUXi2ti3JBqB/JI111c1/+MckP6FQjhPMyfFjb3eQMGnWX
   dNNojxBlBWN/sm+4oXE2F+Rvmt0rmlhI20FfdzqHP1A4w9Wmc3eGwLmIp
   2po5ywqdp1LxdAPcZ20BySLNQvohAWrd5xoW+YKk6WbxkxiQWRBRSXoZb
   PsNShzW/0P1iZIqegZxXrwhILXiJX496cBZiUCtZvA8jj3eRXSxR1it3k
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="396660508"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="396660508"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 00:54:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="965074602"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="965074602"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 07 Nov 2022 00:54:16 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 00:54:15 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 7 Nov 2022 00:54:15 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 7 Nov 2022 00:54:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WG4HH9NXkdikso8FnxrYDrAGOzBBd+uTRxSczqlwdx2v+36sMNDBIB5WIFkyp1hUEacLT+7OJhJ07Pvnk8a1Ddue2rQSch2m1edOfvP8LWVzTRVkg9w+kH4hEf23qQEn/Vbp+lfrRZXMmdVCYTatLxtkld90UGZs8STXtveet80FJK14w6C1tbFFwFHaq514UHm4pjjnFR2R1JGYxWFUfdaxmZS5jJKI6VT46doQPJaWdDiRILBXO3in+wBTp4ForQ8Pf9FQB1ktwKdsE0FGL92HGZNuxcPNvah8eP5sAwYNZclZlrIIF66Kj8zJaxj0H4921KV+iDBGr9oGNVdW+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LUusxygwItupPcks8hf4JKMXxwymihUhpsS0cyhJjds=;
 b=JIKFNSXBwdmW99OegGZFiEO+CrjVzVjUWcXEYLdwWX6WQY3gUMYPdTCjJXn1nuDk9S46/uBqq85j7P/iOwqwuHmGlDMO+/U0/aDax5iWkaig5uvMwdGB9PbJ2Omb3+suM1LU64nyn5G7A0wNv8rSao58rDvzRE0Vhd6a7PvQ0sxg0XvNzGc1+s1JOmg2zeo+61gxhh6fUXFXBN3NCXwNt27bfVA1L32Dw49vTYNaHkuOXYSrGezF2ZbDe6Vb6Sn2k6wqnCgiaMkxEya+1GQGTFOx3FB5vfEl6wYPqKpk/rW1xWp6hPe+p4MmUg2V1BzzzAWD2Y4S5/Z4wOJ6IbUS3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB6050.namprd11.prod.outlook.com (2603:10b6:208:392::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Mon, 7 Nov
 2022 08:54:12 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 08:54:12 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
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
Thread-Index: AQHYzLsOovV5qYztIkquos7ZMS9Qjq4JWziAgAD86YCAAJ5RgIABk7IAgAARzYCAAGXuAIAAA7UAgAADhICAAAPHAIAAFAEAgAAE0QCAAAYhAIAIjmSAgAbrTACAAFHqgIAMhb0AgAVWwACAAGbvAIAEOLOA
Date:   Mon, 7 Nov 2022 08:54:12 +0000
Message-ID: <5dafd48f57972e37bf74ee693f311245756077e8.camel@intel.com>
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
In-Reply-To: <Y2U9JJUBFiscIidn@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB6050:EE_
x-ms-office365-filtering-correlation-id: efb31646-c514-451c-63e5-08dac09da441
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sBv4xUoAnsxGdDWfDx5e2nNmfzaTLxEXVXP9M2fUmA38zLJJZX0mZV+EnHw1PBrqtCilZ3Oi9GySVIItons/CF7fbyAB7kSJmRQld9tb1QZC1xk+7xvhNZh+7YmmeM/p7Wb/zWEEShhmLDTkcTc6SHeXESCYRJoFn/rzP2RkDbJwb/QkZnidaNoX4mnq37SddMCakZjqtiRFG6/pxO/3/iFTJdvkDJIDk58a+ujvLgVH59CM2FRmGlgQBTQHTmMuzltwwX5N0dX65ACMLoTiSOXCud7IJUVL2Te9TqFEhSlsLTA5gxpLem6DSUP/ko5u02IKhwoAaCJZxfvDQ1BvqqEEMPxAcKMnOvSFByLqIYVW6ks45ZyvIRUUf030FnMKfpYn9aswGiIv6XUBZ5dGTY5Poy6kLmlFs3CK8ZaDvLEXyo0m9h6XGXEWuZMgLlDO9vc+j+rS8YYhB/4wpZfhA826HzP/INeX+1EpkESb85MnvgHD6WnzivkOVOIHZSYUA70Yti3gii2VG4kVF0x8GE+dGGh+3wtM7/AA2tFDmkR2DFDJc/4V2STR1GHLINnSNSKLqojr7BlhptwXdkg1xJiL5EEQhDpcb8SJ/SB+ivzwppMUbdYM5x1b9FboUUodNTpm98+gf3OW1j8gdZObyy2WBTKGJjDR9K4VWs8Ni+f1UE9ruSE7xuHPckXtCLTmUJ+y+kYv8c9CZlTxl/GTA4m8Abc04aQRfcqWwKRZz8dZT6juBgXYQsijd+GjPTA2qAZh3xEzumojEdXHk69SOSxZk+qXgWARfO/HYWN5SDY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(366004)(39860400002)(396003)(451199015)(478600001)(82960400001)(186003)(6512007)(4326008)(38070700005)(86362001)(83380400001)(38100700002)(2906002)(122000001)(64756008)(8936002)(41300700001)(966005)(5660300002)(6486002)(66946007)(26005)(54906003)(2616005)(76116006)(6916009)(91956017)(316002)(66556008)(66476007)(71200400001)(66446008)(8676002)(6506007)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ajJZMld2MjFmWHFnMnZxUllWaVlXYmZEUUpHc21Xc2Q3bU8va0VCUld3Z01T?=
 =?utf-8?B?ZHptZzdyR2lvUkR1WCtTRkxRMVdiUGFhWUZ4cFhMaHlnYXNzN2hFQW1jMjRi?=
 =?utf-8?B?NXJoNittbTE2WHN6N0lUMjh1WjlvZEpIQ1o5bUpmVVYzMjhlbUUyVHh5NnlD?=
 =?utf-8?B?VEJUSGs3eDFYREduSjZGRXp5dWFEaVRUUlJTaE9wRUVhWHlrMTUwVlo5ejJC?=
 =?utf-8?B?cCtQejVQV09PZ0NmRGVuTWltZlRhdFBjWkdYaXZFNmM3V1BzaFNxcmxGMDl2?=
 =?utf-8?B?WTM0eVN5bFJNRkI0SDhPT1pxRWpSUU9CaDJXdU1DbmNwcE5tbXZ5SVJXNEZM?=
 =?utf-8?B?KzNqbTl1RUFnVlppT2xoZ2FlOC9hUEkrVmJzMERZMXQzVnZBT29vTEd6MDl6?=
 =?utf-8?B?NDNHdHFjSHIxc2Y2ZDJiUXpYTHA0OTUvK2lWVUUzMFJYK3lsdFpEY2F6b0R3?=
 =?utf-8?B?SUFMdm53YWVqQzhzczAzR2ZwdDhXNWZ3TTA3NVJFdVZHMDR3bzQvV2NlT2FH?=
 =?utf-8?B?RjFJMWN3TkRFcFZ4WlhUL1RPNUpxWjNKQjNJL2pRdFhlcGUrTnF4bzdabklL?=
 =?utf-8?B?K3dGalF0bmNscTAzam9ka2x6NzdYTWJyL1hsYkpSdXNZWm9SLytUbmhMSjJO?=
 =?utf-8?B?bEFGR05taVdGYXhQaDZNUjJ4T0w4Y0NXU1hGcWdZeSs1aDZ3aFQ0SjlZZ1Nn?=
 =?utf-8?B?TEF5NTd2K05XallyU2M4V2ZTc1ZuVm1vdVdmTmx1WENtZjE4am9NL2ZHcjVj?=
 =?utf-8?B?RWdkYzU5V2djOUtUS0JqWEpIY0daaHIvNEFSQm0wR1AyS0UrSklaMGMyeXo1?=
 =?utf-8?B?M3h2SFAyejdvaXB0ZzUrTndHa3VCV3k4U3FtNStwR3RYZWJQbXhLQnJObkRo?=
 =?utf-8?B?S3A1NzBMZE1BaWF4bkJ2OHRIbG5CVVVyamJ5cWNKTGUvTi9oSUJnM1lhM1Aw?=
 =?utf-8?B?OU1BeEhZYmFQek5wNk9uOXJxMURWWDNsVzhhbW5iUW5aTW5hVWZYRDN6Und5?=
 =?utf-8?B?elVtODNNNlFsZVdVUzFGZHpMZ3FoZ2NEZ1JlZjRXaDRCT2pjcXhITFhrYzh2?=
 =?utf-8?B?emU0MGhrZ3NpTXlORVdCUzh6eGFXb1ZFRE1wOCtrU0s5Q2ZQL0liZ3ZRdTI3?=
 =?utf-8?B?Um44dms3WW9IenNXU3I0R2RTVWVvVEZESVBma3lTTktZVURIMGw0Q1lKeWRQ?=
 =?utf-8?B?aEtDS05aV0hnRGsxbVYxcjRMSGw1RStUZnFoT3drdCtvYkNVeGZlcGV4QTZ2?=
 =?utf-8?B?ZDh3WTNXMldMb0dpQWZIcjJXK3dpOVVNSDJUV0dhdzlNM2E2cEpIbHFGajVY?=
 =?utf-8?B?bUtjd01FdkI0Tis4blA4dEE5S2lSNDNmZWJQendnSGI2WWxsUGxDQ2lUWk1a?=
 =?utf-8?B?Qnl5WGh6NG4zQjBqeUpPV0ROanhkcFoxQnpDc21CS2l0a3hQWlhJY2RkMkFp?=
 =?utf-8?B?V3pXR2pWTW9vTzJETVRTaU5sRXE3eEJBVXRXcFpNKzV3b2YrczdXMzhpNmlV?=
 =?utf-8?B?bEo5SXZyTU9aODljS01aZ0JIMFlEZUYvc1pMTXJVTkZoZGVHa1JjeUFybURr?=
 =?utf-8?B?cE52UC9SK0liMjRtRVlxaHNtNkJyaGE4MU8xUjFlVEJLa0pjc014NFJyUVZz?=
 =?utf-8?B?cEg3RWhJQkxNZWFnN2N5UmZ0OHdFVzN2cDBPVUo1M09qZ1EzWmhzTFphWFU5?=
 =?utf-8?B?ak5TVU9aV2JqUVlXb01NL29hamJ1VGdMaFVrbW4vUnZSMUg1WHdueWZZQXRU?=
 =?utf-8?B?T0x5U1pZZS9QY1k0RTFlOGlvdWdRRjBaalVkdUk1ZmdublJGOXlEbUk0R2pQ?=
 =?utf-8?B?U1NxamJabDJSVHRTNk9CYWJYR282S2FOT0xoejlYWFVkeEJnL0ZtMHIwQ2Jt?=
 =?utf-8?B?VUVBa0VEVXFOSFlvdStvSXdKQVZVTjEvR1RlZVNrd1NtMUFoRktMdktoSVdN?=
 =?utf-8?B?MjFIZ3dhRlNMeVRBQlVyYzFoYWlPU3lyRVVlWG5JZmpPeGsvUGFWSTBsaks2?=
 =?utf-8?B?ZVNOWTR2a3NmdmpGRTJlYktyeFk1NmxEZHQvejdiZzVGRUMwZUE0bEhydHRQ?=
 =?utf-8?B?Y3NNVmdicG5tYnlOL01BdUVsNE9yK3NZNXhtdnJLSVEyR1hJS05oOFNuN2Vk?=
 =?utf-8?B?cDd1eWJhbWRaM2pBRmF2cjhGU3YzenNFdStlUHFTOWxGdUhTRllJVWtOMVJY?=
 =?utf-8?B?cmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <072337E450C01D44BA15160F709A2EA9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efb31646-c514-451c-63e5-08dac09da441
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2022 08:54:12.4337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vD9PSKT+6htTRVi+BEfMuTcr17cQ5aIIKjuV09ZMz7BGKj+tu4ZeWH7jk8lyjZHnQ/UcVIrbbBIk46yA3qVCUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6050
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gRnJpLCAyMDIyLTExLTA0IGF0IDE2OjI2ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBGcmksIE5vdiAwNCwgMjAyMiwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+ID4g
SW4gZmFjdCwgdG8gc2hhcmUgYSB2aXJ0dWFsIEVQQyBpbnN0YW5jZSBpbiB1c2Vyc3BhY2UgZG9l
c24ndCBtYWtlIGFueQ0KPiA+ID4gPiBzZW5zZS4gIEV2ZW4gdGhvdWdoIGl0IGNhbiBiZSBzaGFy
ZWQgYnkgY2hpbGQsIHRoZSB2aXJ0dWFsIEVQQyBwYWdlDQo+ID4gPiA+IGNhbm5vdCBiZSB1c2Vk
IGJ5IGNoaWxkIGNvcnJlY3RseS4NCj4gPiA+IA0KPiA+ID4gT0ssIG1ha2VzIHNlbnNlLCB0aGFu
a3MgZm9yIHRoZSBleHBsYW5hdGlvbiENCj4gPiA+IA0KPiA+ID4gV2h5IHdvdWxkIHdlIHdhbnQg
dG8gZW5mb3JjZSBmb3IgdXNlciBzcGFjZSBub3QgdG8gZG8gdGhpcywgZXZlbg0KPiA+ID4gaWYg
aXQgZG9lcyBjYXVzZSBtYWxmdW5jdGlvbmluZyBwcm9ncmFtPw0KPiA+ID4gDQo+ID4gPiBCUiwg
SmFya2tvDQo+ID4gDQo+ID4gSGkgSmFya2tvLCBEYXZlLA0KPiA+IA0KPiA+IEkndmUgYmVlbiBy
ZS10aGlua2luZyBhYm91dCB0aGlzICNNQyBoYW5kbGUgb24gdmlydHVhbCBFUEMgYnkgc3RlcHBp
bmcgYmFjayB0bw0KPiA+IHRoZSBiZWdpbm5pbmcsIGFuZCBJIHRoaW5rIHdlIGhhdmUgbW9yZSBw
cm9ibGVtcyB0aGFuIHRoaXMgIndoZXRoZXIga2VybmVsDQo+ID4gc2hvdWxkIGVuZm9yY2UgY2hp
bGQgY2Fubm90IG1tYXAoKSB2aXJ0dWFsIEVQQyIuDQo+IA0KPiBJTU8sIHZpcnR1YWwgRVBDIHNo
b3VsZCBiZSByZXN0cmljdGVkIHRvIGEgc2luZ2xlIG1tX3N0cnVjdCwgd2hpY2ggaXMgd2hhdCB3
YXMNCj4gb3JpZ2luYWxseSBwcm9wb3NlZCBtYW55IHllYXJzIGFnb1sqXS4gIEkgc2hvdWxkIGhh
dmUgcHVzaGVkIGJhY2sgaGFyZGVyLCBidXQgYnkNCj4gdGhhdCBwb2ludCBJIGhhZCBtb3N0bHkg
c3RvcHBlZCBjYXJpbmcgYWJvdXQgU0dYLg0KPiANCj4gVGhlcmUgaXMgbm8gdXNlIGNhc2UgZm9y
IHNoYXJpbmcgYSB2aXJ0dWFsIEVQQywgYW5kIGNvbmNlcHR1YWxseSBpdCBqdXN0IGRvZXNuJ3QN
Cj4gbWFrZSBzZW5zZSBiZWNhdXNlIGFsbCB1c2Ugd291bGQgbmVlZCB0byBiZSBtdXR1YWxseSBl
eGNsdXNpdmUgb24gYSBwZXItcGFnZSBiYXNpcw0KPiB0byBrZWVwIHRoZSBFUENNIGhhcHB5Lg0K
PiANCj4gWypdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS9hY2U5ZDRjYjEwMzE4MzcwZjYx
NDVhYWNlZDBjZmE3M2RkYTM2NDc3LjE2MDk4OTA1MzYuZ2l0LmthaS5odWFuZ0BpbnRlbC5jb20N
Cg0KVGhhbmtzIGZvciB5b3VyIHRpbWUuICBZZXMgSSBhZ3JlZS4NCg0KQWxzbywgSU1ITyB3ZSBj
YW4gZnVydGhlciBlbmZvcmNlIHRvIG9ubHkgYWxsb3cgYXNzb2NpYXRpbmcgb25lIFZNQSB3aXRo
IG9uZQ0KdmlydHVhbCBFUEMgaW5zdGFuY2UuICBJdCBhbHNvIGRvZXNuJ3QgbWFrZSBzZW5zZSB0
byBoYXZlIG11bHRpLW1hcHBpbmdzIChWTUFzKQ0KdG8gdGhlIHNhbWUgdmlydHVhbCBFUEMgcGFn
ZXMgZXZlbiBmb3Igb25lIG1tX3N0cnVjdCwgcmlnaHQ/IMKgDQoNClRoaXMgYWxzbyBtYWtlcyB6
YXBwaW5nIFBURSBlYXNpZXIgKGFzIG1lbnRpb25lZCBiZWxvdykuDQoNCj4gDQo+ID4gRmlyc3Qg
b2YgYWxsLCBpZiB3ZSB3YW50IHRvIHVzZSBlcGMtPm93bmVyIHRvIGNhcnJ5IHRoZSB1c2Vyc3Bh
Y2UgdmlydHVhbA0KPiA+IGFkZHJlc3MsICJtYWtlIGtlcm5lbCBlbmZvcmNlIGNoaWxkIGNhbm5v
dCBtbWFwKCkgdmlydHVhbCBFUEMiIGFsb25lIGlzbid0IGdvb2QNCj4gPiBlbm91Z2ggLS0gbm90
aGluZyBwcmV2ZW50cyB1c2Vyc3BhY2UgdG8gY2FsbCBtbWFwKCkgc2V2ZXJhbCB0aW1lcyB0byBt
YXAgdGhlDQo+ID4gc2FtZSB2aXJ0dWFsIEVQQyBwYWdlcy4gIFNvIGFkZGl0aW9uYWxseSwgd2Ug
YWxzbyBuZWVkIHRvICJtYWtlIGtlcm5lbCBlbmZvcmNlDQo+ID4gb25lIHZpcnR1YWwgRVBDIGNh
biBvbmx5IGJlIG1tYXAoKS1lZCBvbmNlIi4NCj4gPiANCj4gPiBTZWNvbmRseSwgSSBhbSB0aGlu
a2luZyB0aGF0IHRoZSBjdXJyZW50IGFyY2hfbWVtb3J5X2ZhaWx1cmUoKSBjYW5ub3QgcmVhbGx5
DQo+ID4gaGFuZGxlICNNQyBmb3IgdmlydHVhbCBFUEMgcGFnZSBjb3JyZWN0bHkuICBUaGUgcHJv
YmxlbSBpcywgZXZlbiB3ZSBtYXJrIHRoZQ0KPiA+IHBhZ2UgYXMgcG9pc29uZWQsIGFuZCBzZW5k
IHNpZ25hbCB0byB1c2Vyc3BhY2UgdG8gaW5qZWN0ICNNQyB0byBndWVzdCB0byBoYW5kbGUsDQo+
ID4gdGhlIHBvaXNvbmVkIHZpcnR1YWwgRVBDIHBhZ2UgaXMgbmV2ZXIgdW5tYXBwZWQgZnJvbSB0
aGUgZ3Vlc3QgYW5kIHRoZW4gZnJlZWQuDQo+ID4gDQo+ID4gVGhpcyBtZWFucyBhIG1hbGljaW91
cyBndWVzdCBjYW4gYWx3YXlzIHRyeSB0byB1c2UgdGhlIHBvaXNvbmVkIEVQQyBwYWdlIGFnYWlu
DQo+ID4gYWZ0ZXIgaXQgcmVjZWl2ZXMgI01DIG9uIHNvbWUgRVBDIHBhZ2UuICBJIGFtIG5vdCBl
bnRpcmVseSBzdXJlIHdoYXQga2luZA0KPiA+IGJlaGF2aW91ci9hdHRhY2sgY2FuIGJlIGRvbmUg
aW4gc3VjaCBjYXNlLCBidXQgaXQgc2VlbXMgdGhlIHJpZ2h0IGJlaGF2aW91cg0KPiA+IHNob3Vs
ZCBiZSB0aGUgS1ZNIHRvIGluamVjdCB0aGUgI01DIGFuZCB1bm1hcCB0aGUgcG9pc29uZWQgRVBD
IHBhZ2UgZnJvbSBndWVzdC4NCj4gPiBBbmQgaWYgZ3Vlc3QgZXZlciB0cmllcyB0byB1c2UgdGhp
cyAiZ3Vlc3QncyBFUEMgcGFnZSIgKEdGTikgYWdhaW4sIEtWTSBzaG91bGQNCj4gPiBraWxsIHRo
ZSBndWVzdC4NCj4gDQo+IEp1c3QgemFwIHRoZSBQVEVzIGZvciB0aGUgYWZmZWN0ZWQgbW1fc3Ry
dWN0LCBtbXVfbm90aWZpZXIgPT4gS1ZNIHdpbGwgZG8gdGhlIHJlc3QuDQoNClphcHBpbmcgUFRF
cyBhbG9uZSBjYW4sIGkuZS4gdGFrZSB0aGUgcG9pc29uZWQgdmlydHVhbCBFUEMgcGFnZSBhd2F5
IGZyb20gdGhlDQpndWVzdCBhbmQgbWFwIGEgbmV3IG9uZSwgYnV0IGl0IGRvZXNuJ3QgaW5qZWN0
ICNNQyB0byB0aGUgZ3Vlc3QuICBXL28gaW5qZWN0aW5nDQojTUMsIHRoZSBndWVzdCB3aWxsIGp1
c3Qgc2VlIHN1ZGRlbiBsb3NlIG9mIGVuY2xhdmUgd2hpY2ggY29uc3VtZXMgdGhhdCBFUEMgcGFn
ZQ0KKGVuY2xhdmUgaXMgbWFya2VkIGFzIGJhZCBieSBoYXJkd2FyZSBpZiBhbnkgcGFnZSBjYXVz
ZWQgI01DKS4NCg0KQnV0IEkgZ3Vlc3MgaXQncyBhbHNvIGFjY2VwdGFibGUgc2luY2Ugd2UgYWxy
ZWFkeSBoYXZlIG90aGVyIGNhc2VzIHRoYXQgZ3Vlc3QNCmNhbiBwb3NzaWJseSBzZWUgc3VkZGVu
IGxvc2Ugb2YgZW5jbGF2ZSAoaS5lLiBsaXZlIG1pZ3JhdGlvbik/DQoNCkJ0dywgY3VycmVudGx5
IHRoZSB2aXJ0dWFsIEVQQyBkcml2ZXIgZG9lc24ndCBoYXZlIGluZnJhc3RydWN0dXJlIHRvIHph
cCBQVEVzLiANCklmIHdlIGNhbiBhc3NvY2lhdGUgb25lIHZpcnR1YWwgRVBDIGluc3RhbmNlIHRv
IG9uZSBWTUEsIHRoZW4gemFwcGluZyBQVEUgY2FuIGJlDQplYXNpbHkgZG9uZSBieSBib29ra2Vl
cGluZyB0aGlzIFZNQS4NCg0KRG9lcyB0aGlzIGxvb2sgZ29vZD8NCg0K
