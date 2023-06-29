Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 634B2EB64D9
	for <linux-sgx@archiver.kernel.org>; Thu, 29 Jun 2023 23:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjF2XaN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 29 Jun 2023 19:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbjF2XaL (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 29 Jun 2023 19:30:11 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933183598
        for <linux-sgx@vger.kernel.org>; Thu, 29 Jun 2023 16:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688081408; x=1719617408;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OOB4+/bqnW/NcWmN2z2ChA03bgVGRvzFo2BBJfQewjg=;
  b=TU5xod9YGf7nktmo3miOaQzuJcV2ed4NaoZ7c/psERPUpW1ZlJQHGErj
   O6SY2fZnA/uPDB/EzHoidJnbhIFHTfh7d70fgftgLaV3aUOS1Gu11VVAb
   5c8ICIpiiFN01DaHpXqUHTdZw0frx5bRKAi5r7v1vpYqsM3w/vSS+FfQv
   +MubmcrUxQkmJO09gLEm0PSL/Jhlykx0rp15qxti3ajGlklMFqmNoG2M5
   OsbMXebL5Gs6s+wi43l4t6ia7EJogncXELuarQPSVjoIyOKgVr/902UOl
   I/euqoJw7d/P15Q5kia63hd+79Fg3CMaUSbV0UOKXsyHHOJLJROQ7jkz1
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="342596821"
X-IronPort-AV: E=Sophos;i="6.01,169,1684825200"; 
   d="scan'208";a="342596821"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 16:30:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="964170259"
X-IronPort-AV: E=Sophos;i="6.01,169,1684825200"; 
   d="scan'208";a="964170259"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 29 Jun 2023 16:30:07 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 29 Jun 2023 16:30:07 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 29 Jun 2023 16:30:07 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 29 Jun 2023 16:30:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TT6Spb47R/nTqGmBrUoCm7sVOswBynBy2tgQ8XrSzwBnfI9+u11RzDzGhqERSNhWsv1lL/kaH1caGSUeSCOsGQYXrV/O0rcv+OIFtATHUvg1oqvpQeCGULWvHgVz93k9R8i++/Qtjop/yWNIdd9zRF7mAM5IkQNHn+9SLnCCMjrR9AqsTm3s1VbbEZaZr5DsC5GaJ1e1UaF13kKxvQOj1CadwTChTvJ/ICEVrTD/+ARjZ8a/Hhx+E/pRV4PDsi3KGhzDfrpqucgy5moYx9FsneWfJY7uXQRswB97n3C70SvfGVqBrsPI4OTPPNPoknG1/uXLmO5yaFdcpnV6T0zVrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OOB4+/bqnW/NcWmN2z2ChA03bgVGRvzFo2BBJfQewjg=;
 b=AeL5Rl6KF+Davvd4E/oD2J4njIrZ1M9XbF3z4HJVm2p9cmVZekm7y5gOT8wpKcGUqYuuj6BASzAKLXVCiHt0JS3Wj2CDGsdIT7okDQU50Z4FlMWAhFZcdb3o1KJH09TYq4Km0814KeuFzbdgluXquXx44//wtZ3XDt1bPBnbCl1VpSDFCctzhrtdq67u5qr/uccw4Ohgguz+Kg83I9/DRf5tT2e3xG/2YfCLEabxnyfUiCR/jAuZmjnlDz3DCTiwQmUQSjAXXJwaHBkSrU1Z/BZwIQRPqccsuWtDuaPov5xKR+MND1ab1ONJG8m2tJjJ0/Ew7W7Lx8eyZ/WhpTeWGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH0PR11MB5346.namprd11.prod.outlook.com (2603:10b6:610:b9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.19; Thu, 29 Jun
 2023 23:29:56 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Thu, 29 Jun 2023
 23:29:55 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Topic: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Index: AQHZMtTIU78a0A3o9UaUPrwPUmNX5q7OTQIAgACfroCAABrOAIAADTuAgAAPNoCAAFobgIAAUaaAgABy3wCAA5ciAIAACKGAgAY6gQCAADnpAIAV3bGAgAGoFwCAALMwAIB7cDIAgA/0eQCAD7ESgIABMj4AgAQB+wCABWrEAIAAFpKAgAY6eYCAAN3pAIAANG0AgAE6tgCAAFmGgIAAzOeAgAC7/ICAAJiegA==
Date:   Thu, 29 Jun 2023 23:29:55 +0000
Message-ID: <50913a11353b17861c13ebb53305dd370c8b8b43.camel@intel.com>
References: <ZIzcrmU1RA7oEeQ7@google.com>
         <fc214963a01ca975d6de2991b63c93f04114c562.camel@intel.com>
         <ZJTEpH2yYtHmTRWr@google.com>
         <66f22efc5a920a805d6863dcc152c3c12e8fb6fb.camel@intel.com>
         <ZJoRHU1CHxIuDH29@google.com>
         <7e78ec8fd22ad9f8b828fa00b9811bbfcf855b2c.camel@intel.com>
         <ZJr3PthzDgugKDcO@google.com>
         <1a980d3ce2caec1cf44bf97d52fa08fbe72e741f.camel@intel.com>
         <ZJxKV1/2M+OeIXAN@google.com>
         <60f96055b73932ef3550eb562d2f42440d534e69.camel@intel.com>
         <ZJ2T6zJSnLtKMPnE@google.com>
In-Reply-To: <ZJ2T6zJSnLtKMPnE@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.3 (3.48.3-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH0PR11MB5346:EE_
x-ms-office365-filtering-correlation-id: 81fbfc4a-1d5b-465c-ce08-08db78f8bef4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BRSxa5rZWIa0+zs8cz1X0Zw2fOk/fTYspYz92cgt7HkIXgVSRWvGChnH9va6ljdCrH7VlBVF5yoMFR73tPGwJkRBc7PMC1vKfgRxRQl+A9NzBRPj1ZLC7kz2H3t0newNIpoWdacfmDt/ow//HOtl8lf59ohOJvOQsLIAYQB1xwJScxsagU8b/TTsuR/RB2HY5e3bhhiBsesqa3szzzTMdL1fR8ai1nFqex5TtiNdPZH9sWCN6LFvVrSMupb7vfBmYFj8EJ+DKILO9rIKb2lx1odV4vHiANC2Dq/Mf52HkpwnhiJmJXljE0a3kOdV0AmEznM4hgorrTQwwrEMbMv2VXe7rsOPgRq+hK7un4UjEhzjLJ48jlK6lMFgGpkQQrCRhh4tpiULONQh88TZEUPDsWHzuDswMGSie/+iyZZP0OX9WGKf0p101/HUDfmNc/M4ZtdhtxRlOZ5NRHYk9Podcj9mGB296zEtHY17Z9np5F3GjvU8tfo8lutNnINZijJMxMuvWekghyooklr0bfEXIJdjs1TXLhc8gKNa9To6tVFyQO8foBxOFoImRbF7EJxgtW6LyV/XNgHPO3dEOn8RxYGZWKL8nHFh+Xbo+FxRAEr5gBBv2q2AR6+44KoosVqu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(346002)(366004)(136003)(39860400002)(451199021)(86362001)(54906003)(71200400001)(8936002)(8676002)(5660300002)(26005)(6506007)(6486002)(478600001)(66946007)(66556008)(66476007)(66446008)(64756008)(6916009)(4326008)(6512007)(41300700001)(76116006)(316002)(91956017)(186003)(38070700005)(2616005)(2906002)(83380400001)(36756003)(82960400001)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a1BORWZWZzFQbE5qaVB3c0RmaE41cm1oSllyQ2VKL2VTL0d6cU9DTHZraWlP?=
 =?utf-8?B?SEpCcm1hTXJqUUoreC9DVzV5amJoNjV2S3B1TEpnZ2ovdkRNLzA2V040ckly?=
 =?utf-8?B?TW9KWUZTZG51anF5bFFQWEtnTzJ2UjQ4cy9ZUzh0SVJhMXMyRDRYZjVJTC80?=
 =?utf-8?B?VVdvbmhyYkk0Vms1b1AzNXNqSDRqY1F6NWJ1eVRPam4rZHJJSGN6a2dzRHpu?=
 =?utf-8?B?UFJ5bllIa244c1k3MDZxY2hDSGRtRlVFVzhCcHpBeHJWY1VONW5nWlNaVlND?=
 =?utf-8?B?RUc0ZnVQMzJ3aTZLWW1VSUM4a2tJamtjYk9ObUN5Rk52aW00VzJEa2VVaUFS?=
 =?utf-8?B?S3dGdzB3b2Z6Z2gvTzQwYnZndm9BZG5IbzdudzgxN0lyWTlON3ZtRG1KQUF4?=
 =?utf-8?B?eUpSeVZralRHMXJVTi9mVllQSjRiWmR2cjVjRWQxVTJrcll5WWhFc0dUMTQz?=
 =?utf-8?B?ekV0TERFZm5QcisrOXltbmNjYzY0cnJieUZyM0tvYVJPT0J2cUw5SVVuc0Vr?=
 =?utf-8?B?THQrRDQ3SDZiR3cwb0llZS9QeWVYYlh0M1UrdG1leHdZVitOWitwSGUyTCs1?=
 =?utf-8?B?ZnA0NVkxdFNIc0JTMGcxbm8rTU82S2VvY1hyam9pcm9vblh3S2U0QTRhaFR4?=
 =?utf-8?B?TnpLaDNiaGY2QnhCRGU5ajVudldyMWxVTGtlVG5QSVBhamlveE5qME91VWo4?=
 =?utf-8?B?SWlVN3Z2Q1Vkd04zWDFOVnk4NHZRcm9uY1Rkdmh0OFFmdzV1RlRjYUpXNDM4?=
 =?utf-8?B?VUxIOU81SjRTeFlhZUZzeDBpOHVOOE14cVRIRGRpazNCNS81VHpGR0k2cEdy?=
 =?utf-8?B?eHJvUjVpOTAraUlKMEJtQjA1dElXOFMrUHdBR0VFcCtBTUowdnR4b0hhVVZq?=
 =?utf-8?B?NklGSTRXUGpiVVZJNEZUSEtldy9VZ3p6Wm1LZkZBSG1oSWdPMmYwZEpZU0N1?=
 =?utf-8?B?MzNLSjdnUy9MdjRtTlZmOVZVeUJ3ZitESG4xczNmbU1JU0E3a2wwN1lpaDJu?=
 =?utf-8?B?bjl6VFF4aW14M2YybUQwZzZ6REljMEZNaUVwOHRubWJqL1lZbmxINnFCaTlD?=
 =?utf-8?B?c1J2eXV1R0tiQWh0amJWZnBpUHhiYTJVMTgwalVxbGp6cWZsWU5lK0FGNUk1?=
 =?utf-8?B?OVVvQmY0OUdZMThqOFJIeG55bjNEbnUwZG8rWW5laFgrOE1Wa0Y5SVdlZEpR?=
 =?utf-8?B?SlkrdHFkTzlkZ0FodXlLUjZHaEVqdlJWVTA2MFllNFp2ZHUvTUN4YktRME8r?=
 =?utf-8?B?cUp2eVdVSnhhVGwydEFHV01ZN3dhMWVQN1NKd00xV1FDRWp1OHZyQXhPNlN5?=
 =?utf-8?B?NFMyaG15M3NiamlkeE1YaXRyRDI2ZnJ4RHVHUGJaVUNzM0MrSnJtYkxROVRD?=
 =?utf-8?B?SXFsMXBkUWRPYXRPOWpobllQN0xLQ1g0eFdudm5WOVFKM29vNlcvamZPSWQr?=
 =?utf-8?B?d1pUUElmRHpUZmRRL0JqQ2pOWjJsa05KNmE3OGxVTVF3VjhYYllCK0Q2V3NP?=
 =?utf-8?B?VUlrc0RoVFQwMFFiYVpSVnhodElHcWNXbGpPRHgxaFJoS09iSzI2Tkw3dHJn?=
 =?utf-8?B?QXZyWDVpeVkyNUh4cWtpYWJScHdDY2UzZndqOFB5ZUNVSW9JTlIxcDJ5UWRI?=
 =?utf-8?B?Ni80bGVYMzNIMnlRNVJUTnMwY3ZJbFJYVFV6SDBER3hRMXpyRzVQZ0tWcndw?=
 =?utf-8?B?ckQwTkRkNG04S3hYL2NMSkM4OWY5TVZMT04wOXQ2OG0yVnBjRUNla2djemcr?=
 =?utf-8?B?a2lYeFpBT0R3bERua2VQMko2bmF4Wnl5M0JsS09rWGZ6bjJOSlNWMkN2V0VU?=
 =?utf-8?B?S1NIZmxPdU51VWkyZXZ1UlRoeC9ORTJvRWxoTTVLaVZvcUIzRER0WlFESWVF?=
 =?utf-8?B?TkJrSGdmRWU3bHJmVERlZGpIRSs0b01zWFpoYkdLUnJCRkp5ZFBNNDd4RmFX?=
 =?utf-8?B?OGlwV0tkMVNJOVEyWmF4ZDMxVXJzUFgzL2hxaTNaU1dVcTg0UXVERGJkTlJk?=
 =?utf-8?B?dE5TUVcwelJJSUkrRlZ1MFdZQVoxaHN6VlFCbTBMVENrYlFHY1hBYm43Um13?=
 =?utf-8?B?UHBlRmxZcWFYY1NERk1mNVpVbFlEV1Q1R3BXTm42Ujh6RFJZSWJJSFBlcmlv?=
 =?utf-8?B?cTJWdzgwVVA1SXJ6WmFMeWRQbnp5UVYzaHRtWDcwcUtBc0MrZ2tMd05zR3dK?=
 =?utf-8?B?S3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6BAD33E54F629047BF629DB3D2F85F76@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81fbfc4a-1d5b-465c-ce08-08db78f8bef4
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2023 23:29:55.3698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NAUc/9rUvrze1/JGavKundgSJgRSHUFTYGKxWn7SRy3+jccGRqct0b26HkO2ou0BoJxgjiM+v3ZqXNqTXUNYrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5346
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gVGh1LCAyMDIzLTA2LTI5IGF0IDA3OjIzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEp1biAyOSwgMjAyMywgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFdl
ZCwgMjAyMy0wNi0yOCBhdCAwNzo1NyAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IE9uIFdlZCwgSnVuIDI4LCAyMDIzLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gPiA+IChi
dXQgcmVxdWlyZXMgTUFQX0ZJWEVEKS4NCj4gPiA+IA0KPiA+ID4gTm8sIFNHWCBkb2Vzbid0IHJl
cXVpcmUgTUFQX0ZJWEVELiAgVGhlIHJlcXVpcmVtZW50cyBvZiBFTFJBTkdFIG1ha2UgaXQgZXh0
cmVtZWx5DQo+ID4gPiB1bmxpa2VseSB0aGF0IG1tYXAoKSB3aWxsIHN1Y2NlZWQsIGJ1dCBpdCdz
IG5vdCBhIHN0cmljdCByZXF1aXJlbWVudC4gDQo+ID4gDQo+ID4gTG9va3Mgdy9vIE1BUF9GSVhF
RCwgdGhlIGRyaXZlciBqdXN0IHVzZXMgdGhlIGdlbmVyaWMgbW0tPmdldF91bm1hcHBlZF9hcmVh
KCkgdG8NCj4gPiByZXR1cm4gdGhlIGFkZHJlc3MsIHdoaWNoIGRvZXNuJ3QgZ3VhcmFudGVlIHRo
ZSByaWdodCBhZGRyZXNzIHdpbGwgYmUgcmV0dXJuZWQNCj4gPiBhdCBhbGwuICBFc3BlY2lhbGx5
IHdoZW4gRUxSQU5HRSBpcyByZXNlcnZlZCB2aWEgbW1hcChOVUxMKSwgdGhlDQo+ID4gbW1hcCgv
ZGV2L3NneF9lbmNsYXZlKSB3aWxsIG5vdCByZXR1cm4gdGhlIGNvcnJlY3QgYWRkcmVzcyBubyBt
YXR0ZXIgd2hhdCBwZ29mZg0KPiA+IGlzIHVzZWQgSUlVQy4NCj4gPiANCj4gPiBzdGF0aWMgdW5z
aWduZWQgbG9uZyBzZ3hfZ2V0X3VubWFwcGVkX2FyZWEoc3RydWN0IGZpbGUgKmZpbGUsDQo+ID4g
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGxvbmcg
YWRkciwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdW5z
aWduZWQgbG9uZyBsZW4sDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHVuc2lnbmVkIGxvbmcgcGdvZmYsDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGxvbmcgZmxhZ3MpDQo+ID4gew0KPiA+ICAgICAg
ICAgaWYgKChmbGFncyAmIE1BUF9UWVBFKSA9PSBNQVBfUFJJVkFURSkNCj4gPiAgICAgICAgICAg
ICAgICAgcmV0dXJuIC1FSU5WQUw7DQo+ID4gDQo+ID4gICAgICAgICBpZiAoZmxhZ3MgJiBNQVBf
RklYRUQpDQo+ID4gICAgICAgICAgICAgICAgIHJldHVybiBhZGRyOw0KPiA+IA0KPiA+ICAgICAg
ICAgcmV0dXJuIGN1cnJlbnQtPm1tLT5nZXRfdW5tYXBwZWRfYXJlYShmaWxlLCBhZGRyLCBsZW4s
IHBnb2ZmLCBmbGFncyk7DQo+ID4gfQ0KPiA+IA0KPiA+IFNvIHRvIG1lIHVzZXJzcGFjZSBoYXMg
dG8gdXNlIE1BUF9GSVhFRCB0byBnZXQgdGhlIGNvcnJlY3QgYWRkcmVzcy4NCj4gDQo+IE5vLiAg
QXMgY2FsbGVkIG91dCBiZWxvdywgQGFkZHIgaXMgc3RpbGwgdXNlZCBhcyBhIGZhaXJseSBzdHJv
bmcgaGludDoNCj4gDQo+IHVuc2lnbmVkIGxvbmcNCj4gYXJjaF9nZXRfdW5tYXBwZWRfYXJlYV90
b3Bkb3duKHN0cnVjdCBmaWxlICpmaWxwLCBjb25zdCB1bnNpZ25lZCBsb25nIGFkZHIwLA0KPiAJ
CQkgIGNvbnN0IHVuc2lnbmVkIGxvbmcgbGVuLCBjb25zdCB1bnNpZ25lZCBsb25nIHBnb2ZmLA0K
PiAJCQkgIGNvbnN0IHVuc2lnbmVkIGxvbmcgZmxhZ3MpDQo+IHsNCj4gCXN0cnVjdCB2bV9hcmVh
X3N0cnVjdCAqdm1hOw0KPiAJc3RydWN0IG1tX3N0cnVjdCAqbW0gPSBjdXJyZW50LT5tbTsNCj4g
CXVuc2lnbmVkIGxvbmcgYWRkciA9IGFkZHIwOw0KPiAJc3RydWN0IHZtX3VubWFwcGVkX2FyZWFf
aW5mbyBpbmZvOw0KPiANCj4gCS8qIHJlcXVlc3RlZCBsZW5ndGggdG9vIGJpZyBmb3IgZW50aXJl
IGFkZHJlc3Mgc3BhY2UgKi8NCj4gCWlmIChsZW4gPiBUQVNLX1NJWkUpDQo+IAkJcmV0dXJuIC1F
Tk9NRU07DQo+IA0KPiAJLyogTm8gYWRkcmVzcyBjaGVja2luZy4gU2VlIGNvbW1lbnQgYXQgbW1h
cF9hZGRyZXNzX2hpbnRfdmFsaWQoKSAqLw0KPiAJaWYgKGZsYWdzICYgTUFQX0ZJWEVEKQ0KPiAJ
CXJldHVybiBhZGRyOw0KPiANCj4gCS8qIGZvciBNQVBfMzJCSVQgbWFwcGluZ3Mgd2UgZm9yY2Ug
dGhlIGxlZ2FjeSBtbWFwIGJhc2UgKi8NCj4gCWlmICghaW5fMzJiaXRfc3lzY2FsbCgpICYmIChm
bGFncyAmIE1BUF8zMkJJVCkpDQo+IAkJZ290byBib3R0b211cDsNCj4gDQo+IAkvKiByZXF1ZXN0
aW5nIGEgc3BlY2lmaWMgYWRkcmVzcyAqLyAgPD09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT0NCj4gCWlmIChhZGRyKSB7DQo+IAkJYWRkciAmPSBQQUdFX01BU0s7DQo+IAkJaWYgKCFt
bWFwX2FkZHJlc3NfaGludF92YWxpZChhZGRyLCBsZW4pKQ0KPiAJCQlnb3RvIGdldF91bm1hcHBl
ZF9hcmVhOw0KPiANCj4gCQl2bWEgPSBmaW5kX3ZtYShtbSwgYWRkcik7DQo+IAkJaWYgKCF2bWEg
fHwgYWRkciArIGxlbiA8PSB2bV9zdGFydF9nYXAodm1hKSkNCj4gCQkJcmV0dXJuIGFkZHI7DQo+
IAl9DQo+IA0KPiAJLi4uDQo+IH0NCj4gDQo+IA0KPiBJbiBwcmFjdGljZSwgSSBleHBlY3QgbW9z
dC9hbGwgdXNlcnNwYWNlIGltcGxlbWVudGF0aW9ucyBkbyB1c2UgTUFQX0ZJWEVELCBidXQNCj4g
aXQncyBub3Qgc3RyaWN0bHkgcmVxdWlyZWQuDQo+IA0KDQpZZWFoIEkgYWdyZWUgaXQncyBhIHN0
cm9uZyBoaW50LCBidXQgZnJvbSBBQkkncyBwZXJzcGVjdGl2ZSwgSSB0aGluayBldmVuIGENCnN0
cm9uZyBoaW50IGlzbid0IGdvb2QgZW5vdWdoLiAgSWYgdGhlcmUncyBubyBndWFyYW50ZWUgdXNl
cnNwYWNlIGNhbiAxMDAlIGdldA0KdGhlIGNvcnJlY3QgZW5jbGF2ZSBhZGRyZXNzLCB0aGVuIHVz
ZXJzcGFjZSB3aWxsIGFsd2F5cyBuZWVkIHRvIHZlcmlmeSB0aGUNCnJldHVybiBhZGRyZXNzIGFu
ZCBpZiBub3QgZG8gbW1hcCgpIGFnYWluLg0KDQpCdHcsIG15IHJlYWRpbmcgb2YgYWJvdmUgZnVu
Y3Rpb24gaXMgaWYgQGFkZHIgaGludCBkb2Vzbid0IHdvcmsgaWYgdGhlIEVMUkFOR0UNCmlzIHJl
c2VydmVkIHVzaW5nIG1tYXAoTlVMTCksIGJlY2F1c2UgYmVsb3cgY29kZSB3aWxsIGFsd2F5cyBO
T1QgcmV0dXJuIGFkZHI6DQoNCgkJdm1hID0gZmluZF92bWEobW0sIGFkZHIpOwk8LS0tIEEgdmFs
aWQgVk1BIHdpbGwgYmUgZm91bmQNCgkJaWYgKCF2bWEgfHwgYWRkciArIGxlbiA8PSB2bV9zdGFy
dF9nYXAodm1hKSkJPC0tICBUaGlzIGNoZWNrDQoJCQkJCQkJCSB3aWxsIGJlIGZhbHNlDQoJCQly
ZXR1cm4gYWRkcjsNCg0KVGhpcyBpcyBraW5kYSByZWFzb25hYmxlIGJlY2F1c2UgRUxSQU5HRSB2
aWEgbW1hcChOVUxMKSBkb2Vzbid0IGhhdmUgYSBmaWxlDQpiYWNrZWQsIHNvIHRoZSBtbWFwKC9k
ZXYvc2d4X2VuY2xhdmUpIHNob3VsZCBuZXZlciByZXR1cm4gYW4gb3ZlcmxhcHBpbmcgYWRkcmVz
cw0KZXZlbiB3ZSBwYXNzIGEgYWRkciB3aXRoaW4gRUxSQU5HRS4NCg0KQnV0IG15IHRydWUgYXJn
dW1lbnQgaXMgZnJvbSBBQkkncyBwZXJzcGVjdGl2ZSwgYWx0aG91Z2ggQGFkZHIgaXMgYSBoaW50
LCBidXQNCml0J3Mgbm90IGd1YXJhbnRlZWQgdGhlICpleGFjdCogYWRkciB3aWxsIGJlIHJldHVy
bmVkICAoc2VlIG1hbiBwYWdlIGJlbG93KToNCg0KIg0KSWYgYWRkciBpcyBub3QgTlVMTCwgdGhl
biB0aGUga2VybmVsIHRha2VzIGl0IGFzIGEgaGludCBhYm91dCB3aGVyZSB0byBwbGFjZSB0aGUN
Cm1hcHBpbmc7IC4uLi4uLiBJZiBhbm90aGVyIG1hcHBpbmcgYWxyZWFkeSBleGlzdHMgdGhlcmUs
IHRoZSBrZXJuZWwgcGlja3MgYSBuZXcNCmFkZHJlc3MgdGhhdCBtYXkgb3IgbWF5IG5vdCBkZXBl
bmQgb24gdGhlIGhpbnQuDQoiDQoNCkJ1dCBTR1ggdXNyZXNwYWNlIG5lZWRzIGEgKmV4YWN0KiBh
ZGRyZXNzLiAgTUFQX0ZJWEVEIGlzIHRoZSBvbmx5IEFCSSBjYW4NCmd1YXJhbnRlZSB0aGlzLg0K
PiA+ID4gDQo=
