Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WIq+PrE8"
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2D9B0
	for <linux-sgx@vger.kernel.org>; Wed, 13 Dec 2023 03:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702468375; x=1734004375;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fMERQEXC35yV7hKsoRllubNNmP8F4SikXphrVJFDRl4=;
  b=WIq+PrE8wQXxVPYnJQOYI29iNVt7s+lvcqea3VbjuqHjt7VdSc5wyWem
   x6RSNLUUBV3UrLyLnaWVu2qyrAztZeNyfDNSD/gnwnC6Qg1/6QVHqxEKT
   rp3e3g0MH52u98xSamGC5/fW8cW6Q8m3ptuzKa70Liu9xLQ/ppch6vAeh
   SsqoRFG1KNz+yhhBiWwMro+vN2vhdjIrlPxL2ZfItGuvZs6ueuHiY4nPv
   UMB13ACHiFPb3p1lKf8R9YEJzIuF64wemaSbIf0ri/JdM7PP1QWsU6WWJ
   4F6ujvy7XNESsfhxsXz0a3MWb5Y/eX5hBPaM21fHzYWA5/N87Tr7LPZm9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="459271183"
X-IronPort-AV: E=Sophos;i="6.04,272,1695711600"; 
   d="scan'208";a="459271183"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 03:52:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,272,1695711600"; 
   d="scan'208";a="21929551"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Dec 2023 03:52:55 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Dec 2023 03:52:54 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Dec 2023 03:52:54 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 13 Dec 2023 03:52:54 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 13 Dec 2023 03:52:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IfVDq5hYI1rDqQOAlPi5X/XoMp3rtgebVMUTMkcSvewr+cSUpkN8Tj+YwPcRhsxIKIqWozP4XleY86wQHUVvdneLEtH3Ywfc2eEBEBMqkSrjWZ86DbhIwmJol0flgGF33E7r5lXvYcYznAXUp7r82Fu5hephYUlPusODtE083BeG/iW0fxbiOErIOwwTmHW157YgCpzpmFMNLG5ZWm2r5jIebXD2IR/kp0tDuUtxA4W+TCURgOcWii3/PtjcuzOeommIiWZY4C0JO077qrIprLK7209whczINxqqFsqPLg51KCIzWc5xcs+Ecf2CQoFtcNRR9xnPcdA5xm4Z4KOTYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fMERQEXC35yV7hKsoRllubNNmP8F4SikXphrVJFDRl4=;
 b=nRJ62nMe0bkdr7AqHnIjuH7xahQ4OCvmRP8/XTF4tm2/vQH4h+k/NnYoVmXpTAKZueS4tmq04+no8gFvIfyoA5EZJiqL6/pTt4k7kd4H+n6AJEiPMrnsLydjxuQZT/1m65cCbHmv3t2CdQOW1H6lMUG/kVJxW70bz7AWoXBg5SoZbFYGv71nz5x0srpuR5NQDVqZxxmDSn5I+n/tKEOpB36YghHhtG7ZRPsoAunfgwdSxItJRWHgTvaht+ZiSLTLmczNP0iy8DK+qaqUZv8kJaIKbRyJUSoVkA0MC8+ZwOo6awyut2sFpUflaLdD7vythiDVnJfXgRHGtJdoqaraNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB7137.namprd11.prod.outlook.com (2603:10b6:806:2a0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26; Wed, 13 Dec
 2023 11:52:49 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::5d1:aa22:7c98:f3c6%7]) with mapi id 15.20.7068.033; Wed, 13 Dec 2023
 11:52:49 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"haokexin@gmail.com" <haokexin@gmail.com>, "x86@kernel.org" <x86@kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "pavel@ucw.cz" <pavel@ucw.cz>,
	"mingo@redhat.com" <mingo@redhat.com>, "jarkko@kernel.org"
	<jarkko@kernel.org>, "rafael@kernel.org" <rafael@kernel.org>, "bp@alien8.de"
	<bp@alien8.de>
Subject: Re: [PATCH] x86/sgx: Remove unnecessary try_to_freeze()
Thread-Topic: [PATCH] x86/sgx: Remove unnecessary try_to_freeze()
Thread-Index: AQHaLaNeVDij+7PIikK5R8uKsrUG9rCnGn0A
Date: Wed, 13 Dec 2023 11:52:49 +0000
Message-ID: <300f4f5aac293a843fcffca2ff6154edfe16ad69.camel@intel.com>
References: <20231213090343.1070577-1-haokexin@gmail.com>
In-Reply-To: <20231213090343.1070577-1-haokexin@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB7137:EE_
x-ms-office365-filtering-correlation-id: fe31215b-2940-448f-47f7-08dbfbd207be
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9ddL7LYFfZl2HfVK+sYPRtkwcfF/onxti73AUtsuK69iHPJWAZ85+2gBLa6oA1DC0V9ouUyn+8Kbxpm2iyDjf7M5ntO5lSWP3HnO9REMvDBv+jKeB21IfDh7RbVr9wTj5jrbocSKXkalgGc96MXGw1dDuC6mfFKPCOm7M392InHMy068lO+F2PbvPnIN1V/tJeg8GQ6faU5wI3OxnBy2f99+YtuEHOikS5zhggq+s0eakwVU/XWQqulRXsLMEZUfWeOvU0xPjHaL7x1a8aBiE4j3huyHbK5RV4u0l6UwOjPwdkGBVWkWbjhhaGpxTgeVwwIpBr17o5DecQ4RmT78uZxwvN66oFrdEYDzrY4o6QtQLp1d8Hp1cXoBjTgBIt35mQ7PJ14nqqh+jDUXjcflcNr9j3K1Kk5n+YCMdu0PcAA/7eUkzotb10WeGStu9nmSDzoVKJUwF1VS2WpJOfzI3d1qQ5/LwvvTbIpsc0l0JSyyu6A+3SE7xiHuoc11i7hVZtJ6ThdNqDeNvZi0YqX/8S2yHbcDgjPcxM4zEAA50vbMcRpXUaSSsJxKB18S9MW5RgvIjn8LHqTe2iWysBieRoSUX+zoTtV8YkP8DjPYNu62W8pkK1qX0aIhjwy3I+uC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(376002)(136003)(346002)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(26005)(2616005)(71200400001)(6512007)(83380400001)(5660300002)(4326008)(41300700001)(4001150100001)(2906002)(8676002)(478600001)(6486002)(91956017)(76116006)(8936002)(110136005)(316002)(66946007)(54906003)(64756008)(66446008)(66476007)(66556008)(6506007)(82960400001)(36756003)(86362001)(122000001)(38100700002)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OFdGb210OGozcXFxLzcvSFRRRmMrcldUL04xTFlDeXNXZnpmQ0gwbk94ZjU5?=
 =?utf-8?B?aTlCYS8wK0VVc0hEQjhIU0VuRWt4NTc4TVRVYStGcnhuZk50ZVFtSlY0dHdU?=
 =?utf-8?B?TGVRZ0xFeWlIb2tJR015Q0NDcXpEandzYUhOWHBJWDE2NGZkTXlTcEd1WkpZ?=
 =?utf-8?B?K1N2alJTLzBYcUxIM203U1FnMEtJVUpVRXBCd0NuamtSYUZPMkRzNXZRaXA2?=
 =?utf-8?B?VnlsUkpjaHZqbU5Wbm9PZkZ6SGtSeEM5SWoydGVXdTlkcUZHSWhHQ0Vob3kr?=
 =?utf-8?B?RXB4S2lkWmFlditWV3VqSkhCT01lWU1qS3Z1aTJld0lERWt0bVh3aDVyckZq?=
 =?utf-8?B?cmRTU1ZFOWRvSEhLbGw4UU5zTEQ0MWgxNzZHNnhYY0Ixd3JTNVFZeFZJcHcv?=
 =?utf-8?B?cm9IVjNpQkllQVZqaFZDWFQxV3pBTitIUlVyZ09UOWxQKzhaWUNVdDF4Skpw?=
 =?utf-8?B?cG5ueWxmdDI4OGJYVEVXZUEwUS94Q3ozTkMrVk1IUHJMTVBPSWpSdW00VjIv?=
 =?utf-8?B?UHJJa1RaTkJyb1NEcHFGL3RhS211T0FOd2tGNEtDVWNrOFJIUnkvZXYzbHo4?=
 =?utf-8?B?c3lMcmtJcndpZ2tKVG1WRjBBNFByNjFWd3NWTFY2VVcxdDVBMFNpa0dFTDNx?=
 =?utf-8?B?Z1orbVE3ZERVUFFjdkZPOG5JUitzaTR3OFVNakZaejc2dTNaR2E2WEx5WUxF?=
 =?utf-8?B?OUtvMWRpNWtxOE9VS1lOanpvQjhuNXMvcktzN3g5SS9kcGxkcWtsaWx4RWtX?=
 =?utf-8?B?cE12ejFuMGN6QVNrUTNIeUtrUWk5MnQ4VE9zL1ZRQzNvY0NvMGZhYkgvVXVK?=
 =?utf-8?B?aVFOZTR6RitXajh2dVVLZG4vbldtQTBBUGMrOHNmcWJFQWFSV0xzd2pxb251?=
 =?utf-8?B?ditmSXEyQ2ZPU0RabUtKd3MvZFZqQnk2NmRNT0o2U3JXeVVwbXBBdlROZFJp?=
 =?utf-8?B?emFHK3dtOU5VQ1NKRHo1QzNzRHg0WDZVT1RPYmxQR3hiK2IzZnRRclZVbEdi?=
 =?utf-8?B?OHlGMjdXbEpCdkgwTnExN2JCZ3FNb0g0a0NhcFY1QTRZM2JKRFFobDZkL25R?=
 =?utf-8?B?WGVNZ2NGc3l5cFVkSDhQeHlySk5oSHRCMmx4aW5VYjkveVRSdkRwUk1pWkd0?=
 =?utf-8?B?aXZCeURjcHI5eDF1bUhnK1d0bG9FM056WmlSRUMwWEtKMGgwbndJWFF4MEw0?=
 =?utf-8?B?RlRFSlVSeDdaTFdBR2tRKzV3K2xRNFdpOWJBM3RxejgvR0NtWVRTT3lEKzk0?=
 =?utf-8?B?NDFrUE9xWjZ2Q0EveHJJc041cFFvTVVHQm8raDg1VWs0WjA3a0UxZFJGNVZG?=
 =?utf-8?B?ZzVod1dZWTUzSW1XTmZLMEQvVXovR3B5K0VJY1E2ZG0yK2ZQNTZxdjI1MlJO?=
 =?utf-8?B?Rm0wU2F6SWxSMTFmWllUWTBpYTFRSXlPak9rOTNVek9hOUIyZHFwdS9hLzVw?=
 =?utf-8?B?MGZpcDV6aVJXNXlIbEdDeER2RUpJOWZGOUxpQmZsRHpmUk52K00zUlJRUitJ?=
 =?utf-8?B?TTFKU3VPeEd0dzM1RlRWSE5TcXhLd2ZzSXRtUGU2N2VCV2QvLzlFRnhpbWc2?=
 =?utf-8?B?eVM3OVNseHRBUUkrZ1FSajNIL3FhVkliRS9TcVgvU29rcUt3TTFYRklZeTFZ?=
 =?utf-8?B?djBZamM1QVpmMHpPMGc4Wi80RGh4WWpmMnVRUTJGa1BTazk3SW1WVUFqeWdB?=
 =?utf-8?B?N1BnSERQTFZWV0dRZi83ZkhQUUJuYjFKWTJ4Q3Bra0xaUXhFM1BKZXBZaXE3?=
 =?utf-8?B?Q3gzUmR2eHU1STcxaTVKSks4UVI2NXFhSDNSelBOWnpVdTJSUmprSU96ZTJK?=
 =?utf-8?B?VWl4Z1JPb25RdSs2emNWZnZkS3BEV2R2c3E5d25YVW9WSGFDMkNIMGJ5ei9i?=
 =?utf-8?B?Z3VTamVNRDNaQ0VvTjlVL1praXluK3JNOTdwTzZNQmJBZ2kyVnVGSEZTRnlx?=
 =?utf-8?B?RFFBby82VXY5Y3ZZMlh1M0s3enQ5TUt0ZlY2QWtkV21kZ1NLZm5Va0RUSkxo?=
 =?utf-8?B?ekhDaTd5WjNyeUFmL2dGZHRselFtSUx6YTRqZC93TWJuWVcyTFVBWkhXTXdH?=
 =?utf-8?B?S1RtL0RoWnBXOXdiMmVXaExvMk90RXZLNTRIZ1NNNlZyalVNSlE5VmxrcjBx?=
 =?utf-8?B?bGRhTS94RHJ6YksxR3BkVzZ1M05SSUs2dFdHRm9SWVZ4SGFocStoVWF1VWxH?=
 =?utf-8?B?R3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <566D3FD2410B9542BE008467671B5825@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe31215b-2940-448f-47f7-08dbfbd207be
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2023 11:52:49.4419
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tL5bAws600mC3mfl/nrKFLD1soMvohdu792CfeAavyyQE5DeRXoxcq6Sjjtdo4S7Qvb1NvdHdeCYvaDUl4scwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7137
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIzLTEyLTEzIGF0IDE3OjAzICswODAwLCBLZXZpbiBIYW8gd3JvdGU6DQo+IEEg
ZnJlZXphYmxlIGtlcm5lbCB0aHJlYWQgY2FuIGVudGVyIGZyb3plbiBzdGF0ZSBkdXJpbmcgZnJl
ZXppbmcgYnkNCj4gZWl0aGVyIGNhbGxpbmcgdHJ5X3RvX2ZyZWV6ZSgpIG9yIHVzaW5nIHdhaXRf
ZXZlbnRfZnJlZXphYmxlKCkgYW5kIGl0cw0KPiB2YXJpYW50cy4gSG93ZXZlciwgdGhlcmUgaXMg
bm8gbmVlZCB0byB1c2UgYm90aCBtZXRob2RzIHNpbXVsdGFuZW91c2x5Lg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogS2V2aW4gSGFvIDxoYW9rZXhpbkBnbWFpbC5jb20+DQo+IENjOiBKYXJra28gU2Fr
a2luZW4gPGphcmtrb0BrZXJuZWwub3JnPg0KPiBDYzogVGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxp
bnV0cm9uaXguZGU+DQo+IENjOiBJbmdvIE1vbG5hciA8bWluZ29AcmVkaGF0LmNvbT4NCj4gQ2M6
IEJvcmlzbGF2IFBldGtvdiA8YnBAYWxpZW44LmRlPg0KPiBDYzogIlJhZmFlbCBKLiBXeXNvY2tp
IiA8cmFmYWVsQGtlcm5lbC5vcmc+DQo+IENjOiBQYXZlbCBNYWNoZWsgPHBhdmVsQHVjdy5jej4N
Cj4gLS0tDQo+ICBhcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMgfCAzIC0tLQ0KPiAgMSBm
aWxlIGNoYW5nZWQsIDMgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
a2VybmVsL2NwdS9zZ3gvbWFpbi5jIGIvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvbWFpbi5jDQo+
IGluZGV4IDE2NjY5MmYyZDUwMS4uMzE4MTY1YjNmZjc4IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4
Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMNCj4gKysrIGIvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gv
bWFpbi5jDQo+IEBAIC00MDQsOSArNDA0LDYgQEAgc3RhdGljIGludCBrc2d4ZCh2b2lkICpwKQ0K
PiAgCVdBUk5fT04oX19zZ3hfc2FuaXRpemVfcGFnZXMoJnNneF9kaXJ0eV9wYWdlX2xpc3QpKTsN
Cj4gIA0KPiAgCXdoaWxlICgha3RocmVhZF9zaG91bGRfc3RvcCgpKSB7DQo+IC0JCWlmICh0cnlf
dG9fZnJlZXplKCkpDQo+IC0JCQljb250aW51ZTsNCj4gLQ0KPiAgCQl3YWl0X2V2ZW50X2ZyZWV6
YWJsZShrc2d4ZF93YWl0cSwNCj4gIAkJCQkgICAgIGt0aHJlYWRfc2hvdWxkX3N0b3AoKSB8fA0K
PiAgCQkJCSAgICAgc2d4X3Nob3VsZF9yZWNsYWltKFNHWF9OUl9ISUdIX1BBR0VTKSk7DQoNClJl
dmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQoNCg==
