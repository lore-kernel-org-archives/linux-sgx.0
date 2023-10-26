Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E04AC25B48
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Oct 2023 21:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjJZVKp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 26 Oct 2023 17:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjJZVKo (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 26 Oct 2023 17:10:44 -0400
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB7793;
        Thu, 26 Oct 2023 14:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698354643; x=1729890643;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zq7sL/e1OckS/B/Chqp8Yf1F2Qe8rvXVumwaoHyptT8=;
  b=WAvgezpF9iy9MZmt4w1oFamnJTycAjFM5WznYxC3esfcrUIbCpPUvndR
   jJ9CtYNtzjveIf9m3d9GDaimEYffwXGNhSX1bAf8RDKg+UzFg8dsSR8Rx
   VMkkVHQjTAZP9kYfQ5IqbS3PwZRYMvmf0b1A7XMTHxp7ccmrjVOIv3STW
   TIwOwyneTGRKphXyYiY8zkbVHrSNg9FXyFYfuwjf69tl+8kXhlPZaBe2F
   RZ/asx3s49y8Ko9sR2lpwuz9Gx/2JRRupE7OOV6uxrNUCLK2iFrzz+VEQ
   UIP2cd9THfLJzv+Ly1zcx/ADoJflbMHZNSzfsMCSRCJbXteJT8riQs+ga
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="461480"
X-IronPort-AV: E=Sophos;i="6.03,254,1694761200"; 
   d="scan'208";a="461480"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 14:10:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="788632604"
X-IronPort-AV: E=Sophos;i="6.03,254,1694761200"; 
   d="scan'208";a="788632604"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Oct 2023 14:10:41 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 26 Oct 2023 14:10:40 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Thu, 26 Oct 2023 14:10:40 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 26 Oct 2023 14:10:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R7Gx+4G9VWsJAdIczTXsK5tzr3hzIWvb6/u1rO4IzkPb/BoaKs/Zwfi7UQDtAgYCmVkaQubqChrswvowFAjhEEhiQZSG2oUavn/EKOAxZfv6y2hVu7ktkyOyvNprB6DMwgZMsYO8tNo0L7aFoXZ2AsJmK3DkktHKs1fXWGH+rY2fmnKEXqIsxDZKI+WzzPhD6EXrZpklxhMIIxE9DM1cMoaZ8CXv5Y37yqx0HIGlTAnhKESgVdjFhKE1ec4iT+oaJ6hFVXyUDwUasXGRvBRZ23fQG3ZR4WEtXgJGhEMFU+/9f0q1fxeUPQscwxRCupK5S9UaW1a5OPetsQbmPntLQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zq7sL/e1OckS/B/Chqp8Yf1F2Qe8rvXVumwaoHyptT8=;
 b=cq9SUZYTYixE3Js5Ix5FT2+VoV5Kvt73SkyaRxY/5d9gldIiYGGtj6Un83HrU1NQGT0aKdFlAtHXZmq7JkUmBjsxPO0gAxVGv7bpNaScJ6CfhZbu4IHOK8uotDiwm9elFC/jg2G5K5cjEWmPzqSDDARx2k3uQwbkEtSY2NmSqJgFk+X8hwHVk2EmxT92nGrDivUn5cjm62zoKRiMTpyTLO7AzG0+XHrjelo+k0Q7aibgSfXgnWSZBJF5BvLMTruEjpUqbvyHNCrhJHDBiXNBFiD4C7xLMm3QaCnTOnA9cnggstUTF0Rzu6vhgPInlu1TW/07l4GwsrQnUXSP15Ow0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB8596.namprd11.prod.outlook.com (2603:10b6:806:3b5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Thu, 26 Oct
 2023 21:10:38 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::9704:bf7c:b79f:9981]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::9704:bf7c:b79f:9981%6]) with mapi id 15.20.6933.022; Thu, 26 Oct 2023
 21:10:38 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/sgx: Return VM_FAULT_SIGBUS for EPC exhaustion
Thread-Topic: [PATCH] x86/sgx: Return VM_FAULT_SIGBUS for EPC exhaustion
Thread-Index: AQHaAwC5HZkcwOUwLUG/lq0JhfdEybBamgKAgACeRYCAAQ01gIAAVjuA
Date:   Thu, 26 Oct 2023 21:10:38 +0000
Message-ID: <3193c6b8403b1cdcb3710bb6e5492948c8373615.camel@intel.com>
References: <20231020025353.29691-1-haitao.huang@linux.intel.com>
         <b8ec3061-436f-41d3-8bff-635a90774dfb@intel.com>
         <b389986bac0e65ce128c9553603436efdda24a58.camel@intel.com>
         <b709d680-5754-45ab-ae73-c812420f10e5@intel.com>
In-Reply-To: <b709d680-5754-45ab-ae73-c812420f10e5@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB8596:EE_
x-ms-office365-filtering-correlation-id: 874c4912-889c-4c9b-1dd7-08dbd668011a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LScFWF0SThGF8upUUizD1elSJFMqMcOfxZN0i8mIdOQ4bwAmYN4F2TFi7iaoF9naxYo0QrQE5D+mm5WXKS8RO50yxbYFht989pBJyjy+YMtLb6bsIB8YNKjYwTsKQdzOnyIFqF5NcO7sUugRPEJGeEzuu+hqtRh5/FB9AfJcI4vEgfntr4pZAfQtXp33gEScdDxIASapIChMPKDrSQx5gu9mqSLQW5CcXPcyE+VWBSwucce+aEQrrLeMduOXBn+cXmWWa9oV2pjR6W2961IcRVPzXtmPJ52FX1Z4JxRBWL3NRuCDmFbOimSaHN+rr3X+m5r8iE+gYblA1woVZTI8ktfwjqyQU/NCGhPUx+hXGCoEPv9Snd4ljm09QjQh9qc91cEPm6EGEqMDnh3sRMxI57WWooU00fcNu8Bl8eGr3XuBtljTBaSdb41JJSuNe+jBEqhSv6xFsAhrzKeozwEdUYpzxwMMPxEeYipKuRveF0dN06JZ9qmiMUqZxoSsIEXpyPLcJHfqGmjBobBlI/x7ZtexO0Y4Ar8fALaJiwLqQU/v9cczsLrMnVw0rrJLxsNyxXT6WMAiRM5ikwaEa3+pscFK+qLU6CzPZWnOZeQMWtROl/DKez8Sw5bxQDRJ4TPr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(396003)(376002)(136003)(366004)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(38100700002)(53546011)(6506007)(6512007)(478600001)(82960400001)(2616005)(26005)(6486002)(83380400001)(122000001)(71200400001)(38070700009)(36756003)(316002)(2906002)(8676002)(5660300002)(8936002)(4326008)(110136005)(4001150100001)(91956017)(41300700001)(86362001)(66476007)(64756008)(66446008)(66556008)(66946007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eHdyV1NVSUY3VFVpbzgvelpsY0NhNXpxaENpQ2ZNdDhzdWNVQ1ZXK1JqRlEv?=
 =?utf-8?B?T2JCeXlmVFArbG1nYkpXRlIrS0xvMnhFUHY0cEZtRDJ5bjVyN3RoSGlrWVZU?=
 =?utf-8?B?b2ZraEdzQmIzZm1QVU5rMVF1cjJMc1M0bVN6emRVTmdiVmlVL2lXc29aTjlm?=
 =?utf-8?B?amQ2aGo1ZUw3Qk9Zc3IvQitaT2pkTDFHam9VL2RveUpUYWV3SWkxZ2JEQnA3?=
 =?utf-8?B?dkZzQXdXT0JnOGFmUDFmQjJLTm40bDllSHYvazJzaytTQTJrdUlDTEp4VDdh?=
 =?utf-8?B?ZlFXdk9xS2VzVkxoYkFpeVg1aG9TdTZJblZ2T1RiTXFqdGlMK0tsaVhNTnVI?=
 =?utf-8?B?bnIwUHRyWVRTaE4vVXJHaTl2NnJYbnFBR1U2MVNjZXFpWkhEQlp3bm9pd0RP?=
 =?utf-8?B?TDVYQWU3Z2V2KzR4TTdmeDFWT05ua2d1N3JUYjh1K2pVV21UeWVrZzhRTWtQ?=
 =?utf-8?B?bndvZHV2WDFMZ2FUNERyRFgxbTlkckhTZWIrNUQ1UnNDblBLVUZWL2JaYlBq?=
 =?utf-8?B?cUZPeDA1MXF4TWJoaGpxRksvM01ZZEExbXd4TklrTFJvdmRXcVJFNmlRcWpL?=
 =?utf-8?B?dlFWNTdjVzEyNUhsYmlPQmJucm9UYi9EY2YwYmFLUkhZS29QK3JSblJkbTV4?=
 =?utf-8?B?QXFzR3VndG4wQU9CMUFLWk45VmtGaGx6QklBbGcrTXp5RnFkWmd1Zi9rRTQ0?=
 =?utf-8?B?eHUxUzVzM2dwM3U2eThwbGlTeXg3YmtQbCtrWTZUb0FPSmNIb0VEUWVDKzVl?=
 =?utf-8?B?bXcvMWE5VklzWFFDb0N0Yyt3aEJMd3R0WnFxZlpNZDRlNVBUZ0RhU0laa0E5?=
 =?utf-8?B?dFdCcDJIMXNzQXNTaE8xcW9MSTdEL3A4VER6ZldRL0lBYVFQbjRlNmdWWlNM?=
 =?utf-8?B?alZDWTBjdjh3WmlocGhiUmYxamV2eER1YUVpWHJDckxRMGQ0bTdWcklCTThX?=
 =?utf-8?B?T1dIdWdDWGwxZitjb2dzWEc4ejF1NHFDSnluQnZmeXJGODQrSkROSWtNZ0lx?=
 =?utf-8?B?ZEtzcHgxWHozbEFKSGplanFkYmRXZDR6WTdEWkdWVFl2OUtvWlNmNk85b2Fu?=
 =?utf-8?B?QVBCMFBEVit4bjVjeDM2VS9DakdsTXNsWnlJamdudDFsQlE4Q2tGTTdIZ2Iw?=
 =?utf-8?B?Q2gvY0JhU1QreW9aOGd6em9aUEZCSVJtSVNRL2kyaU5PODBJVzJWZ29DK3Rp?=
 =?utf-8?B?ZENhRytTS2dWd2ZPeDZ4dW13RGwzTC9LOWl0WlBJT3NzdWxLamtKZWN4aHdL?=
 =?utf-8?B?QlppaS84ai8ySTI2K09EMEp6TG5mcThrWENmNXVyUHhBM3lwTFhJN1JSRUVW?=
 =?utf-8?B?UHk5WmhoZmp3L1k5ZUU2SktSRFl3NEVHZ29YSmlacFlISHJvVWpDME1SNjhR?=
 =?utf-8?B?c28yV1ZUK0VwNDVoSFVUOXhtaEhsSEdYNkdQV013cFpUa09USEtSL0tHUnBB?=
 =?utf-8?B?OXZtZTJLejhabStRbEVKVU1jLzRUeThOOTl4L2JFNXM0TGFMeVl3SUt4cXpt?=
 =?utf-8?B?eHJKc1dpN28yelJDcytlL3ovQXJyMlR4bldYVzhEVjcvQkJ6QWdlQlZBalFs?=
 =?utf-8?B?UGhCSXFqZ1NNd25oeW1zZXZjTVFrOEdTNkc2RnlTbDhxNTZUL1pvYWJzSXF3?=
 =?utf-8?B?aHVaeXZ1YkxSeCtSUHJWOEpEelVPQVNBZEFLWlFOcWNVcHU2bDRreS9aR3NL?=
 =?utf-8?B?aklpbWNjTGhRZHlCNHphMGd4L1BuU2l6dzUzTHloRUwrZlQrOEI2VkFNbXYx?=
 =?utf-8?B?eGQzb1F2ajVDdlFyM1FkSTdjdzFiemlrL1FGanJzakJoWWNZRXY4QW5Ob1Z0?=
 =?utf-8?B?UjdBN1JLUzNpRXU0VDBpdlYrMlQ2c2VhYU9FcXB2aDZQeVk1a2k1OHljZFpT?=
 =?utf-8?B?ZzExT3BzV25QY1BKaU5aUnpzNUJmcFQ1SEQ5bGxXZVJ4UnZ5QjRXVUpjVnls?=
 =?utf-8?B?R2plUDZCQ1YxWUNzVS9MZlVrSEVObkRvYTBwcVRqaW9vcCt1bGFVcGNiL1pW?=
 =?utf-8?B?UmMvV3JUSlpqcVFjc05RbzE1b25rQnhwN1hyMkJTOFVpeDk5bldiczRObVdH?=
 =?utf-8?B?MFhvUHZGL0VES2xaOGtjdmZJUWxxSmZ2bTNjRDZNaFhLbVRReUNwaGJGUnhH?=
 =?utf-8?B?V3FFcFRiQjA4TkQxRCtsY2JEdkNVVmhyb09WV3phMXVPODRObXJoR1prd2N3?=
 =?utf-8?B?V0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB1482D04084B144A6298BF21D44837F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 874c4912-889c-4c9b-1dd7-08dbd668011a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2023 21:10:38.6457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0hDxE3cHvhYBlypdFtrvp1ABDj2ym/cyJQlWtCDPwKwB3ycXXBYvtaEHjl7eKU9lr1tN2Nvn64Z9oppDlWuScw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8596
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gVGh1LCAyMDIzLTEwLTI2IGF0IDA5OjAxIC0wNzAwLCBDaGF0cmUsIFJlaW5ldHRlIHdyb3Rl
Og0KPiANCj4gT24gMTAvMjUvMjAyMyA0OjU4IFBNLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IE9u
IFdlZCwgMjAyMy0xMC0yNSBhdCAwNzozMSAtMDcwMCwgSGFuc2VuLCBEYXZlIHdyb3RlOg0KPiA+
ID4gT24gMTAvMTkvMjMgMTk6NTMsIEhhaXRhbyBIdWFuZyB3cm90ZToNCj4gPiA+ID4gSW4gdGhl
IEVBVUcgb24gcGFnZSBmYXVsdCBwYXRoLCBWTV9GQVVMVF9PT00gaXMgcmV0dXJuZWQgd2hlbiB0
aGUNCj4gPiA+ID4gRW5jbGF2ZSBQYWdlIENhY2hlIChFUEMpIHJ1bnMgb3V0LiBUaGlzIG1heSB0
cmlnZ2VyIHVubmVlZGVkIE9PTSBraWxsDQo+ID4gPiA+IHRoYXQgd2lsbCBub3QgZnJlZSBhbnkg
RVBDcy4gUmV0dXJuIFZNX0ZBVUxUX1NJR0JVUyBpbnN0ZWFkLg0KPiANCj4gVGhpcyBjb21taXQg
bWVzc2FnZSBkb2VzIG5vdCBzZWVtIGFjY3VyYXRlIHRvIG1lLiBGcm9tIHdoYXQgSSBjYW4gdGVs
bA0KPiBWTV9GQVVMVF9TSUdCVVMgaXMgaW5kZWVkIHJldHVybmVkIHdoZW4gRVBDIHJ1bnMgb3V0
LiBXaGF0IGlzIGFkZHJlc3NlZA0KPiB3aXRoIHRoaXMgcGF0Y2ggaXMgdGhlIGVycm9yIHJldHVy
bmVkIHdoZW4ga2VybmVsIChub3QgRVBDKSBtZW1vcnkgcnVucw0KPiBvdXQuDQo+IA0KPiA+ID4g
U28sIHdoZW4gcGlja2luZyBhbiBlcnJvciBjb2RlIGFuZCB3ZSBsb29rIHRoZSBkb2N1bWVudGF0
aW9uIGZvciB0aGUNCj4gPiA+IGJpdHMsIHdlIHNlZToNCj4gPiA+IA0KPiA+ID4gPiAgKiBAVk1f
RkFVTFRfT09NOiAgICAgICAgICAgICAgIE91dCBPZiBNZW1vcnkNCj4gPiA+ID4gICogQFZNX0ZB
VUxUX1NJR0JVUzogICAgICAgICAgICBCYWQgYWNjZXNzDQo+ID4gPiANCj4gPiA+IFNvIGlmIGFu
eXRoaW5nIHdlJ2xsIG5lZWQgYSBiaXQgbW9yZSBjaGFuZ2Vsb2cgd2hlcmUgeW91IGV4cGxhaW4g
aG93DQo+ID4gPiBydW5uaW5nIG91dCBvZiBlbmNsYXZlIG1lbW9yeSBpcyBtb3JlICJCYWQgYWNj
ZXNzIiB0aGFuICJPdXQgT2YgTWVtb3J5Ii4NCj4gPiA+ICBCZWNhdXNlIG9uIHRoZSBzdXJmYWNl
IHRoaXMgcGF0Y2ggbG9va3Mgd3JvbmcuDQo+ID4gPiANCj4gPiA+IEJ1dCB0aGF0J3MganVzdCBh
IG5hbWluZyB0aGluZy4gIFdoYXQgKmJlaGF2aW9yKiBpcyBiYWQgaGVyZT8gIFdpdGggdGhlDQo+
ID4gPiBvbGQgY29kZSwgd2hhdCBoYXBwZW5zPyAgV2l0aCB0aGUgbmV3IGNvZGUsIHdoYXQgaGFw
cGVucz8gIFdoeSBpcyB0aGUNCj4gPiA+IG9sZCBiZXR0ZXIgdGhhbiB0aGUgbmV3Pw0KPiA+IA0K
PiA+IEkgdGhpbmsgSGFpdGFvIG1lYW50IGlmIHdlIHJldHVybiBPT00sIHRoZSBjb3JlLU1NIGZh
dWx0IGhhbmRsZXIgd2lsbCBiZWxpZXZlDQo+ID4gdGhlIGZhdWx0IGNvdWxkbid0IGJlIGhhbmRs
ZWQgYmVjYXVzZSBvZiBydW5uaW5nIG91dCBvZiBtZW1vcnksIGFuZCB0aGVuIGl0DQo+ID4gY291
bGQgaW52b2tlIHRoZSBPT00ga2lsbGVyIHdoaWNoIG1pZ2h0IHNlbGVjdCBhbiB1bnJlbGF0ZWQg
dmljdGltIHdobyBtaWdodA0KPiA+IGhhdmUgbm8gRVBDIGF0IGFsbC4NCj4gDQo+IFNpbmNlIHRo
ZSBpc3N1ZSBpcyB0aGF0IHN5c3RlbSBpcyBvdXQgb2Yga2VybmVsIG1lbW9yeSB0aGUgcmVzb2x1
dGlvbiBtYXkgbmVlZCB0bw0KPiBsb29rIGZ1cnRoZXIgdGhhbiBvd25lcnMgd2l0aCBFUEMgbWVt
b3J5Lg0KDQpPaCByaWdodCwgSSBkaWRuJ3QgbG9vayBpbnRvIHRoZSBzZ3hfZW5jbF9wYWdlX2Fs
bG9jKCk6DQoNCiAgICAgICAgZW5jbF9wYWdlID0ga3phbGxvYyhzaXplb2YoKmVuY2xfcGFnZSks
IEdGUF9LRVJORUwpOw0KICAgICAgICBpZiAoIWVuY2xfcGFnZSkNCiAgICAgICAgICAgICAgICBy
ZXR1cm4gRVJSX1BUUigtRU5PTUVNKTsNCg0KPiANCj4gLi4uDQo+IA0KPiA+IA0KPiA+IChBbHNv
LCBjdXJyZW50bHkgdGhlIG5vbi1FQVVHIGNvZGUgcGF0aCAoRUxEVSkgaW4gc2d4X3ZtYV9mYXVs
dCgpIGFsc28gcmV0dXJucw0KPiA+IFNJR0JVUyBpZiBpdCBmYWlscyB0byBhbGxvY2F0ZSBFUEMs
IHNvIG1ha2luZyBFQVVHIGNvZGUgcGF0aCByZXR1cm4gU0lHQlVTIGFsc28NCj4gPiBtYXRjaGVz
IHRoZSBFTERVIHBhdGguKQ0KPiA+IA0KPiANCj4gVGhlc2UgZXJyb3JzIGFsbCBzZWVtIHJlbGF0
ZWQgdG8gRVBDIG1lbW9yeSB0byBtZSwgbm90IGtlcm5lbCBtZW1vcnkuDQoNClJpZ2h0Lg0KDQoN
Cg==
