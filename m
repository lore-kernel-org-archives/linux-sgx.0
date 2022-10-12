Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F88DC4332F
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Oct 2022 11:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiJLLB5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 12 Oct 2022 07:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiJLLB4 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 12 Oct 2022 07:01:56 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F58EBEAC9
        for <linux-sgx@vger.kernel.org>; Wed, 12 Oct 2022 04:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665572515; x=1697108515;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2J46DcAVN2IznSc52U7q1alOjzGcj4laFGzcBF9PYvM=;
  b=Ek83E9zYRfsKSg/8C6jGo4NIh1Am+E3syAWErpLbfb5VPxqr3bZrc6SD
   5hXlRCqY85/3dSaAQiKnO6T6PBmC/wipBA7OdhnOveV8JwP+EkHJO3bnl
   eA+psuSSP1Ad4ytE7sc7kLQm2RHlw0AbdqmTCsRqHxedhBk2cPS3PkcYV
   oBk5wIClnyNjfQ7V0iG7hGww2roqxQ6CHUslphCNb8aeNmaHFhdg3IOBf
   mYMaG9AqnvN+aWuaLCO/Nz0hPk1xILvRKQlzf0dyExkXkcR3ggFBOnxfS
   bC7fqkHKPUDj/PN88ZgBn+1J+ZziHnz6KNeQn4LHMn7KyVM5X/dJs2pQL
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10497"; a="304750631"
X-IronPort-AV: E=Sophos;i="5.95,179,1661842800"; 
   d="scan'208";a="304750631"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2022 04:01:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10497"; a="769170584"
X-IronPort-AV: E=Sophos;i="5.95,179,1661842800"; 
   d="scan'208";a="769170584"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 12 Oct 2022 04:01:55 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 12 Oct 2022 04:01:54 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 12 Oct 2022 04:01:54 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 12 Oct 2022 04:01:54 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 12 Oct 2022 04:01:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZJFpNZOPHnuKB41AK802ZprDMhOpMaIx08yXo9Zz2uhJV/iNhJuw6GP+Z7+6iVJCDiH/MBZR/WNsDKEs+BmyM91QbTKbHGQOwUBisPcgEvUErMYyHlvB4LNCCfLOpE+L82DoocQfSc31Xm+NjIycox86Cd28L6dItDWyfMdH6BDHq1beYIlWkGzCMplxNype5zTjCrpB3mYL0vS+UuAIV39jDobyQAgOkHYhRBrIdL6G4k/FvuNZxfNlx91/Mnmzshfuv9hKapoYBPp82oBgbI08uikyY3M+e9UrsblpSeQv/X1de9dJfGnUtV57ROlcoKEGI3MnqnnAYAhck/qyYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2J46DcAVN2IznSc52U7q1alOjzGcj4laFGzcBF9PYvM=;
 b=gWmdIbvDbAtBFu2rmShQKqtYHX3Q8bAR7GcOvuqOVBBQlBWoaL1xv6GZELxyllP4IUnr3VOi4RqEr/tZvbDfDfe0se/IdBpGo8nYqV2k3oqTIr+Oj7/VBt6lfsIWHT0uWbGl6GYAZyQ89VsqtlKZTa1yDFvnhCr1nEH1n9inZW73DZxatnD63zZ/X5Na07oZ+Paw4XnbQMUd9VdXhdGz+wzQYzVx63BnI2hUn2q3wM6rIspzS/ETi8w9jfQMyhvFs4m3E3cKlBedbReGdkREIFYb8zjqkhCMIyDLc7gsOgDkuYclZB5ei4S5g7cFF/x+KKLLnXNgr46GizChCIqfsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ1PR11MB6084.namprd11.prod.outlook.com (2603:10b6:a03:489::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 12 Oct
 2022 11:01:49 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5676.032; Wed, 12 Oct 2022
 11:01:49 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Li, Zhiquan1" <zhiquan1.li@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "Du, Fan" <fan.du@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>, "bp@suse.de" <bp@suse.de>
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Thread-Topic: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Thread-Index: AQHYzLsOovV5qYztIkquos7ZMS9Qjq4JWziAgAD86YCAAGJ1AA==
Date:   Wed, 12 Oct 2022 11:01:49 +0000
Message-ID: <188a334629319e430e16d4caf5e4a421b80c357a.camel@intel.com>
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
         <20220920063948.3556917-4-zhiquan1.li@intel.com>
         <b775a187-32ad-836f-557f-3486ef4ac8dd@intel.com>
         <14fabc80-a9fc-05b4-eda1-62f2b265e66b@intel.com>
In-Reply-To: <14fabc80-a9fc-05b4-eda1-62f2b265e66b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ1PR11MB6084:EE_
x-ms-office365-filtering-correlation-id: 1f0195c6-ede9-4b02-6527-08daac412958
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oTzWNMlVy7VoCLL2Z+6qwdt/2QqDb+uIlchK22SCanJIzX56WosSMOQP2FMF8BsL/5RqHnl6I8+/2La7ha+WDTOslCyBWCHiFFU49z11rC8t2oj9iy5yTdePiqsoi5Nmo1kSSUlH+PWe5lBEJ6dBlSA95Xi2RJMzKduhA6c+3RSSpatwOs7mlM4oJi7f9KnI1xYpim4hISpYn1tqaCywouxmpP+NwRXyJpVhnGRb2uYb5pwWvh0ZNYs2mWVuHkJUlqGiE2swPNvLgyYpv/CD/oOmoiHHx7P6rVyiYWScJCWgmShZLFqc+0Xiev3KywKOImxDzFO5l/Py0Tr0CdUkwbv7xhBv8u1DY1ThoZjPiphMeQWgj27g7xdbxCzyHCU/1b2RjJeERijWDSP+A9ZzhVWUgY2KYPI3zmLKf9Pplr/nWzuQ/A2MAN0SpN8QO55wPWmXKOxLhUZLNyz+ZoG1mqXmtfmHrLr+PA9a3/Ef8UDlUXM2b2Pk8r8rRM9D+AGCtkfVTm4Ca9zZASgFZo0WMo75PgEu2ZnjfaEXlOxUvnqPWYCzv+/WoArrY7nXMLO69rTFW4ksnb9FGXDp2V8QivGMSUNH/hNzjvc/FZup0a8JPqu04d1w7LM0lpy/Y0mG+9QbK8QwHj5cASW1AwSemuB2OYTIMXr+wHqbuyZMQDKA+q8WZwlWz7zlgRBcv3ey9Fp8H+74o98mbQoRlSJ+cRTUJr9fPM+NNi4pyAZuwTkYwj5wwRyXcPhA2jsWoVWTe7jbzqRX+gBncrWoayZejPZwz+YhEV18pE8+NOTLD+k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(366004)(136003)(39860400002)(376002)(451199015)(110136005)(54906003)(41300700001)(5660300002)(4326008)(66946007)(71200400001)(316002)(86362001)(4001150100001)(76116006)(2906002)(66476007)(26005)(8936002)(66556008)(36756003)(8676002)(66446008)(64756008)(91956017)(122000001)(6512007)(2616005)(186003)(38100700002)(6486002)(966005)(478600001)(38070700005)(6506007)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bHJkd2FOM3B5ZG5nSk9xV255RDdPUzN0a21OZnZJUzRHbzZEVnp3NjI4WEtk?=
 =?utf-8?B?dG9xWTBCTUIwUlVoczJvV1ZGNnBBWExpQ3ZoOTgyN0JJN3BVMXF4T0xrRFYw?=
 =?utf-8?B?dHQ1TS8zOGFNdlJHNW4zRkR6WWxDZmh4MUJTYmhXTWhDZDlpT3h6RjEwMGN0?=
 =?utf-8?B?bzZ0dTg1N1dOTzdYazhqZTQvR0NWN1p4VUxvMU8vOTVWREN2N3pGazRVNkli?=
 =?utf-8?B?K3kvVXFuT2NxWTdNOUF0RTdZa3phSG9uUTM2MFIyZVQzUlpLRHh2V0Q2OHIy?=
 =?utf-8?B?ckZuZS9ZVlppNGFhK1M5SldtNnA1T2NYNUZpcGlraVlkWUVnT0doYVdBVHl4?=
 =?utf-8?B?L2dydklyUUhubXhWQnJDa3pyNFJtWmZ4ajV1azlpN1kzR0dyaWRBM3Q2Rzh2?=
 =?utf-8?B?N29sT21WYUpleTFlQ0pBMGRzQVRyS0VaSG9JWWgrWDA0M1cyMlUydmVqTW5u?=
 =?utf-8?B?cmJtNW4vTkphVzBFREsxcEtOb1Qvc2RtUG96OU83WDd6Q3FNREdIbytCM1RI?=
 =?utf-8?B?bS9QSnZWWFFWbDR2TzF0Z09GRDNsZmdqdnRMZGZWbDVsOUhNQi9BdGdoMUZO?=
 =?utf-8?B?dk1veldheStibm02YklZYi9teUN1d28ySkJVVk1PWmU3eHFlek5uQVJVUVR6?=
 =?utf-8?B?QjNvVFhCaDVtNnM1eC9NYk9MdUtqUkMrdnRNTjgzQTY2YnBmT0xIc3dUWHBE?=
 =?utf-8?B?WVI0dm85em1VWk1pTnpWT3FQWjg2amlxNlpOUVZDQVMxdkluY1JIWDVMaFZE?=
 =?utf-8?B?MGZNMjlzS1k2OWQ5dTI2dmtPdFZtUW44aDZacElhR1BEZSttM05ZdFB3N0x5?=
 =?utf-8?B?dEphZnRuVmxJTHNGQlRJUmJiUjBGN0g5MUhaUnRud0YyRndqU1o3TXM4RWlr?=
 =?utf-8?B?R0N3V1NYUi9rYnhmOUVZVlhoTGd1S0hvQnpMdXBUa1NZYkgrUGkxUUhxb29i?=
 =?utf-8?B?Tks5SDUyVEl3clZRejByRFAzajFWd0dEWXAvQlBVOW11ejhiZ3pCWWxaSFRk?=
 =?utf-8?B?WkMwaldjcFZFNXZIWFFodzhlUkhJRnNkTFM3NTcxWTVFd2VEa0tvVUlpcFRz?=
 =?utf-8?B?R1BPZ0UzQWc3WHQ5Slk5a0Z6dHp3RlQxTnBrKzhtRUNUb29UNzFON0R5V1Jt?=
 =?utf-8?B?VDR6Vy9GaHQ3VGphQTZXV054ZW9yTzA5Vk82WXlKeFJWVVMxTGF0THRsNzgy?=
 =?utf-8?B?TjRMWEV6YXFLcHc2bWVRVVZOTWUya3preE5XbVVFOFJOb2hrcUI4dzNEQ1RV?=
 =?utf-8?B?Y0JRWkgvYjVNR0ZKN242TXRkam5IVDRCVGJnUUUvNDIrU0hScUhJT2ZBWVV3?=
 =?utf-8?B?amYvNUpXV0huT09BWGVpV1FqMlJ4elpzcjhDaTZBbnU3V3NKUldyRHM2Y2Rz?=
 =?utf-8?B?RnZNS3pWY2l0VGNmYUc3OE9YWlZ1Vy9aa2VkS09LVW91MHZLbHRrbExDSmR5?=
 =?utf-8?B?cmw2cjZJbmZRek0veWJyR0d1WHFMejZFWmJ6V1Q2MXJDNDYxUHVjWEVObEJ3?=
 =?utf-8?B?alkxdSt4dWJkcHhiR2ZvQmJvTmNlVGs4Q0VvWWZnOUdLM1k0NTFRVW56Yy9O?=
 =?utf-8?B?czIzQ0lscGRVeFJ1RERxOUptR3NCYTRxd01RWFpKWFQ5QTk1Z0ROKzlFcHJ0?=
 =?utf-8?B?SVpzNFBROXAxc0dpMmduQ1BQanVuaFdKR3ltaS9pVUdOUjU4c1VrYW5xQXdw?=
 =?utf-8?B?ano4VktodWpBNXBPQTRtd3NwMDhoZlRPRmM1RHlmcWQ4UHVvdVp3STVlYmZI?=
 =?utf-8?B?RTZCamhVY0QzTG14dGNybE9HZG45MVlxWUtUV1JTREpiazNPSmk1QXBycWcv?=
 =?utf-8?B?YTgwQnE0WnhlQ2tYdFpNbEVRMFBuUXFBaXppbDRMTGYzUG9QNG4xT1B0VlRz?=
 =?utf-8?B?MGZBZVllNk9IZmpway91QVZJZ1BvTGV5emdkQ2FTbXl2K2tPWUhHb1JkM215?=
 =?utf-8?B?ZEFrODQ0QmNJdzVnSjlBVWZvTnhUd01tdUxadjFaUGgwK3p5TTJBVVY5c25u?=
 =?utf-8?B?QnVkdHJzUjFSc0Y3d3psbkxubU5ITE1lSU1xNVFZUkYxTWdFdkRMcktJUVQ3?=
 =?utf-8?B?SmxVYTQ3VVRVT1ZITWpLOUsyREo1L3ZJZFJILzJWTEk4Qml0QzBUZ2tuYkN0?=
 =?utf-8?B?VC9nSFpCNVd5b3BRczR3SUNYcmErU2lxY1gzbERrRHN2Rjg2TFlaZ0RmdTRK?=
 =?utf-8?B?UGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A0C458E65C2664FB378CCEB18BC8810@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f0195c6-ede9-4b02-6527-08daac412958
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2022 11:01:49.2388
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tlj4td+IDdh0MhS/TiwLwQ7Nxspg2JZKrMqXdJM32p1Et7qgOXAi3dXxz1UNyKxPlfwYSQwSGbIJGGXLCsie1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6084
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gV2VkLCAyMDIyLTEwLTEyIGF0IDEzOjA5ICswODAwLCBaaGlxdWFuIExpIHdyb3RlOg0KPiA+
ID4gU0dYIHZpcnR1YWwgRVBDIGRyaXZlciBkb2Vzbid0IGV4cGxpY2l0bHkgcHJldmVudCB2aXJ0
dWFsIEVQQyBpbnN0YW5jZQ0KPiA+ID4gYmVpbmcgc2hhcmVkIGJ5IG11bHRpcGxlIFZNcyB2aWEg
Zm9yaygpLsKgIEhvd2V2ZXIgS1ZNIGRvZXNuJ3Qgc3VwcG9ydA0KPiA+ID4gcnVubmluZyBhIFZN
IGFjcm9zcyBtdWx0aXBsZSBtbSBzdHJ1Y3R1cmVzLCBhbmQgdGhlIGRlIGZhY3RvIHVzZXJzcGFj
ZQ0KPiA+ID4gaHlwZXJ2aXNvciAoUWVtdSkgZG9lc24ndCB1c2UgZm9yaygpIHRvIGNyZWF0ZSBh
IG5ldyBWTSwgc28gaW4gcHJhY3RpY2UNCj4gPiA+IHRoaXMgc2hvdWxkIG5vdCBoYXBwZW4uDQo+
ID4gDQo+ID4gVGhpcyBpcyBvdXQgb2YgdGhlIGJsdWUuwqAgV2h5IGlzIHRoaXMgaGVyZT8NCj4g
PiANCj4gPiBXaGF0IGhhcHBlbnMgaWYgYSBoeXBlcnZpc29yICpET0VTKiBmb3JrKCk/wqAgV2hh
dCdzIHRoZSBmYWxsb3V0Pw0KPiANCj4gVGhpcyBwYXJ0IG9yaWdpbmF0ZXMgZnJvbSBiZWxvdyBk
aXNjdXNzaW9uOg0KPiANCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtc2d4LzUyZGM3
ZjUwYjY4Yzk5Y2VjYjllMWMzMzgzZDljNmQ4ODczNGNkNjcuY2FtZWxAaW50ZWwuY29tLyN0DQo+
IA0KPiBJdCBpbnRlbnRzIHRvIGFuc3dlciB0aGUgcXVlc3Rpb246DQo+IA0KPiDCoMKgwqAgRG8g
eW91IHRoaW5rIHRoZSBwcm9jZXNzZXMgc2hhcmluZyB0aGUgc2FtZSBlbmNsYXZlIG5lZWQgdG8g
YmUNCj4gwqDCoMKgIGtpbGxlZCwgZXZlbiB0aGV5IGhhZCBub3QgdG91Y2hlZCB0aGUgRVBDIHBh
Z2Ugd2l0aCBoYXJkd2FyZSBlcnJvcj8NCg0KU2hhcmluZyB2aXJ0dWFsIEVQQyBpbnN0YW5jZSB3
aWxsIHZlcnkgbGlrZWx5IHVuZXhwZWN0ZWRseSBicmVhayBlbmNsYXZlcyBpbiBhbGwNClZNcy4g
IFdoZXRoZXIga2VybmVsIHNob3VsZCBleHBsaWNpdGx5IHByZXZlbnQgaXMgYW5vdGhlciB0b3Bp
Yy4gVG8gbWUgSSBkb24ndA0Kc2VlIHN0cm9uZyByZWFzb24gdG8gZW5mb3JjZSBpbiB0aGUga2Vy
bmVsLiAgRm9yIGluc3RhbmNlLCBtdWx0aXBsZSBWTXMgY2FuIG1hcA0KdGhlIHNhbWUgZmlsZSBh
cyBtZW1vcnkgYmFja2VuZCB3aXRoIE1BUF9TSEFSRUQsIGluIHdoaWNoIGNhc2UgdGhleSBjYW4g
YWxsDQpicmVhay4gIFVzZXJzcGFjZSBzaG91bGQgdXNlIHZpcnR1YWwgRVBDIGluIHRoZSByaWdo
dCB3YXkuDQoNCkJ1dCB0aGUgcG9pbnQgaXMgYWJvdmUgaXMgbm90IGRpcmVjdGx5IHJlbGF0ZWQg
dG8geW91ciBwYXRjaC4gIE9uIGhvc3Qgd2hlcmUNCm11bHRpcGxlIHByb2Nlc3NlcyBjYW4gc2hh
cmUgb25lIGVuY2xhdmUgbGVnYWxseSwgaXQgZG9lcyB0aGUgc2FtZSB0aGluZy4gIEkNCnRoaW5r
IHlvdSBjYW4ganVzdCByZW1vdmUgdGhhdCBwYXJhZ3JhcGggZnJvbSBjaGFuZ2Vsb2cuDQoNCi0t
IA0KVGhhbmtzLA0KLUthaQ0KDQoNCg==
