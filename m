Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E986C4332F
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Oct 2022 11:49:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiJSLtq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Oct 2022 07:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbiJSLs5 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 19 Oct 2022 07:48:57 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176052AD7
        for <linux-sgx@vger.kernel.org>; Wed, 19 Oct 2022 04:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666178869; x=1697714869;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tGG0BG1/TNklFcXkjh3pfssSgZMUXJ/47fHyVkjK3OA=;
  b=U8Pyrt+xw9hmjW0kvtpma3i9dGBavsSMGWXQRZBgjwh0XVSqoofrFTVY
   iSG/KwxyscVE8kZO5L04R1nQfiICC8Mi1BUbPZbRlEP/85UXopcFMgeQd
   UnvHtWd8eLT5JTPyV3MyudIwG5Pr2QbOtV7pjJGM08rIrcNnE1MPc/Ia9
   jSTIcqi9ZQlR81pl7RuBiE4GuDFeokrd2VWSmSxmYUd8Jp8XmI845moWy
   DxvStDykAIctjrUTM2anSXB1F+TevpKdtpLv2FDm52Hc85y9rdgfe7+Nj
   fLSUFA/S84sRFH4/vTypFVl1LEimYwp0s7za1w8FEK/hdVv0/dLCF2pjy
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="392677936"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="392677936"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 03:59:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="660295140"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="660295140"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 19 Oct 2022 03:59:25 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 03:59:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 19 Oct 2022 03:59:25 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 19 Oct 2022 03:59:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bH3ai8fcJxypDr6dcWfIWDnpGYC8ocTxF1NHXEFPtJmbQoJ+PUsjD6vwJMXxaFlj9FSu0OIvCyKRG+u0NQrBi9IMUvXTrbEDVuhuoDUecQZlp8dpBqDKYpEiqMAYcufVBV15UcNf1KjVTxqlMYCW5LcMgJUD6YiTzukElH3BnRpjtew0aWMtg+zm0vHXviZLK6kzC9gYOVdP8QJgFvJxMwpLhlXKLCxaymwUdiNjzdMy9rpoXs9CD8Pt5s6lwX0QaMLBsjSnESr5/1GF3wb9Ypk4XDHAPLZntnOgFXAc7FGFgDH79R7MovANH0oYQa4Ukiv4IwWAKSlkh/KHnFwBlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tGG0BG1/TNklFcXkjh3pfssSgZMUXJ/47fHyVkjK3OA=;
 b=WXfrUWXz2ioYMWAMiR/Xk+DUZDEwGk8xQESvsf1xZNJhl6J/h7n28pD8P6R8FxUIaP59g9keRGGikn15QYr9cbynWD3x0L7YO/ukvs+VzOZz//0k4EtMTajKClP+CqKXRvVRYmfFncyaWk2fJMhQkEsqy56/6J+KxMHnb+VPqnES8duW9qFex7ZptxVA2DSuB+m7eTZ14F5L6qU9RY3RwwN42sze4DeXv1+WxmfSiv+fL7PGb1uJDGMnmdYQ1tpXZIHcZqqbcnbyehzjWLaybcopshoH3Xc0ser0l8Nz1Zj2B93pVRbF6pEUASBwi/nvP4B7Cc86cCOtmlKkeMt81Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB6393.namprd11.prod.outlook.com (2603:10b6:208:3ae::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Wed, 19 Oct
 2022 10:59:21 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5723.032; Wed, 19 Oct 2022
 10:59:21 +0000
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
Thread-Index: AQHYzLsOovV5qYztIkquos7ZMS9Qjq4JWziAgAD86YCAAJ5RgIABk7IAgAARzYCAAGXuAIAAA7UAgAADhICAAAPHAIAAFAEAgAAE0QCAAAYhAIAIjmSA
Date:   Wed, 19 Oct 2022 10:59:20 +0000
Message-ID: <10c4b928a37fdf96df767fc7b8f1348f6af05984.camel@intel.com>
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
         <20220920063948.3556917-4-zhiquan1.li@intel.com>
         <b775a187-32ad-836f-557f-3486ef4ac8dd@intel.com>
                 <14fabc80-a9fc-05b4-eda1-62f2b265e66b@intel.com>
         <f8b49a6b-44ce-9477-b2ba-39abadfbd68f@intel.com>
         <fb885d7f-388c-6a53-798b-06805fefca3d@intel.com>
         <fc9ed3e0-94f1-0bbc-06db-fd14d41b7c21@intel.com>
         <42470b9c41adefd2d4b4c79a3b7b2963cd24f423.camel@intel.com>
         <4f82ec46-4c85-babb-38ea-a6ecc5e397a9@intel.com>
         <5ade54ce8e182307309426e1055dcc580c1dc5fc.camel@intel.com>
         <4930999a-888f-88bc-a05c-86762504f059@intel.com>
         <c8e7cff6f8d66ce4f8575caaf69f02b491ed7d90.camel@intel.com>
         <5afff147-dfb4-9033-6826-5965ba0bf3a0@intel.com>
         <061580727e503d092ca3867919fa0f26391568eb.camel@intel.com>
In-Reply-To: <061580727e503d092ca3867919fa0f26391568eb.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB6393:EE_
x-ms-office365-filtering-correlation-id: bed077ae-f2b5-41c6-d162-08dab1c0f9e4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FDylQ+Ar5ZdqKcRobIgXjCXEWMQmAKhAjG63eTlF/VbFRogKeT5yq7pTZdDHHYoWPYhBAxtwM18OmvQCoyrWqFKV0yxDCZM4L/SxxPvQBWuA+JJZ3BlboEwjEq4golIt2l1+TrTPEe4/NCCkPGR38q+kUvyCjZgM6hICgYNWWoD9e/yjGvBEF6kz3Int9y8cubKui1aZz6XwzMBnPqhM8meFsboMPyZDISLNQ6DRB8lhaDvwI1uC1OoSA8tnY5qzKwImJxzyA+VaM8Kc8fd4o9tE7m15b6HwxIuBsck11XomKRnM2/b/52+09vG++AHDhMzElH9jJNkGvSiFo0rcFNI9DnvDqNjVeMOWWaX3su8F6zJ+N+8Z8gbXC0huhox5vhlzD09/cSozcC17r2R6IGfR7kn1Qa8xsIHtk+T5m/XQZlaWZtSlh6NSgnlNZTapYV9cWRKsm25v9wlgKuKrjwqY3mkGJi6vDepAlbcYdBOoWzIgAZxiuKb/NzwK+EEhbbL1VkXHActHlwwSiiAM8XUe8PFYLUIk4lxbC4dzqCqmCnhEbIiAVDF7VWybATzsyc8hgnD4FsV1jxMHJM3C5mNIuHF3sJkIvoOx6BV2iKCkNZd3QX8fG/niDz+BbDmVWX5QZx2eoR3ZlOnS/2JjUAsFaCpk428R8mmt4s0dbluzjNa69pcmAdabZOuUqQIOvECkpzzxZYDXODJpADb8rwjbWXEjuqE7TPztm3w8k2Xm5U/nI0eO2GO8lPH/Cedop5ZePAoKMOrrlCtB5/pltg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(376002)(136003)(366004)(346002)(451199015)(66446008)(83380400001)(110136005)(316002)(54906003)(76116006)(66476007)(64756008)(4326008)(8936002)(8676002)(122000001)(86362001)(41300700001)(2616005)(36756003)(91956017)(186003)(66946007)(4001150100001)(53546011)(26005)(66556008)(6512007)(38070700005)(6506007)(2906002)(6486002)(38100700002)(5660300002)(71200400001)(82960400001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZXFXRkJncnFoYURRTm5MaGhJNmdqOUR3Z0FCYlZVakNRdU1RODdGZTlzL1Nv?=
 =?utf-8?B?dGFNMDlyWWlDell2VURKNjl3cWlFamRyS1ZHNWlLMGIxcU1NeWZLTFgxUGhB?=
 =?utf-8?B?OER0dVdTR083citjUUdZY2VpdnM4U3IwaktrckVLSmVmdndQMk82cmVWMUxu?=
 =?utf-8?B?ZjNBbFpQNmhtMmpZQUxFUVp2bFdHL2M4UG1DTzZhYlJIVzBrbVFjT3RhWjFN?=
 =?utf-8?B?N0J4YzBkcWwvSHhhRjlsUXFPOVBvM0lOZ2pHNUd4YnZFU0pUak1YeEFsNTE3?=
 =?utf-8?B?OFhhODdVeGkwTXE2cXNCR2FydXZqUFgvclNzUFowYWxJZ2FWb3hGM1N0d0FQ?=
 =?utf-8?B?ZEdkc3VyYm5hSmxQdjdMeE0vQzU3QmtzSTRyUU5MYjRPSjJFTDA0ei9MVzF5?=
 =?utf-8?B?VUh2bTJUNTF3dlVEb0FYbWRVaFZkbnlQV2V4ZDNzbVhxejJrbTlPZy84MHJu?=
 =?utf-8?B?UFNkbS9sNjZGQ01ncjdlMHZPa1VEZGNtTUlXZ0ZialVWaFBxS2E2L1NiWHl5?=
 =?utf-8?B?SUl6YUQwc0xtVmFvVlpYd1JGcmNFcHFuTmZhZmVLbWpCR2hUaG9LYmhqd052?=
 =?utf-8?B?Sjh6eFc4VVdqRTNScUNvYnkzUHUxNEZ6a0JleEo3bnRrN1ZaOE80VmRBTytp?=
 =?utf-8?B?SlE5czllRmZLdUJkOERGOS9NZFRTbjlqV3JIVmJjeG0zWFVrZnk2UnBhMXRW?=
 =?utf-8?B?eDQvbGhBaFd2Y2xuTjV6VUhIQ2thRURyaGNCc2Ivdk1pRnVyWXpXa3BjRFFh?=
 =?utf-8?B?bEhRVXB6eUxBODdYUGRmVEY4U1NBNSswM3lKU0pJeUVLSkZSbEI2UnZaQVBr?=
 =?utf-8?B?U3NGUGZST1dOamFKVVIvVmdJRVU3NU5IelZYSE14cjFaTHZFWUVRTDZXYkx3?=
 =?utf-8?B?bnpuTWdXdXphQ2l2RGZXZkhYR2d2RDJNcklheXFCQS9wVTJOTm0wNDE4Qi9L?=
 =?utf-8?B?WTR6QVZlL1RsVjVnc3NwZWRvWlA2aXdHSWxPa0pIcEN6WmNwWUdSVms5b3ow?=
 =?utf-8?B?c3RoekhNd2VnUFpyRm85RzI1R2lRNHFZczhWSzBoZzhFSFA0M0x3QlllSG00?=
 =?utf-8?B?Y1E2RXV4U1BydXN5c25xRTdFaDV0cEJTcVpvZzcxaHF1aTFkR0c4eCtOOWtZ?=
 =?utf-8?B?NFJ6Y2hjRmZnajUzQXFocWtPTHpSZndueVQwdjV3OCtiMDZMVjdCQTQ3RjlJ?=
 =?utf-8?B?OFZEelYxQXZUMDl6bElhd3FZUnJ6bVBlYUJGRXlFc2pJQkhIaThBTEhzSk9r?=
 =?utf-8?B?Mm1ScXE5Z2F3U3pVSDlBMXVkRDlnTzBKSDkwL0NuUHRXQkxyQzREelY3dEgr?=
 =?utf-8?B?VFdCcHExMGMrdlVoTkpFYUdiT0h6ZUdKenZJalhKdW9HVE5MZkl1ajJ2NExo?=
 =?utf-8?B?RzFTMmRNdVVHV1VqYXlqbU1QVUhZek8xdlRyTHdmWHFMeGdHcVE2N1pScGF2?=
 =?utf-8?B?NHFiQTFUTVdOTjlLd0VxU01CTkZ2SWg1RHhoT0NLajJQMDE0Z3E0cTZsMlFx?=
 =?utf-8?B?NU9ua3pqbUFNNlVOME1BK1g1R3hiSlEzZDI2cG1jOFRvSU9XMFJjd0J3ejY1?=
 =?utf-8?B?dEFUYUNKUm5PMWk3RWlNQkZDS3ZldXprM2tLSDlwRml6U0pvWDJKaE1hMGRR?=
 =?utf-8?B?bUhTc0dTMkhKQ3RsenZSL3hJakFLTC93N3ZTb3BVK3Z1SG04My9tZUFmQTMv?=
 =?utf-8?B?bGJrZSs1MURxNVM1a2F5b2I3Q2FXZFNWMXFSSkhDUENSZXMrWVJFcGRIOXhu?=
 =?utf-8?B?TTdHcWxocG5ZVDNqV29oSms0RGx5dkQvcjBydlZmT0N0V3FJaFhaZ05vTHNj?=
 =?utf-8?B?ZEQ2Q3BoMDFDU245M3NhZlZycHkyQ0FseXBlL1RheTVVMUZiMWNFSVNQUTlY?=
 =?utf-8?B?Mi82a2VjdW12dHlIM0dXakQrL2dFWnE2b2FITitCRS9Cclc0dlRHVVZ4WUVL?=
 =?utf-8?B?SExsaWFVcDBSaEFLdXNLVXUyRTAyY0Y1UUtXODFVKzBPa1lXWmNQTStaUzY4?=
 =?utf-8?B?bUYwTmpzbnVxRlhTNmNkWVh3QXFsdklBN1QxdDYvdnhUd0hqRDQ0UnVmTG9C?=
 =?utf-8?B?NjN5Wm5VVjZGenJqQmdhK3o0Q0tmSHZEVkF3am14N0c5NXpDVVJEbnRRVTF1?=
 =?utf-8?B?OCt2bVlDdEpmd1Z1K3hjMXpDc2lRdW1GNFpwaDNES1M2alJubzFRU3hQakIv?=
 =?utf-8?B?eFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D29C64EE058B94C8613A5D0B8A169F1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bed077ae-f2b5-41c6-d162-08dab1c0f9e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2022 10:59:21.0081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e4I2DY9DdbY5jTZYXf8p4mp3EmaYXwB9m/FNg9Xlaa4G198dRcVAyu8Ue1LYQrSM344zRk6pEqCrLqRvUC6InA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6393
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gRnJpLCAyMDIyLTEwLTE0IGF0IDAwOjE5ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBUaHUsIDIwMjItMTAtMTMgYXQgMTY6NTcgLTA3MDAsIERhdmUgSGFuc2VuIHdyb3RlOg0KPiA+
IE9uIDEwLzEzLzIyIDE2OjQwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+ID4gV2hhdCdzIHlvdXIg
c3VnZ2VzdGlvbj8NCj4gPiANCj4gPiBJJ20gZnJlc2ggb3V0IG9mIHN1Z2dlc3Rpb25zLg0KPiAN
Cj4gVGhhbmtzIERhdmUuICBJJ2xsIGRpZyBtb3JlIGFuZCBmaW5kIG91dCBhIHNvbHV0aW9uLg0K
PiANCg0KSGkgRGF2ZSwNCg0KTm90IHJlbGF0ZWQgdG8gdGhpcyBzZXJpZXMsIEkgdGhpbmsgdGhl
cmUncyBhIGJ1ZyBpbiB0aGUgY3VycmVudCB2aXJ0dWFsIEVQQw0KZHJpdmVyIHBhZ2UgZmF1bHQg
aGFuZGxlciBpbiBjYXNlIG9mIGZvcmsoKSAoc29ycnkgZGlkbid0IG5vdGljZSBpdCBhdCB0aGUg
Zmlyc3QNCnBsYWNlKToNCg0Kc3RhdGljIGludCBfX3NneF92ZXBjX2ZhdWx0KHN0cnVjdCBzZ3hf
dmVwYyAqdmVwYywNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3Qgdm1fYXJlYV9z
dHJ1Y3QgKnZtYSwgdW5zaWduZWQgbG9uZyBhZGRyKQ0Kew0KCS4uLi4uLg0KICAgICAgICAvKiBD
YWxjdWxhdGUgaW5kZXggb2YgRVBDIHBhZ2UgaW4gdmlydHVhbCBFUEMncyBwYWdlX2FycmF5ICov
DQogICAgICAgIGluZGV4ID0gdm1hLT52bV9wZ29mZiArIFBGTl9ET1dOKGFkZHIgLSB2bWEtPnZt
X3N0YXJ0KTsNCg0KICAgICAgICBlcGNfcGFnZSA9IHhhX2xvYWQoJnZlcGMtPnBhZ2VfYXJyYXks
IGluZGV4KTsNCiAgICAgICAgaWYgKGVwY19wYWdlKQ0KICAgICAgICAgICAgICAgIHJldHVybiAw
Ow0KDQoJLi4uDQp9DQoNCkFzIHlvdSBjYW4gc2VlIGlmIHRoZSBFUEMgcGFnZSBoYXMgYWxyZWFk
eSBiZWVuIHBvcHVsYXRlZCBhdCBhIGdpdmVuIGluZGV4IG9mDQpvbmUgdmlydHVhbCBFUEMgaW5z
dGFuY2UsIHRoZSBjdXJyZW50IGZhdWx0IGhhbmRsZXIganVzdCBhc3N1bWVzIHRoZSBtYXBwaW5n
IGlzDQphbHJlYWR5IHRoZXJlIGFuZCByZXR1cm5zIHN1Y2Nlc3MgaW1tZWRpYXRlbHkuICBUaGlz
IGNhdXNlcyBhIGJ1ZyB3aGVuIG9uZQ0KdmlydHVhbCBFUEMgaW5zdGFuY2UgaXMgc2hhcmVkIGJ5
IG11bHRpIHByb2Nlc3NlcyB2aWEgZm9yaygpOiBpZiB0aGUgRVBDIHBhZ2UgYXQNCm9uZSBpbmRl
eCBpcyBhbHJlYWR5IHBvcHVsYXRlZCBieSB0aGUgcGFyZW50IHByb2Nlc3MsIHdoZW4gdGhlIGNo
aWxkIGFjY2Vzc2VzDQp0aGUgc2FtZSBwYWdlIHVzaW5nIGRpZmZlcmVudCB2aXJ0dWFsIGFkZHJl
c3MsIHRoZSBmYXVsdCBoYW5kbGVyIGp1c3QgcmV0dXJucw0Kc3VjY2VzcyB3L28gYWN0dWFsbHkg
c2V0dGluZyB1cCB0aGUgbWFwcGluZyBmb3IgdGhlIGNoaWxkLCByZXN1bHRpbmcgaW4gZW5kbGVz
cw0KcGFnZSBmYXVsdC4NCg0KVGhpcyBuZWVkcyB0byBiZSBmaXhlZCBpbiBubyBtYXR0ZXIgd2hh
dCB3YXkuDQoNCk15IHRoaW5raW5nIGlzIHdlIGNhbiBqdXN0IGVuZm9yY2UgaW4gdGhlIGtlcm5l
bCB0aGF0IG9uZSB2aXJ0dWFsIEVQQyBpbnN0YW5jZQ0KY2FuIG9ubHkgYmUgbW1hcCgpLWVkIGJ5
IHRoZSBwcm9jZXNzIHdoaWNoIG9wZW5zIC9kZXYvc2d4X3ZlcGMgKGEgbmV3IHZpcnR1YWwNCkVQ
QyBpbnN0YW5jZSBpcyBjcmVhdGVkIG9uIGVhY2ggb3BlbikuICBLVk0gdXNlcnNwYWNlIHNob3Vs
ZCBuZXZlciB1c2UgZm9yaygpIHRvDQpzaGFyZSB2aXJ0dWFsIEVQQyBpbnN0YW5jZSBvdGhlcndp
c2UgdXNlcnNwYWNlIGlzIHVzaW5nIGl0IGluIHRoZSB3cm9uZyB3YXkuIA0KVGh1cyBlbmZvcmNp
bmcgaW4gdGhlIGtlcm5lbCB3b24ndCBicmVhayBhbnkgS1ZNIHVzZXJzcGFjZS4NCg0KRG9lcyB0
aGlzIG1ha2Ugc2Vuc2U/DQoNCklmIGl0IGlzIE9LIHRvIHlvdSwgSSdsbCBzZW5kIG91dCBhIHBh
dGNoIHRvIGZpeC4NCg0KLS0gDQpUaGFua3MsDQotS2FpDQoNCg0K
