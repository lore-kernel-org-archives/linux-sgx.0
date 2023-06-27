Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D67EB64D9
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Jun 2023 11:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjF0LnV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 27 Jun 2023 07:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjF0LnU (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 27 Jun 2023 07:43:20 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67E5109
        for <linux-sgx@vger.kernel.org>; Tue, 27 Jun 2023 04:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687866198; x=1719402198;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WxptaJKpnM36sYz64jgOcgcZof63+BRo/AvLws05ikY=;
  b=IVqfo2GpqkdrJpiGXCJIStssjdM7QxXVMeEYdUosNem9hMgwSgw7ScXv
   a7dvxy8o2xIUNpucTyDNw4MUb+oyejq/0a9gwcFn/P+eQN3oGoPrI3CHo
   GBCRPkeEOZxuFOLxg5VZsiw1NOkLqiH4uQyG5YAGlj/QOJnEz05U2dyXE
   4FUDNWAmBetmfwyKITjP2XZeXf9GsdHUXcXHMoAAIkFFXOjrs0iPssQmP
   ql92ez9dW4ljzCXIcbTj2EOQu4YGU9eJvRkyNJNx4rAG+4k43Vpv7e6qn
   S79mF3GdRMFN+yUf6r6rV10tP2WWmezyFn4geAzeq42Vxa5N63Zyfl/EV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="425217364"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="425217364"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 04:43:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="710622669"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="710622669"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 27 Jun 2023 04:43:09 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 04:43:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 04:43:09 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 27 Jun 2023 04:43:09 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 27 Jun 2023 04:43:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d7YVgiyuyrCh5ixT/M1HBaFMQkPRc154D5kbv74YcEIFO8qI+QTMvPW1LCMfqIEhiBYzRS4mh+KMy1wmRjoJR3kmEis4AZwB38RLFNUO1+PyA9L1h0IMtcDnrGgN2Pg6HEP0rEsmNS5YlZqbLep2N5HVnYR2uyVYQ2IEQ7f8OOj4JVDC6CClE7xbXS79K4emV2I4rTBr9/yIDFoH7/on9PssFFl2k3uphCNc8rtqkSZmuxIKrcfzD6NhEDzHODi2CkkfhCTD2flawybyaXZErUs+U35lw7q17u+wyppLSIRPo8+Z5A2E2bQUm9Y3/QZLJxk8D5TRt5Xa5D32aDi+jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WxptaJKpnM36sYz64jgOcgcZof63+BRo/AvLws05ikY=;
 b=ifm4WFUAQEYXi3RfPjalhjKOsp4C8vLyQbJGVpxodhnryR9Ud9dbTVEqDMhefxSkAXEPO25Uwulgyz9vDGu60DTMFbYVZmT4cjAWRwn0woR2si1CsfXJCIakv5/Zv6oajxTQJSmZMC4q+o0i1NpyKtavlp+9rimnzIst+UmDdRhJYeQpPEMV5Ht60FkTIldc84ZqaVU6KpBAWM5u7WKsRz2NGokriE4BkfbYnNwr3epvR4XNMotKi8ZrJHq+bFUVq6zeW1ij1empToddcn44nnUQ5xBkxRvGT6XmE/vf5yX4KuTwwztBTdqsEDTtcxhWVeR+lM6L9ksM5QSOdDBOGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA0PR11MB8400.namprd11.prod.outlook.com (2603:10b6:208:482::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Tue, 27 Jun
 2023 11:43:04 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Tue, 27 Jun 2023
 11:43:04 +0000
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
Thread-Index: AQHZMtTIU78a0A3o9UaUPrwPUmNX5q7OTQIAgACfroCAABrOAIAADTuAgAAPNoCAAFobgIAAUaaAgABy3wCAA5ciAIAACKGAgAY6gQCAADnpAIAV3bGAgAGoFwCAALMwAIB7cDIAgA/0eQCAD7ESgIABMj4AgAQB+wCABWrEAIAAFpKAgAY6eYCAAN3pAA==
Date:   Tue, 27 Jun 2023 11:43:04 +0000
Message-ID: <7e78ec8fd22ad9f8b828fa00b9811bbfcf855b2c.camel@intel.com>
References: <5de607230294552829b075846a66688f65f3f74e.camel@intel.com>
         <op.11iklswmwjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <e65d5e589e404f37b3f9ea15a2fd8e132d9040a1.camel@intel.com>
         <op.15kug6t9wjvjmi@hhuan26-mobl.amr.corp.intel.com>
         <5930de9d076d148ae572aa081c7dee8a5b696b61.camel@intel.com>
         <d0b65bbdd20a79a43d979b08972dd05bfc79b08c.camel@intel.com>
         <ZIzcrmU1RA7oEeQ7@google.com>
         <fc214963a01ca975d6de2991b63c93f04114c562.camel@intel.com>
         <ZJTEpH2yYtHmTRWr@google.com>
         <66f22efc5a920a805d6863dcc152c3c12e8fb6fb.camel@intel.com>
         <ZJoRHU1CHxIuDH29@google.com>
In-Reply-To: <ZJoRHU1CHxIuDH29@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA0PR11MB8400:EE_
x-ms-office365-filtering-correlation-id: 237215b3-26bc-4431-a48b-08db7703ab69
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o3YHU/Vj9nJQGboA1Vi84NSfPLZy64Q+0LEONelH/bS5edhCf0WZI0/REgy9/LcU1x0AXPSaCUjIBilnBJlLsUe7trO8LmJaQyTQLWZCb/ZrtJ7KA9SxUyM2hT+zvVSS14sgukpzbdt+Y6n9tSy9gzafpdIjVuOMwL3vdvxnauhXHwD0z3vGQrXS13xttlc4etQJObJlpHFvSUhulBHBzkp/vjq6YvzRCj+1C9uTf0pgAvxwsCB09XGyij6woSuojOCyd2Z7lNTNenG5SyZTh4c/IgIwtQO2g8H1OdxIXkpbV9wmL97ig7aAqy4VabVmDcMvqhGudGJ//uri9BurX6vOwF/8C1fAIwFlXJegEtY9s1dcxpnoKWtk6yN0UMQQ4JsFg18rlrr5aZNhGEHu51MzF7sZunyvDW0E/+lHyXI/ZghqI2SLw6tLz8c0Pam7iaI/aIlghnrJWmzcqzvOCoANKBDkEDluBAYQGZtfE35QUgJMOZBjcftHV9NTLPfKYRrwTAHVq+08h8F9QmjrdPiBYQAo8d5S9oj2wXTH7fGGxtV+UphBF3piGhjEaNDFJBN/hjKZbCc09iHedn+NYfL6TC+X0leHsigJ3sU9wv50wGJsiRHqzvEfR5utNCkl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(346002)(366004)(376002)(396003)(451199021)(36756003)(91956017)(66556008)(76116006)(54906003)(66446008)(4326008)(6916009)(71200400001)(64756008)(66946007)(26005)(66476007)(478600001)(316002)(6486002)(2906002)(8676002)(41300700001)(5660300002)(8936002)(6512007)(38100700002)(82960400001)(122000001)(38070700005)(6506007)(86362001)(186003)(2616005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cGpremkrWm45YXhDTnMyYU9zUEFHaGhwNzllZjA4Tk8vZWVQd29oVk9pejRq?=
 =?utf-8?B?WFl6ZnVQQ3Q1ZktjZGhXVkwwcnpBbUFnbjZRb0tJSGtOMDJMUjBiVTBiZWFS?=
 =?utf-8?B?eWQrZkdSaDFEY2FrN1R4OXBmNTlUaVNLZ0hMK2g4Q1d3T3hWRGY4L3lvSGR1?=
 =?utf-8?B?MEhPNmJDeFgyZHFub1VTVy9rckJ3a3lwTEVhbXArOGpTbGJUYnFla3d4N2pZ?=
 =?utf-8?B?OTlUODVhMjNGQ1lSUFpkOHBZTFZFWGxFdzVkem9HYSszRHFGelVpVXBXclpy?=
 =?utf-8?B?emE2YXN5V1p1RmJvdmdpWjVDQ1NUNi9weCtXemNUeXdtVnZYeE80S2FGRUVp?=
 =?utf-8?B?WWd2SGtFRE1BUFl0ckhRUmdhTUt1d20rSnlEbWpONDZPUi9NVjVuZDlEbmFt?=
 =?utf-8?B?ZldjSUc2TFVOcVNjS1oya05vU3hXdTJkRkt6TVNzWkVFcmMwNTFsUzdoZXhq?=
 =?utf-8?B?TUdQTG8ycU52QzBxcDkwTlRucG5MNkFOMXFpd29wUXZxYXBVWk5wSmx2QWIr?=
 =?utf-8?B?N1BZZVM5VzZPNlZvOW5BdGsxMlNNTGdRemhGVjRDaVVCclcrV3lRM1ZYYXNq?=
 =?utf-8?B?cnlQakxVUVBObVM5NFJUTGRydEdVWXE4NC9wY1dzNEt0cDc3S0ZzeThXZnVm?=
 =?utf-8?B?VndWN0UwQ1FONWJ0NWo4TjVXRkVOQlhCZldxWENJV2w2SU5yTHhWazRubERy?=
 =?utf-8?B?U1RjdHdjdXc3VDkwa2QzMW9RSC9zUmF3OUJmRitTK2FXU2dydityZC9YUTgv?=
 =?utf-8?B?b3YwMnVoVjF6S1dNVW14YlRqdXpaeTJVaUJTdHdJV2pncDNsTVlRNVN1Tnd6?=
 =?utf-8?B?T0UycXdkcEJkQkRvMmRUdWN6SzhtMVBmS3VYMU9OVSsyV3ptTHpGYkwrUWE0?=
 =?utf-8?B?Tk9TWkRuT0VNZnhjSHoxcVFKdlVEdTdSdGlEU0xvYVc4YTRBYWFhSjIxUzBn?=
 =?utf-8?B?ZU56Y212SGRHQWtjRFBSd0ZqaHNoSzUvZ2JucUMzeGY5T0ZESjNicHVJbDFw?=
 =?utf-8?B?VTNURG9PNFVZNjhQVENKTmNaVzJhVWppWlZ4RFA4Vjl1cmJPcCtIcFU3N0Jt?=
 =?utf-8?B?eCs2R3E4aGZJazZFeEpPU3pTOFZpZU5Ud3V6MjBmRW1PODQ3WTgwTWhxSVph?=
 =?utf-8?B?NkRScy9wcmN3TThuUW5EOWVFTWtRYzZrN2VkTEJYbTR1Q0paVHRWN0gwRU1v?=
 =?utf-8?B?Zy82UmY2YjBUam1FNXNFYmdXU3RoWmJQUW9uU29mN0NDZHJQL1BtRzk5MkRa?=
 =?utf-8?B?WWQ5VC9pL3ZTOWJWa2Rpd1RPNzhTbnV2U3Q4Rmh6UWovQTV3cUxRV0NYZHRl?=
 =?utf-8?B?Y3Y2bC9zeXdNM1VrTVpiOFFsL3pVWk94dHJoYUZvcUpTTk1jTFdwenN6OG9i?=
 =?utf-8?B?em51SVpZM0hPcEpIaHRhL01ya2oxSDB4MDN0WXV5Um5YVDlFTHFkb0lld3ha?=
 =?utf-8?B?V2kxdy9CNDdjVkE1R3cvS2tKWU1vZkhkZnRXb2lDMGxhcEFZcUI5eE9CSFFq?=
 =?utf-8?B?Yk92Mk5ERC92YStJaEhMU2xmK0lmQVdGR0g5Z3dKTGVCRUhQZWVGSStlays4?=
 =?utf-8?B?U2VhcGZ3OE9lQVRadTdMYjdJYTZzYzFjOEZPMFZZOVpBNlBoTzlWYXQ0Zmpu?=
 =?utf-8?B?VGZ2NE50UnkwZHpocnlJejFXMmRUTk91bDZielRkYXRUcnZ1TG05VGl6SFQv?=
 =?utf-8?B?WWw2b21FNWJKVko0eWZLVHpxNzdUekNZWkFRaVkzRnpPZ2dSdVE3bGNFUFdV?=
 =?utf-8?B?NGk1TVZ6NmdySmZpUWdHVTBNeWJnVGZNaFQwMkh0UTU4a1FZSzdVVEJYOHRL?=
 =?utf-8?B?dXJWTVRWNExJRVFCQk5lZ1lxT3BZUWRTbXBKSG4wTlh5TFZBdExOY0xnaExF?=
 =?utf-8?B?c3psOFdTUGxBUDBONVdrU2QvMG1YejgxK1VNMzVXZHVuVmRVaG5UN3BKWVgv?=
 =?utf-8?B?WXRRZi8xL2ZtUmJjbjVWVitwNzRiUFNnSE9McVAvOFVWemhpd1NjVnRFSm1M?=
 =?utf-8?B?YkJqV05pOHFWQmFOVWxZR2FxZERpMzFJVUgvbHM3NWlzK1dzRXlFaWo4MU5m?=
 =?utf-8?B?SENlOTM2VVlyanBBRnpmN0U0eUg2SWtGdXNkQ3lsbmJ5aFlZNEVvNW03cDM4?=
 =?utf-8?Q?O7QmIrW80BzGgLyNNmHPQ4wwG?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C055D33DF6C153468B05E6ECDF38F82F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 237215b3-26bc-4431-a48b-08db7703ab69
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2023 11:43:04.7288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Oei4VzBSMYjZeBj4+mE4fLekdL5pAOffYHRKC1AwIdunP9LZcgzyeUf04V63OhBmzQk21xuElq7i7RXBbbalRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8400
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

PiA+ID4gDQo+ID4gPiBZb3UgY2FuJ3QgYnVpbGQgYW4gQUJJIG9uIGFzc3VtcHRpb25zLiAgRS5n
LiBldmVuIGlmIHVzZXJzcGFjZSAqaW50ZW5kcyogdG8gYmVoYXZlLA0KPiA+ID4gaXQgd291bGRu
J3QgdGFrZSBtdWNoIHRvIGNvbXB1dGUgdGhlIHdyb25nIG9mZnNldCAobWF0aCBpcyBoYXJkKS4N
Cj4gPiANCj4gPiBCdXQgSSBkb24ndCB0aGluayB3ZSBoYXZlIGFuIHdlbGwgZXN0YWJsaXNoZWQg
QUJJIG5vdz8gIE5vdGhpbmcgaXMgZG9jdW1lbnRlZC4NCj4gDQo+IEhlaCwganVzdCBiZWNhdXNl
IHRoZSBBQkkgaXNuJ3QgZm9ybWFsbHkgZG9jdW1lbnRlZCBkb2Vzbid0IG1lYW4gaXQgZG9lc24n
dCBleGlzdC4NCj4gSW4gZmFjdCwgdGhlIG1vc3QgcHJvYmxlbWF0aWMgQUJJcyBhcmUgdGhlIG9u
ZXMgdGhhdCBhcmVuJ3QgZG9jdW1lbnRlZC4NCj4gDQo+ID4gDQoNClN1cmUuICBCdXQganVzdCB3
YW50IHRvIG1ha2Ugc3VyZSwgd2hhdCBpcyB0aGUgY3VycmVudCBTR1ggZHJpdmVyIEFCSSAoYXJv
dW5kDQptbWFwKCkpIGZyb20geW91ciBwZXJzcGVjdGl2ZT8NCg0KSXMgaXQgIlNHWCBkcml2ZXIg
X3JlcXVpcmVzXyBwZ29mZiB0byBiZSAwIGZvciBub24tRUxSQU5HRS1yZXNlcnZlIG1tYXAoKSIs
IG9yDQoiU0dYIGRyaXZlciBfaWdub3Jlc18gcGdvZmYiPw0KDQpTZWUgYmVsb3cgLi4uDQoNClsu
Li5dDQoNCj4gPiA+IAlpZiAoZW5jbC0+aGFzX21pc21hdGNoZWRfb2Zmc2V0cykgIDw9PT09PT0N
Cj4gPiA+IAkJZ290byB1bmxvY2s7DQo+ID4gDQo+ID4gU29ycnkgSSBhbSBhIGxpdHRsZSBiaXQg
c2xvdywgaG93IGRvIHlvdSBzZXQgImhhc19taXNtYXRjaGVkX29mZnNlc3RzIiB0byB0cnVlPw0K
PiANCj4gRHVyaW5nIHNneF9tbWFwKCkuICBUaG91Z2ggdGhlcmUncyBhIHdyaW5rbGUgSSBpbml0
aWFsbHkgbWlzc2VkOiBpZiB0aGUgZW5jbGF2ZQ0KPiBoYXNuJ3QgZ29uZSB0aHJvdWdoIEVDUkVB
VEUsIGVuY2wtPmJhc2UgaXMgZ2FyYmFnZS4gIFNvIGVpdGhlciBzZ3hfbW1hcCgpIG5lZWRzDQo+
IHRvIGFzc3VtZSB0aGUgIUNSRUFURUQgaXMgY3JlYXRpbmcgYSBtaXNtYXRjaGVkIG9mZnNldCwg
b3Igc2d4X2VuY2xfY3JlYXRlKCkgbmVlZHMNCj4gdG8gaXRlcmF0ZSBvdmVyIGFuZCBjaGVjayBh
bGwgVk1Bcy4NCj4gDQo+IFNpbmNlIHRoZXJlIGFyZSBhZHZhbnRhZ2VzIHRvIHVzdWluZyBtbWFw
KE5VTEwpIHRvIGZpbmQgRUxSQU5HRSwgSU1PIHlvdXIgYmVzdA0KPiBvcHRpb24gaXMgdG8gZG8g
dGhlIGJlbG93LiAgQW5kIHRoZW4gdGhhdCBtb3N0bHkgYW5zd2VycyB0aGUgcXVlc3Rpb24gYWJv
dXQNCj4gdXNpbmcgbW1hcCgvZGV2L3NneF9lbmNsYXZlKSB0byByZXNlcnZlIEVMUkFOR0UsIGku
ZS4gaWYgdXNlcnNwYWNlIHdhbnRzIHRvIHVzZQ0KPiBmYWxsb2NhdGUoKSwgdGhlbiBpdCBlZmZl
Y3RpdmVseSAqbXVzdCBub3QqIHVzZSBtbWFwKC9kZXYvc2d4X2VuY2xhdmUpLg0KPiANCj4gZGlm
ZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2RyaXZlci5jIGIvYXJjaC94ODYva2Vy
bmVsL2NwdS9zZ3gvZHJpdmVyLmMNCj4gaW5kZXggMjYyZjVmYjE4ZDc0Li42M2ZiNDFkYTM1YWEg
MTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2RyaXZlci5jDQo+ICsrKyBi
L2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2RyaXZlci5jDQo+IEBAIC05NCw2ICs5NCwxMSBAQCBz
dGF0aWMgaW50IHNneF9tbWFwKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3Qgdm1fYXJlYV9zdHJ1
Y3QgKnZtYSkNCj4gICAgICAgICBpZiAocmV0KQ0KPiAgICAgICAgICAgICAgICAgcmV0dXJuIHJl
dDsNCj4gIA0KPiArICAgICAgIGlmICghdGVzdF9iaXQoU0dYX0VOQ0xfQ1JFQVRFRCwgJmVuY2wt
PmZsYWdzKSB8fA0KPiArICAgICAgICAgICB2bWEtPnZtX3Bnb2ZmICE9IFBGTl9ET1dOKHZtYS0+
dm1fc3RhcnQgLSBlbmNsLT5iYXNlKSkNCj4gKyAgICAgICAgICAgICAgIGVuY2wtPmhhc19taXNt
YXRjaGVkX29mZnNlc3RzID0gdHJ1ZTsNCj4gKw0KPiArDQo+ICAgICAgICAgdm1hLT52bV9vcHMg
PSAmc2d4X3ZtX29wczsNCj4gICAgICAgICB2bV9mbGFnc19zZXQodm1hLCBWTV9QRk5NQVAgfCBW
TV9ET05URVhQQU5EIHwgVk1fRE9OVERVTVAgfCBWTV9JTyk7DQo+ICAgICAgICAgdm1hLT52bV9w
cml2YXRlX2RhdGEgPSBlbmNsOw0KPiANCg0KSXQgYXBwZWFycyB3ZSBkb24ndCBuZWVkIHRvIG1h
cmsgImhhc19taXNtYXRjaGVkX29mZnNldHMiIGFzIHRydWUgaWYgdXNlcnNwYWNlDQp1c2VzIG1t
YXAoL2Rldi9zZ3hfZW5jbGF2ZSkgdG8gcmVzZXJ2ZSBFTFJBTkdFPyAgRW5jbGF2ZSdzIGJhc2Ug
aXNuJ3QNCmVzdGFibGlzaGVkIHlldCwgc28gdGhlb3JldGljYWxseSwgZnJvbSBlbmNsYXZlJ3Mg
cGVyc3BlY3RpdmUsIHdlIGNhbm5vdCBzYXkgaXQNCmhhcyBhIG1pc21hdGNoZWQgb2Zmc2V0Lg0K
DQpIb3dldmVyIHdlIG1heSB3YW50IHRvIHJldHVybiAtRUlOVkFMIGlmIHVzZXJzcGFjZSBwYXNz
ZXMgYSBub24temVybyBwZ29mZiBpbg0KdGhlIG1tYXAoL2Rldi9zZ3hfZW5jbGF2ZSkgdG8gcmVz
ZXJ2ZSBFTFJBTkdFLg0KDQpBbnl3YXkgcmVzZXJ2aW5nIEVMUkFOR0UgaXNuJ3QgdGhlIGJpZyBw
b2ludC4gIFRoZSBTR1ggZHJpdmVyIEFCSSBpcy4gIExldCdzDQpmb3JnZXQgYWJvdXQgcmVzZXJ2
aW5nIEVMUkFOR0UgaW4gYmVsb3cgY29udGV4dCwgaS5lLiwgYWxsIG1tYXAoKSBiZWxvdyBtZWFu
cw0Kbm9uLUVMUkFOR0UtcmVzZXJ2ZSBtbWFwKC9kZXYvc2d4X2VuY2xhdmUpIDopDQoNCkkgdGhp
bmsgeWVzIG1hcmtpbmcgZW5jbGF2ZSBhcyAiaGFzX21pc21hdGNoZWRfb2Zmc2V0cyIgd29ya3Mg
aWYgdXNlcnNwYWNlIHdhbnRzDQp0byB1c2UgZmlsZS1iYXNlZCBBQklzIChmYWR2aWNlKCksIGV0
YykgZm9yIGVuY2xhdmUsIGJ1dCB0aGlzIGVmZmVjdGl2ZWx5IG1lYW5zDQpIYWl0YW8gbmVlZHMg
dG8gbW9kaWZ5IF9BTExfIGV4aXN0aW5nIG1tYXAoKXMgdG8gcGFzcyB0aGUgY29ycmVjdCBwZ29m
ZiBpbiBvcmRlcg0KdG8gdXNlIGZhZHZpY2UoKSBmb3IgRUFVRy4NCg0KVGhlcmVmb3JlLCBpdCBz
ZWVtcyBtb3JlIGxpa2Ugd2UgYXJlIGNoYW5naW5nIEFCSSAob3IgaGF2aW5nIGEgbmV3IEFCSSkg
dG86DQoNClVzZXJzcGFjZSBtdXN0IHBhc3MgdGhlIGNvcnJlY3QgcGdvZmYgdG8gYWxsIG1tYXBz
KCkgaW4gb3JkZXIgdG8gdXNlIGZpbGUtYmFzZWQNCkFCSXMgZm9yIFNHWC4NCg0KKCBCZWNhdXNl
IEkgdGhpbmsgb3RoZXIgZHJpdmVycy9zdWJzeXN0ZW1zIGRvZXNuJ3QgaGF2ZSBzdWNoIGxpbWl0
YXRpb24uICBGb3INCmluc3RhbmNlLCBmb3IgYSBub3JtYWwgZmlsZSwgdXNlcnNwYWNlIGNhbiBo
YXZlIHR3byBtbWFwKClzIG1hcHBpbmcgdG8gdGhlIHNhbWUNCm9mZnNldCBvZiB0aGUgc2FtZSBm
aWxlIGJ1dCB3aXRoIGRpZmZlcmVudCBhZGRyZXNzLCBhbmQgZmFkdmljZSgpIHNob3VsZCB3b3Jr
DQpmb3IgYm90aCBtYXBwaW5ncy4NCg0KQSBWTUEtYmFzZWQgImhhc19taXNtYXRjaGVkX29mZnNl
dCIgc2VlbXMgbW9yZSByZWFzb25hYmxlIGZvciBTR1ggYnV0IGFzIEkNCm1lbnRpb25lZCBwcmV2
aW91c2x5IGl0IG1heSBub3QgZWFzeSB0byBkbyBmcm9tIFNHWCBkcml2ZXIuICkNCg0KU28gSSBh
bSBub3Qgc3VyZSB3aGV0aGVyIHRoaXMgYmVsb25ncyB0byAiYnJlYWtpbmcgZXhpc3RpbmcgQUJJ
Ij8NCg0KSWYgdGhlIGN1cnJlbnQgQUJJIGlzIHdlIF9yZXF1aXJlXyBwZ29mZiBiZWluZyB6ZXJv
LCB0aGVuIHRoZSAiZW5jbC0NCj5oYXNfbWlzbWF0Y2hlZF9vZmZzZXRzIiBzZWVtcyBpcyBicmVh
a2luZyB0aGlzIEFCSS4NCg0KSWYgdGhlIGN1cnJlbnQgQUJJIGlzIHdlIF9pZ25vcmVfIHBnb2Zm
LCB0aGVuICJlbmNsLT5oYXNfbWlzbWF0Y2hlZF9vZmZzZXRzIg0KaXNuJ3QgYnJlYWtpbmcgZXhp
c3RpbmcgQUJJLiAgQnV0IGluIHRoaXMgY2FzZSB3aHkgZG8gd2UgbmVlZCB0aGlzIGF0IGFsbD8g
IFNHWA0KZHJpdmVyIGp1c3QgZm9sbG93cyB0aGUgZXhpc3RpbmcgZmlsZS1iYXNlZCBBQklzOg0K
DQpJZiB1c2Vyc3BhY2Ugd2FudHMgdG8gdXNlIGZpbGUtYmFzZWQgQUJJcyBmb3Igc29tZSBWTUEs
IGl0IG5lZWRzIHRvIHBhc3MgdGhlDQpjb3JyZWN0IHBnb2ZmLiAgSWYgbm90LCBmaWxlLWJhc2Vk
IEFCSXMgd29uJ3Qgd29yayBmb3IgdGhhdCBWTUEsIGJ1dCB5b3VyDQplbmNsYXZlIG1heSBzdGls
bCB3b3JrIGlmIHlvdSBkb24ndCB1c2UgZmlsZS1iYXNlZCBBQklzLg0KDQpTb3JyeSBmb3IgYmVp
bmcgbm9pc3ksIGJ1dCBkb2VzIGFib3ZlIG1ha2Ugc2Vuc2U/DQoNCg0K
