Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5BC5EB64D7
	for <linux-sgx@archiver.kernel.org>; Fri, 30 Jun 2023 04:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjF3E11 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 30 Jun 2023 00:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjF3E1X (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 30 Jun 2023 00:27:23 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26403596
        for <linux-sgx@vger.kernel.org>; Thu, 29 Jun 2023 21:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688099242; x=1719635242;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7s+Rtt9c7uXFufnzYoFCodfdhphmnm7qxMcR2GLyKJI=;
  b=gJQQtedjb5Z44PPfuXVkf1l4Zq2QeyzJ9V8e+RifzJr3oCakuk0KyQcu
   d/qHtZ4SL9Yw9MwWSaljHoexuAL8mK1BMio5Os6Qv+DOsP2NzU0nQQq6W
   b3mMbdTvVDDvSbx8oK/z1yx/gIT9/sHeMtWrFon180R4CtjsaTlLSGArI
   Uowvo0CtKwxWaY4TnAJSyQ+5uD/5czfBl8a2917L6fqAQzwryGmdFWM0Z
   5r8SS50siihnw/24h6QqaRZGVL3V4Dip3GtGmHFACwFBOjPj4kTEs4mwT
   SWh7UYEJkNZ1LxmXLU71nYtPHfoVN1rw2SH3k626RW+BzjI9ignZnkixQ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="361155688"
X-IronPort-AV: E=Sophos;i="6.01,169,1684825200"; 
   d="scan'208";a="361155688"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 21:26:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="694901457"
X-IronPort-AV: E=Sophos;i="6.01,169,1684825200"; 
   d="scan'208";a="694901457"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 29 Jun 2023 21:26:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 29 Jun 2023 21:26:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 29 Jun 2023 21:26:45 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 29 Jun 2023 21:26:45 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 29 Jun 2023 21:26:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oHEEhZmxclBjwwtB/xmQ12u3mg+kvpUIGRkz1Jsv/hDc5zPIuF6hA5qfjcCEL3IF5Aq83voIBBWd8nv4dEks8ykd3WRRgu52iL0ATW2CuNRzTZH18lmxUwZYQhrXqDNUnQ/mzjqkWYx8pxXJbpEP4Q10iiQ7pgsZFWX1WN/OPiKO8OmtpruYfsRdZEUU4/yc2PqTFFc17WAPRZecUYYynZ9jm/ft3k45ZasndS88yaEVFe/cTt5aLfxKLbeNzRB4uTgGdI9b3orDktAGaWxTUOnEUKrLQxljJpvs0o7tSYLFgxgMgL3ZM7p+7FiM/ELOMzhDIp/5JUXDYA7AW0uemg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7s+Rtt9c7uXFufnzYoFCodfdhphmnm7qxMcR2GLyKJI=;
 b=DxYtSEpFex9i8MVO7WcB5aReEFOwlyIrM+/1XcUp1kAGZp7YZUhCGtySfu2bH3GWV8xLO6wwOLOPpExrK/IQfNHonbGg/y0ifcoKEcHayXxGdSe2h1Hj8sJ5toEGFBxLfpi/9y9I8vgefyUguPX2gKi5dEsMtVNeA9V7A4JMtnxBmou/ToMgC5GW1d3nY+n26RPjUrH322R6qAb/evOcp+1Rg/O8eFQ1TTR8eQdcqwlaNHAVnsC4FktaZIm+/Y7j03Kur+IS8/Jx6uH3H7sTFji1YdYU8OIFfwdsDqdcpZ6RJNSmb5lFtglnWHxZOJAGz51RwRjZJz8yRWdvm5hnGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB5168.namprd11.prod.outlook.com (2603:10b6:a03:2dc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Fri, 30 Jun
 2023 04:26:41 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Fri, 30 Jun 2023
 04:26:41 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "jarkko@kernel.org" <jarkko@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Topic: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Index: AQHZMtTIU78a0A3o9UaUPrwPUmNX5q7OTQIAgACfroCAABrOAIAADTuAgAAPNoCAAFobgIAAUaaAgABy3wCAA5ciAIAACKGAgAY6gQCAADnpAIAV3bGAgAGoFwCAALMwAIB7cDIAgA/0eQCAD7ESgIABMj4AgAQB+wCABWrEAIAAFpKAgAY6eYCAAN3pAIAANG0AgAE6tgCAAFmGgIAAzOeAgAC7/ICAAJiegIAAKFIAgAABCwCAACmMAA==
Date:   Fri, 30 Jun 2023 04:26:41 +0000
Message-ID: <385c1567cb9de5c3af79295acd1d5195ee20e60c.camel@intel.com>
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
         <50913a11353b17861c13ebb53305dd370c8b8b43.camel@intel.com>
         <CTPLZCBDSLUU.1CPR6DL9J2GE9@suppilovahvero>
         <CTPM273Z6Y6S.36I8EUC0M72B7@suppilovahvero>
In-Reply-To: <CTPM273Z6Y6S.36I8EUC0M72B7@suppilovahvero>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.3 (3.48.3-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB5168:EE_
x-ms-office365-filtering-correlation-id: f233aa26-c32d-49fb-f5c1-08db79223414
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sodysv/brxuqqOCgZlGhIsZnYyTrP3LO0T755sjmBjYTLfJ4qadzR8naalzo5ztJ+5/evlmgEMY2YUYngsTTnrJlaq3n44M1lhEpBE9iVifiulYwzPavk00M5WNJ3CKLO91FSYzbjReZOMryGHU9Fjc5hqjnzBAd9cRToMq6ah0+672TqGDFXIv2D6yJxK1wg/DL9YIgvphjyXjDljjn7Zi1cJAX6cd1V4KUTUK88TYfh3ktcRw3CB9rZo79QErC3ZR76BnDJJsZu8wkD5ABj03GxqgOq4K7cDF8dw3WVTmt+CPtDPGFNVPeRM87GVYdC8evwvCqgpsjjXEPF1sjzS9zHDf59PC9zwKXQ99RMRG4b+mRe7a+SoKaE6fAwVT7zKhYrEUqzt20jXmK8hAmGcUOzUKNdFUfV5iaMovHHnZoiSyOrLS7LcgrYNrxmGlSw1PnZ/8tn8u0fdAr2OThPYhCsV+6JVS8CXMdTzmUrbzCRY2+2EO0nHGrjV+ozNoO7DRgSq6rcWnnjozCgAkh1yXgD2kMST4eNboHUNMDgq6rN2ulsCCBeGfpA8s9PIUNk0+ji1AZMN0piTXHHjMe4oLSnoQXe2a7cOc6uwqd4PRm/2uXZ1ZEaele/Gla2sMi
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(366004)(136003)(39860400002)(346002)(451199021)(110136005)(54906003)(478600001)(6486002)(4744005)(38070700005)(66946007)(2906002)(186003)(26005)(71200400001)(66446008)(66476007)(66556008)(6512007)(64756008)(6506007)(316002)(41300700001)(76116006)(38100700002)(5660300002)(8676002)(8936002)(36756003)(91956017)(122000001)(4326008)(86362001)(2616005)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1lCNThwMkJ2TEVSenpYSkRoRWpUYzYzdE5Bak5nbVBaYmhaRlJ5Uk4xRit3?=
 =?utf-8?B?MEMxZkxEWjlxeXk4Y3FIUm5Tb1BwRXlTSng2WlM4U2hCcytLdmUxckc3bDZx?=
 =?utf-8?B?aFlRNnVNS01keXJZZHMva1cxM1pWL1lvQjFaNTUwMXZuTHpKVW9FL3Awd2t4?=
 =?utf-8?B?clFOajAzSU90bDdTYm9xK1hINzdqL1JZZzRvOEkxbWxPeUZ3RHdFeEhRM2x4?=
 =?utf-8?B?VGFvWXdGQWt2MmxxVG05YVZoclVsYVh1cVFJLzdYV09jdkJDcUMzaWdpbTUv?=
 =?utf-8?B?NUtyM0VqK2V6ckFlS1luTURWMTVjSFVLZFY3ck5hSEpNNHpVUGxmcTJORkVX?=
 =?utf-8?B?THAvWXZvTG9BdHF1Q2NJdVI0c3lKUXVreHZFUmRvNU9tV0Joa2l3WVNRNHBW?=
 =?utf-8?B?UTgxNXZRQmp3bjRCWmRwaDVRa1FJanoyL3FpeVo0U1BKNlBBamplMEpkekpw?=
 =?utf-8?B?SEMyNUVIeG1UdWg3Y1hXeGJUamcwUVpiYVBXVjB6Y0MrbENqY0Zobm8xYnpx?=
 =?utf-8?B?VEJiK3FsSEFJZW9kcDF2K003SzIxSUhPKzh4ODd0Z0h4UXFUeUhqeVliZzE1?=
 =?utf-8?B?djVFUEp6MXo1NjhMTWlCL3IraWV4bkdKZElzL2xxaDl3eG5RWWsvWStVenlk?=
 =?utf-8?B?U2ZIVU96QUg1MENpeVRsRGdQV2xEWG9mQjJUWHJMUi9mendMMm1IZ3B5WjZS?=
 =?utf-8?B?aTNHSjZMQkppS24rT2xUUEdhODM1QWRmQUhxRUJDSmV5Y0JEdTU3bFM1UC8y?=
 =?utf-8?B?OWFjOHBkdVUvRExJZXBMbTUySE1zRXNiRFlTTEREUUZvcVNsM1ZBQzhJMlhR?=
 =?utf-8?B?ZWovbjJaakhkaWRzTkFtRjIrUzUyYk1rNjlFTHV5TjBoekVMUDd0WnNwOHhV?=
 =?utf-8?B?MHJMbVpqaTIrU1ZieDlNMzhtdldIdjRkQ2FaS2lQaDB3TWkrN3ZQT01xZmkx?=
 =?utf-8?B?UGRtL0tqajBMZ3E4VEhwTVd0YWJMMnpXbTdDVTllS2ovRkxpZHJuU3RuWjRE?=
 =?utf-8?B?T1prcitKMzZnRUExc2tLZjB4bGtnTXFUOFBzNDYxM2ZSY1NpNEpOR0lzTnlz?=
 =?utf-8?B?eXc1ZUtRMnIwdGh2V3RVczNjTDZBWm9aSEJHUDJ2WktiQWpJT2JWTDhUbG5p?=
 =?utf-8?B?NFNQOG9hTGxsQTgrRk11Y0doakVoenVUQnJMUGRLb1Z5Q0hhdjJlYmI2WEJO?=
 =?utf-8?B?OGZOZS95eVQzVzRoQW9JSUFtS2tvVW9Ua0NMWFJZTzh1SC9CZWJCTFFOQWhC?=
 =?utf-8?B?ZTdvMGI5dDY4VTNLRksvTkRLdlRLc1AzUCtlUWVRSWVhSjN1TGFIV3JBVkNz?=
 =?utf-8?B?OXJvL1hhUXl2OVl4TjhhOXRncVA5dFYzQXpSQklBMDFwS0hIOHcrSGE5b29D?=
 =?utf-8?B?a08xdkZxNWJmV3YyemlqZTNYRFVYdy9STmtCV0JoT29uR1l6d3ptQldiczU5?=
 =?utf-8?B?THZKOS9URG9FWkJVQjltS0pSdnZRQytTQU9JbEZBVHE4QmRHUkNVQ1JLdExY?=
 =?utf-8?B?WlFsU0IzUGdtMW9QdkRjMG1wQ2RMWjBzWVdWMmtKT2xCTUlNcW9CNHAzNkd2?=
 =?utf-8?B?Qm4yZXBSUEx3NFFPbk1yajFpZEQ1bll4elBEZjBNRVgzY2dGR1daTXVGKysz?=
 =?utf-8?B?L0ZvUFc5a0FKSEhvS2hWVzAzNG5HK2JpUVdYdkJBT0ppZ3cxbGxCVnZqdEFP?=
 =?utf-8?B?eVhHQnJ2TnoyTEJmRW5HNUJFUGlZTUMxOFlNWTlZTFZScXhtcmh3VHQzNy9W?=
 =?utf-8?B?dkxMNktIOVhLZDVxbXRGb1Z2QWhDSEdwYklZTC9XMmxMaDdOZzg1bFFkQ0tP?=
 =?utf-8?B?d25BNFRoYVFxZW1ldlRuWmFDRy80OEhSR3FacXNHcC9QbDlOV3J2UHFRdGxC?=
 =?utf-8?B?bCtWZUlaNHVqNHE5UVhUWWs3akRWVmhZOE1UWHA4OTZSMVU5T3pDWlpQWnlV?=
 =?utf-8?B?Q2UxWGl6TG5WQTVrN0hQMkJjSmM4eWhnL0tRNzlVTmQ4S1FBK1RWTGYyRmpk?=
 =?utf-8?B?YkJOUm04TXI2VFUreTlqcGQ3OVo3UHZOaGsvakJSbm1rUjJSVlZhMlVCVDcv?=
 =?utf-8?B?aWtxZHZ6LzJCdmc1bVgwMnJEVzJPUW1ld1hPZXpBTU50bGNZS1RJOVZ5cFFR?=
 =?utf-8?Q?t+pJ54vdYwHWK/DLfqJpPdYqj?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B08E482E50A9AF4ABC75A25A12868E5B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f233aa26-c32d-49fb-f5c1-08db79223414
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2023 04:26:41.2454
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p8mglgPsH8VDaytLjF2jm2K5OLRpPNDwKok3Xfsj/oB640fO8h/s8nUHQZH52CTwd5lm6Zw66n3DuUgJnho2NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5168
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

DQo+IA0KPiBEb2VzIHRoaXMgbWFwIHRvIGFueSBvZiB0aGUgcnVudGltZXMgdGhhdCBwZW9wbGUg
KmFjdHVhbGx5KiB1c2UgZm9yDQo+IHRoZWlyIHdvcmtsb2Fkcz8NCj4gDQoNCkhhaXRhbyB3YW50
cyB0byB1c2UgbWFkdmljZShXSUxMTkVFRCkgdG8gc3BlZWQgdXAgRVVHIGZsb3cuICBGb3IgdGhl
IHBlcmZvcm1hbmNlDQpkYXRhIHBsZWFzZSBsb29rIGF0IHRoZSBjb3ZlciBsZXR0ZXIgb2YgdGhp
cyBzZXJpZXMuDQoNClRoZSB3aG9sZSBkaXNjdXNzaW9uIHdhcyBhYm91dCB0byBnZXQgbW1hcCgv
ZGV2L3NneF9lbmNsYXZlKSBzZW1hbnRpY3MgY2xhcmlmaWVkDQpzbyB0aGlzIHNlcmllcyBjYW4g
bW92ZSBvbiBhbmQgYWxzbyBmdXR1cmUgbGlmZSBjYW4gYmUgZWFzaWVyLg0K
