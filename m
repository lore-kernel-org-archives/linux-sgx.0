Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28893C4332F
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Oct 2022 20:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbiJLU4g (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 12 Oct 2022 16:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiJLU4a (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 12 Oct 2022 16:56:30 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4398BB83
        for <linux-sgx@vger.kernel.org>; Wed, 12 Oct 2022 13:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665608189; x=1697144189;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TgD8c3staKZJIt9LdDcwwCe7LKU3Z/mRsGc3hBEttCM=;
  b=hkGcjag1YUwrBKZFJ7v41DkU/R+zw95ksbCUmM0GLhn9TMsac5UFFisg
   0Z5XdRccqQ/qZshY2yw7+IqYclgG1x87EKdvEz7LaNqBc5hT8Upr/nWBd
   FlLtuLN1tSE0em1zUgWU7RN/vy3yD/4yAZoxgK1Ih/ANRjN40hWLTcag4
   sNQeDGgGyg0AaNsQVZZtU1NFWnZlDY5irHQ8zmtk3XggS+iYZQ7UrIhGY
   OFI/UN9p/yghU7BESVMRcutjSX7dwGxR0KzJqYjXS1yCwGsaK0f4PePyT
   dpgCVwfTRJAC5SLjOshQtaP/s6defTykknQRInFWAKLR0/CPcI5JNypIQ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10498"; a="292231557"
X-IronPort-AV: E=Sophos;i="5.95,180,1661842800"; 
   d="scan'208";a="292231557"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2022 13:56:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10498"; a="695617439"
X-IronPort-AV: E=Sophos;i="5.95,180,1661842800"; 
   d="scan'208";a="695617439"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 12 Oct 2022 13:56:29 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 12 Oct 2022 13:56:29 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 12 Oct 2022 13:56:28 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 12 Oct 2022 13:56:28 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 12 Oct 2022 13:56:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mvmNOZnrHbusQ/Ret5UHNvWa4YFWDu71UTGyfo+hf+/ULZx4J+hHsx4uysby8ASuw/bQO59O9u0LCf70fLQiy7T0VmMNFDJsFqJlTRpv+YNyjykasFaC+jXWpabwGAZnvAZQlbJaULYqHR65Oq0jQdD+8aM9Pubwpy1hUM87x/PG63i9H2FDZOzkZzMf8YElOqLC8WVawE2u5mShCn+96ySSTizFb5YYtaA+d5heHWFjPjeIlR6sL7cpneoKu++nBpSzWkIbxTswqQX0oY+XZd8pk1ApZDKxPyqHaQhOp2/QCCvENgrPS8CinQ96SapbyDiDENj5Vj+aHxm7u81jeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TgD8c3staKZJIt9LdDcwwCe7LKU3Z/mRsGc3hBEttCM=;
 b=FY4kMT+m89Gie9vu56Cj2voB42h+W1uwYzkgXvZaZM09sCP99SvX8nU5u1pkKQpx3eaTRw6apVLp2tJBsDmcNvDudsDPxVV/RV2O23gpeaIVKVsDzU4+StXHlvRwId2VAPJIWKeng32GgzuuJO3xF3McqOUKpkYg80a/+SL0+GHgO6ZjusSdQ9pssfyR6tODtoYZITUO51+ddU0B57OqvWs4IOuCwz+QohY8kK0wYtbYyFWilIieJGqgt2u8jBfmmqPruUN6QT7EiLrcAunUrPVg/aLT5iU8lxPzpQl1GoNkXjqhx5gPANplAOl9+7pTVTWZrrBOuSiBfV3mwtUrsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB7206.namprd11.prod.outlook.com (2603:10b6:8:112::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.32; Wed, 12 Oct
 2022 20:56:22 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5676.032; Wed, 12 Oct 2022
 20:56:22 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "jarkko@kernel.org" <jarkko@kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@suse.de" <bp@suse.de>, "Zhang, Cathy" <cathy.zhang@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>, "Du, Fan" <fan.du@intel.com>,
        "Li, Zhiquan1" <zhiquan1.li@intel.com>
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Thread-Topic: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Thread-Index: AQHYzLsOovV5qYztIkquos7ZMS9Qjq4JWziAgAD86YCAAGJ1AIAADqCAgACXfAA=
Date:   Wed, 12 Oct 2022 20:56:22 +0000
Message-ID: <dc475f04685d7ab2bd9fae6f7914cf58d9c59e23.camel@intel.com>
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
         <20220920063948.3556917-4-zhiquan1.li@intel.com>
         <b775a187-32ad-836f-557f-3486ef4ac8dd@intel.com>
         <14fabc80-a9fc-05b4-eda1-62f2b265e66b@intel.com>
         <188a334629319e430e16d4caf5e4a421b80c357a.camel@intel.com>
         <Y0aq4azJwL8G8OKv@kernel.org>
In-Reply-To: <Y0aq4azJwL8G8OKv@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB7206:EE_
x-ms-office365-filtering-correlation-id: aebfcbb0-f17d-4f1f-ed65-08daac9437f7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fTRpdc1OTZg3A1XvHqXiUyrkr2AnQ31KtflfDhnlXrbudY+2sWxhiWvG44P6N8QNwpHjVkK/i2NLJiEROsL9WCUjsQ/v5hF0vwRFY1fC1uLiovNn0H64MylSgAqk0oGbiVtAq+qOtnLWD8UbMItkImoX9rBqe3pfB0YF0uD1zCUGm2Zr3qP6blvyMZgFkb0L+YAqf38bpChf3d5Btm9yR0qa/26Urug17M3GVoENnYuQ0OgVGVToFA3194SWDSI5hxm3CX3BEUSYya/ux+nnw1kUxwOMxSPclQAXVYJRQHHuDcXe8TlJKY/kcFAbjIslBfLJsUmJ+Hdf9UhsnX1dDo+M/5Iblzp+JrppOLmzPe39Iu7LEHM6sXkckhiVSkCujrpYjJytCMnb6asPlB2GcBuuuPkG/XgVbq2uVJvpjSXANb3N2+SePdDVfFkyDzAX5WtoBPlCbNP46WFzPPeEF3Rhowdublcdl5TzRxTG8gMOw1/uHmRn4fKwVYA29VIy1ODVdFzG12BBDOvxTAVtXhsCrT3Hs8dDfwbA+JpUIvesMcHS2zvu0AJaP8BF8fFX9OyjhcWv4mjMP0m5Q5zIVjzeuD6vBN372lg9RQKOB3Bfas3+pZE/a8T3uh13LxpXigmG6IFBUlQHSjxJ9xqFuHOFBhRqI94RBPxQ4wtAaw3+Zda0x+4UgRJLakmnUmL9Mql9dAwBNvsRDBvIjV5SpNIKM/XTN4Vqwq2hKoh+yBxV8hKqRWuj4/i6LDAR6HkUzXrBi/FazS72s2bdls042g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(39860400002)(346002)(366004)(451199015)(38100700002)(122000001)(4001150100001)(82960400001)(71200400001)(2616005)(6486002)(4744005)(6512007)(6506007)(36756003)(8936002)(66946007)(8676002)(316002)(38070700005)(86362001)(478600001)(54906003)(6916009)(64756008)(76116006)(66476007)(26005)(5660300002)(2906002)(66446008)(186003)(91956017)(41300700001)(4326008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SnI0bVRjSVkzckU3cUhZRHVXdXM0eExsNXVYWXkyb3V3RVhYbFJCU2dZTlZD?=
 =?utf-8?B?RDNHWC9vM2tRdVJJbVZnaHN2eS9EUWROeWpyejJiRlZnM0ZSb3ZoYzhwK3Zo?=
 =?utf-8?B?TGZaOFF4dXZIaWNzY0MyN2szS3E5ZHQvaGlvR1BROGU2bmt2TjcvOVRRMWlr?=
 =?utf-8?B?WHNOckY4TW9keHVtYzZYVUpaUTllV3hnOTFKRjc3djhKQ2xRUXdzS2VLc2Ro?=
 =?utf-8?B?MjZGaHZadGtxU0Z1QmpSemlaWStNWUVKWVZ3K1hzUzVKOWNxQUNFL3lYeVln?=
 =?utf-8?B?SWhjeHVHRFNERUxDendkZ0ZJZFIvbEw3RWV2eVA1Q2ZUa2VPV3BSRkRpTmhw?=
 =?utf-8?B?R3R2UFk4QUticjRNUlFsNTVQcTc0blhEL2VpNUUvYnp4QlR6MGduajJ0ZXlV?=
 =?utf-8?B?Q1FVNHI2V1ZNR0gzSW1uK1NzaklrTTRTVzJadDlhN1dXS0ZjR1BlWVMzNEo4?=
 =?utf-8?B?UjBDaDg3ZFM0Tm5sbG81akM3SDhiVzFoa3FqUkt3ZzRhWUdEQ2ZIRERJVWdt?=
 =?utf-8?B?dExCaFJMME9GU3ZGVkdhUloyV0o2N1VVb1gzM2VFTDVaZHJpaXljUzM3YVY1?=
 =?utf-8?B?dFFNVG84aEhzTTZCMEZlRVBEWTJWZlFkQ1RWOXVxOEU2ZkF3QUJJSm8veUtj?=
 =?utf-8?B?eE9pWlhZN2VmOHk1ZWNLVjg2cDZLdmtPS3Noem1BNWtLSEMxbW5rekp5eVh0?=
 =?utf-8?B?dGticCtnTHAxY3dVdThaR1lnWlg3VVIwUWZMTVlScHNTc2F4b2daMnlhRkVl?=
 =?utf-8?B?bDZoYXJHR0tUeVAvenlGVmVtMk5xUW5KTW01SVJvTmlYK2g1bVhDT1F1UGFl?=
 =?utf-8?B?eDR6SlVRcjNQU3YzZW1lOWgyTnRoS3oxR3IyZ2NRQkVlY0E1VTlna1JjZ1Zu?=
 =?utf-8?B?d2pHQXI1d3MwM0lIcENuMDZnVU4ydGIxZWVhWXRwWGUzOVRHb0IwdThRdTdE?=
 =?utf-8?B?aGlaTVFpTHplNmZHODVwNVFNYi9vODlQc25WYXo0QW1Ld3JJWHZac0YxOU9T?=
 =?utf-8?B?b3RwUVdGOTNqbk5IZmhYclZiWS9heFNTT2VESjZxKzRpaGMxN2FNRjdrZEFZ?=
 =?utf-8?B?U1hQaU9ud0kxcTZBOEZraldDWFd5YjlUeU83MUhxQ2dYZXd2b2lzYm9lbkZr?=
 =?utf-8?B?WmI0Y2U3RDcxdUc5QkxNVjhIRFlrMVgrS25QTUhQTHREenJvbmwwSUkwTmZy?=
 =?utf-8?B?Y2NmakVlR0N6a1ZvazVvYXcxS09wUFJBSWJGK0Q2VGROL00zdUVkZzlEVmp1?=
 =?utf-8?B?NVZLYmprT1ZObVlNb1ZheXZQd0p4QzJNOVJXNkYyQXltQWpSWXdJR293N0FM?=
 =?utf-8?B?YVUycGNmam5rZGZLeU5XNXFBS3ppVHplcGVmZzNZMHM5NGFLeGZkYUJBYkc1?=
 =?utf-8?B?MjV6djMwNzhKU045WVFNN2lOdHVpSDRYNys1eVBnUXhCdVh0R0Q5QU1BMWto?=
 =?utf-8?B?UDhCZ0pIWHB1alR3MzE0bml1bW1qbStwUnpDSVhYRTQ1TlFUUjFFbGVHSHhP?=
 =?utf-8?B?dkNHcUhWRTNaRkhpOVI3aXZvR3JJQ2VLaVJjN2JEeFBCQmU1aHVNQWVBVGRl?=
 =?utf-8?B?cmtIMkVyNk1hR1I4ODl6c3ZmZ2RsdXB4TCsyeFo1STlRZVRGQTZ2bnV3MWZT?=
 =?utf-8?B?T2tENmdtajBMNklXYXRRSzJuMnBJd2tWV1Q0VjlPUFlWSU0rT2ZyeGV1L3pk?=
 =?utf-8?B?MFg2VmJ4Z0l3c0k2QzNNMWt5d1NHaURDMjVUV1YvY1NmeVZzdUFoSGdOdW9n?=
 =?utf-8?B?SWhNRVQ4eVBweGZGOVdZQzZwVkVUUlFrZjQ5emUzNmtSLzhyZmlaYzVLYlV4?=
 =?utf-8?B?T2NQai9BUS9NWlBDYkJHQWR3VUFSVjlBbFdZaE5CZDA4ckQ1TGp0YkJldTc1?=
 =?utf-8?B?K1gyRFpxaWdRQnNMK1A2TGRGeFMzN1ZOREJPcGhQYUlTRFdGSlpzVFdQTTlv?=
 =?utf-8?B?MU5hVHEzMlZ6cTdDSnhBZThqY05HalFVRmd5ZkExMTZMYVpSMUpMZmY1VWZJ?=
 =?utf-8?B?dlNVZWRPZE05WFQ2dG9BVWFyZUdaaTY4emdiTWpLd2JWUVM1T3hJRG0wRXlR?=
 =?utf-8?B?MDNrdVUvUkhmY0EzUkRnQnpiMXZEYjFZeVZLczdXdE9WM2FIVUlwMjc1Znd0?=
 =?utf-8?B?NHh2SWVYcjQ2UW1KbWNlVDBZck5FOWV5MmdEN3JFQkl3dnhPYzByWVV6Rm9U?=
 =?utf-8?B?ZVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8E1FBB3E727573419FBF2F5A43ADE305@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aebfcbb0-f17d-4f1f-ed65-08daac9437f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2022 20:56:22.0322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LGMl7DsAvmwCzSZ2ERZJOcDVa3Y+6ptx/hYxXjVGrnT9HqaoHBzf/VXBtgSXtCZ5WsFMOpdb5mmSuOqgIzVLTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7206
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gV2VkLCAyMDIyLTEwLTEyIGF0IDE0OjU0ICswMzAwLCBqYXJra29Aa2VybmVsLm9yZyB3cm90
ZToNCj4gPiBTaGFyaW5nIHZpcnR1YWwgRVBDIGluc3RhbmNlIHdpbGwgdmVyeSBsaWtlbHkgdW5l
eHBlY3RlZGx5IGJyZWFrIGVuY2xhdmVzIGluDQo+ID4gYWxsDQo+ID4gVk1zLsKgIFdoZXRoZXIg
a2VybmVsIHNob3VsZCBleHBsaWNpdGx5IHByZXZlbnQgaXMgYW5vdGhlciB0b3BpYy4gVG8gbWUg
SQ0KPiA+IGRvbid0DQo+ID4gc2VlIHN0cm9uZyByZWFzb24gdG8gZW5mb3JjZSBpbiB0aGUga2Vy
bmVsLsKgIEZvciBpbnN0YW5jZSwgbXVsdGlwbGUgVk1zIGNhbg0KPiA+IG1hcA0KPiA+IHRoZSBz
YW1lIGZpbGUgYXMgbWVtb3J5IGJhY2tlbmQgd2l0aCBNQVBfU0hBUkVELCBpbiB3aGljaCBjYXNl
IHRoZXkgY2FuIGFsbA0KPiA+IGJyZWFrLsKgIFVzZXJzcGFjZSBzaG91bGQgdXNlIHZpcnR1YWwg
RVBDIGluIHRoZSByaWdodCB3YXkuDQo+IA0KPiBCcm9hZGx5IHNwZWFraW5nLCBmb3IgbW9zdCBv
ZiB0aGUgdGltZSwgYW5kIGZvciBhbnkgdG9waWMsIGtlcm5lbCBzaG91bGQNCj4gbm90IHByZXZl
bnQgYW55dGhpbmcsIHVubGVzcyBpdCBjYW4gYnJlYWsga2VybmVsJ3MgaW50ZXJuYWwgc3RhdGUu
DQoNCkdvb2QgdG8ga25vdy4gIFRoYW5rcyB5b3UuDQoNCi0tIA0KVGhhbmtzLA0KLUthaQ0KDQoN
Cg==
