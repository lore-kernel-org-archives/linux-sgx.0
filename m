Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC67AC4332F
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Nov 2022 10:18:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiKDKSc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Nov 2022 06:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbiKDKS3 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 4 Nov 2022 06:18:29 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC2229CA4
        for <linux-sgx@vger.kernel.org>; Fri,  4 Nov 2022 03:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667557099; x=1699093099;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2GNX5giyMhVy5FuX4Cam6DdjkYH6Z9P9XJOQ+ee9Gks=;
  b=SF6RlI5ORowVC/+He5Sp8w5tkeVUWe9g6ZjxpR2yPoTe1rvKnVJSiYaa
   W83XO28t3/wceLaooHqXcq0DT+G14IHl1xMaxnU8IczSBuwf5SHY5UjCq
   20xUTHhDOvHF6qbfD/wMDhHbvsVdoA7DY+659B3OLe/NkD4vE4d0zuSNe
   x3t1wVtT1ddDrcchyBxDWbQf27VNAhPX7Ja0prHejEz0fRSymb8poPNp9
   SbsHHz1+T7Do1dRHk4ly651ZsZTJMwoDhsqHF5aU90TaxTC3RtiH0cWIJ
   ePu18bkkQbbFFnjL/CIGxQE3GJyO3xJpWv/owxjR9f1TLY5QDw/yGgdn4
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="336635617"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="336635617"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 03:18:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="613018601"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="613018601"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 04 Nov 2022 03:17:53 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 4 Nov 2022 03:17:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 4 Nov 2022 03:17:52 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 4 Nov 2022 03:17:52 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 4 Nov 2022 03:17:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=butlMNN3ZOc7q/JcDjZ5aBItBylOh2EkQzQwMubvtF47uJA3GmGI3gVYa58/AP5/KkcjI851GRTs2DZUbJHmF4bSk77VDLzIjdOtRWEST8EeR/yVituffpR334js8bDz39hkpRqhCLg5G6mCJUebhXglHgv6XWb5TkjJmsf/Jy9c28MAivkIJAIiNv6XXh8rYmhblrR+iVQA+oyGX5eeFlpeo7+FevqfMANL7xTkoeDyvBTyuGgxV/eu9MKX2y/x3vGtBV6JGZiF+Q4rQ1wDWiRrNh/elxf/nz3wI/5O4O4vwWW9qdsNwboFNxHyttUkYcewtD6W8C2cXkXuS+7tzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2GNX5giyMhVy5FuX4Cam6DdjkYH6Z9P9XJOQ+ee9Gks=;
 b=SII2FthWaAtWiS6fF0FWgBReWvd0ORIzEGwZmExcyyGLnqmyY9+mF09bGXklipSfKh1EMviZnIvgghmGjnSOz2E8csWqhGizkfEqLMw9oO+w2l3TcMsWU15ZU2YYJ6r8AqC3e8rD8KYsxgonMH5mbK+Kv4Pp3Zxs1P8Z5dQshZmuoUWBYwc+duVxVuviDFWxYvpLEvN2uQo8i4kBHz1WVqPUT9kvm38TXpLaCnnc4rf+aeWDVkqfWsvaJU1DmxjDuutcZ+Uwt1SQEHR9QoU7JvE3txGRzbrN6mp7HF1ZIRoqmrTd3cICp96nwSqCJ+rBtz4vl+UbXBtRie1OCcwyaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BN9PR11MB5558.namprd11.prod.outlook.com (2603:10b6:408:103::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Fri, 4 Nov
 2022 10:17:50 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5769.021; Fri, 4 Nov 2022
 10:17:50 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Li, Zhiquan1" <zhiquan1.li@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@suse.de" <bp@suse.de>, "Zhang, Cathy" <cathy.zhang@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>, "Du, Fan" <fan.du@intel.com>
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Thread-Topic: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Thread-Index: AQHYzLsOovV5qYztIkquos7ZMS9Qjq4JWziAgAD86YCAAJ5RgIABk7IAgAARzYCAAGXuAIAAA7UAgAADhICAAAPHAIAAFAEAgAAE0QCAAAYhAIAIjmSAgAbrTACAAFHqgIAMhb0AgAVWwAA=
Date:   Fri, 4 Nov 2022 10:17:49 +0000
Message-ID: <65924f603f88462eae6edd5ecb9f56aec1be1864.camel@intel.com>
References: <42470b9c41adefd2d4b4c79a3b7b2963cd24f423.camel@intel.com>
         <4f82ec46-4c85-babb-38ea-a6ecc5e397a9@intel.com>
         <5ade54ce8e182307309426e1055dcc580c1dc5fc.camel@intel.com>
         <4930999a-888f-88bc-a05c-86762504f059@intel.com>
         <c8e7cff6f8d66ce4f8575caaf69f02b491ed7d90.camel@intel.com>
         <5afff147-dfb4-9033-6826-5965ba0bf3a0@intel.com>
         <061580727e503d092ca3867919fa0f26391568eb.camel@intel.com>
         <10c4b928a37fdf96df767fc7b8f1348f6af05984.camel@intel.com>
         <Y1WmZgqIkl8GkR/i@kernel.org>
         <e8f1e391-0362-33b7-aaf6-45a685eba0a4@intel.com>
         <Y2BsSCM1BWlsqPcK@kernel.org>
In-Reply-To: <Y2BsSCM1BWlsqPcK@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BN9PR11MB5558:EE_
x-ms-office365-filtering-correlation-id: f3416d3f-3cb6-4e16-4304-08dabe4dd3af
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4GZv32x312+Fq9FTxaIFCexX+5ts5RIv6HQIOelrA0CYrEnjxJVP3ScTAioSHKPJB1MG3EXpABTX0ZmiLma2XATPVu/rY371cOd39OC2GpNTlXjKI5pOZabwvkkaCd1B4naCD1xeMkN+DAdiXHUQoonXNZM5xyHqG7GaN0rfG2XmUF3ncFE/4t23jL9k6WP2mdodLvgUqwxuvlRUD3TrO2wqWox8Gsi8UiynozJjCjbZTBZDQZMc7xSdzEASszQ8C1Q44rGf9/SUE+nRKBvPG1HHspjpheUYFkkDSDFm2un5qh9OOQxakjjJddZ8UStcbnu+SCQwazsSWkGQCx0EscZ/ZpmAmP5RVg+YdhYvswxT5SApmYDhRXLDlLMDhX0zm1d8o+0sObtKzUgeHPmcwwGBf2KEyJ7Dh3sYy1wDKyCbBG5QfpLRWmrKfUbpWs5cOReAr8y53cGUDtVJycBV1zLnbb/j/8i4hcDg5KaDIabWYx657+mGHALd+A8CXe93ez725cT78CWLUIIJ5N1emLBQ42Kv73MMJGInXYvlF3jTgZy0apsSRMSC49wg6wgkPwq8RIzMTg0+++XJRAv4suVDvMiuKE13X2R1EKV18ccUClqaMjUPpdXXltVzWxO5sygxvpHEHs+9np1Dz0l5V9J4iciyaX5oHMBLupJk2d7VeaOc+aIPkUrCp1edEdoGId/vVsA5aXlOj9fIZ7YhMMMo/FByschFknSuxa8hgOJrWHmYZtSHQRgfqygrKRWZSqmAx4DGO+upX9vrMDzb2w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199015)(83380400001)(2906002)(66946007)(64756008)(6512007)(8676002)(66476007)(4326008)(76116006)(66446008)(66556008)(41300700001)(86362001)(38070700005)(36756003)(26005)(122000001)(54906003)(110136005)(316002)(38100700002)(82960400001)(5660300002)(8936002)(2616005)(6506007)(91956017)(53546011)(186003)(71200400001)(478600001)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3FDWDdKZXRJQTU0OEZDSko0ZU5RUkVyR05CSEh1dXZnRzBMdXdqODZVa1Rr?=
 =?utf-8?B?Zk0zbjIzVVV6N1RNNHloRlkvbHFjVm5CZ0orZDVtTUpmd1hSYzhqdGtzREts?=
 =?utf-8?B?WU1tK0RDSFpxYVFGSDlhMEVGS0VSSHN6eHFKMDlNV1g4Ykg2QWV4R051QXVN?=
 =?utf-8?B?ZkFJWHAra0JWRjJuTnJnNTNmbUpUSjdLQ0tySVNwUnlFcUlSMHJNaXBCdThG?=
 =?utf-8?B?dVArZit5b0svbzdQRjB5bEpsMFdEa0lLNGV5YStkWHA3YkZXT2FNQWpobHFF?=
 =?utf-8?B?YWlMbFVBVERLeG40RFF5M2wzS0JOaE5zbHo2bklLSit6TmdnenBZeHVvdTFC?=
 =?utf-8?B?YUhoc0F1Ykh5MWRRbUVYYXplZjczeXVlSFhHVVBUQ09KMFdNTzhVS0tHSTZq?=
 =?utf-8?B?cmVWQWI4QzVqQ3l6dmpnSHNzYlRGZUJTUUQ5TVQ4UUE0L3ZzSXB6NHN2SC9H?=
 =?utf-8?B?YlZoMVVJTkpJSXA1SjltWG91czhFNU5RQ003UzgveFAyRjJKM01wcGtULzNy?=
 =?utf-8?B?S3hYSG1RQlhxSDhhRCsvNFZnZmZqU05wZlo2YkdnM1NjbmdpQmNRMXBKRThG?=
 =?utf-8?B?eDFSNzgvNXlxbnBnQkQ3R0VQSVJxZEorZWVJdWtXbk9IYkNiZlc3RFdHSWc3?=
 =?utf-8?B?TCtsdjJHREl0OHZrY0gwclpjcTNCelA1VlBvTmhrK3RFTjYyZ2ppZ1d6L0xw?=
 =?utf-8?B?NEs1Qkd0N2hxOVhxMUo3NGtzZ3JGd1RPSUJZbE9tWTNuWXRKdWRKR0pIRFVG?=
 =?utf-8?B?bldpamlRS0tQSFdxQUZkOXd2Zm0yc0dFYVdhdUw2TkJrWGY5bW84S0tzL0h1?=
 =?utf-8?B?YkdGaFY5OWZsY3hZaW5nbDQwNEJXaGlOc2tFQS9zQ2o3d1BSeGh5Q0d6OUxK?=
 =?utf-8?B?TE5WQVJJZ3p3dHh5SGQ1ekpqbkcrcGYvWDBnbWljRjJkTTFsS0ZWWHZlNHJD?=
 =?utf-8?B?T3dyYkFmRHZDUmpJRTdKMWxHSFRlc3VkTW1aNnpPald5R3llcEZPaDhpck5r?=
 =?utf-8?B?S1VQK2IyaUVFVEhPQTdpQU9lTUV5TXVBTjB4V2IxQ2F5OXFrTFNkbkRGZ2Yx?=
 =?utf-8?B?ZHcwMmk0bFd3N1JraHFJSkFKSklRWWtjbjdZYWdETkR6TndFVjBWWndvQVN3?=
 =?utf-8?B?Nm80VkVsaGVzS0h3aHErMENDcUpCQjFKZUFiR0RxOUFRcXFHR0cwMGFWT3I2?=
 =?utf-8?B?akh1RkRVYzVLVjRkMkJmUXhwZGpBUG5rWi9hbWF5c3U0M0RSQmJxbVFuZGpB?=
 =?utf-8?B?UHRCL2tMMWZwa3JnSGxNbHBxMXNkbU1nM0dkVmVlcnVTVVpMelRYTjRhQVph?=
 =?utf-8?B?ZkF5dDFHSmo1V29HZ3ZkZG5TalJDTjNoMCs4RmFjZ2o1R0dwWUV5YWNRdDdt?=
 =?utf-8?B?WDlsa0duUmdtOFpqNXdvYi9lZWpmanZlMW1RUnBFT25LdklNenh3ZU5LOVph?=
 =?utf-8?B?Z09UeUttK2JJSHp5eEtkek5uMWErMlhaV2JYeUlCem1JZElmS1hKREZiU3Vn?=
 =?utf-8?B?UktPc0RlZW5acmpHazZvZHNQSExrY0J1Rldhb25PR0hTNjFhMnlqdzVZbkNU?=
 =?utf-8?B?bXB3czAvNUpSOUpjK3RLeTJZYjlaLy9JSWF5VkVocExUckp0RGp5RVdCMmow?=
 =?utf-8?B?R3pCaC85MUxYUWh0RWdwOWRodVRsb1BFWUoxTWMwUlNXdFNWOGRzSmlpQUlR?=
 =?utf-8?B?TEVXYWorbkt0SW5SellnUnFzem5zSU1Ya0xDYmcwcEhKTHQwdHFqZ2RhK2R0?=
 =?utf-8?B?N3FWMGVxSEZCQmdudFZZcWFGWnlyTzNCNzlWTVpFNm1LeUZoTkdPcmxXcDVT?=
 =?utf-8?B?N0VSdTZWOEdJT0JsaEtZQ1Z1bk16SkNpRUJyUnV3SlFpTjRxSDBaQ2Y4SnNm?=
 =?utf-8?B?a283bnplREg4MzRKMHdaQmRISXEzVWtZQnVMakN4QmNmaVBIWlVBYVBVMlNL?=
 =?utf-8?B?N3JRcUd2TWpCRm5EYk13WjVtcUZURHdUY3lQQnhLOGthTytXbzRGcy9uQVJR?=
 =?utf-8?B?RkRHNXFWSXJDSTdyekJUaTI0Ui94R1ZndVdrcVl2cnJwK0V4dWZVSXhsWEhp?=
 =?utf-8?B?RHRSN0ZkdVRPM0g0ZHNyVmZiZTBYK01XRE9pNktJOVdFQ0V1Z1dHMEhRVWc0?=
 =?utf-8?B?cmpEckRWcHArQUFVRDRYMGVrUnJmakpkK3VjajhjcXVjNkRUZFpUK2RjbG9T?=
 =?utf-8?B?Q0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E890A50FA07F44081D94A7ED83BF1FB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3416d3f-3cb6-4e16-4304-08dabe4dd3af
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2022 10:17:49.9271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0s6KZubvdxHJi9N9ZzxtBww8wVBbWJTZjwxZwdbmkxsuOZz/koQX890lncM9iFn1nBopcHXcZX6IFTD/MXqzuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5558
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gVHVlLCAyMDIyLTExLTAxIGF0IDAyOjQ2ICswMjAwLCBqYXJra29Aa2VybmVsLm9yZyB3cm90
ZToNCj4gT24gTW9uLCBPY3QgMjQsIDIwMjIgYXQgMDk6MzI6MTNBTSArMDgwMCwgWmhpcXVhbiBM
aSB3cm90ZToNCj4gPiANCj4gPiANCj4gPiBPbiAyMDIyLzEwLzI0IDA0OjM5LCBqYXJra29Aa2Vy
bmVsLm9yZyB3cm90ZToNCj4gPiA+ID4gQXMgeW91IGNhbiBzZWUgaWYgdGhlIEVQQyBwYWdlIGhh
cyBhbHJlYWR5IGJlZW4gcG9wdWxhdGVkIGF0IGEgZ2l2ZW4gaW5kZXggb2YNCj4gPiA+ID4gb25l
IHZpcnR1YWwgRVBDIGluc3RhbmNlLCB0aGUgY3VycmVudCBmYXVsdCBoYW5kbGVyIGp1c3QgYXNz
dW1lcyB0aGUgbWFwcGluZyBpcw0KPiA+ID4gPiBhbHJlYWR5IHRoZXJlIGFuZCByZXR1cm5zIHN1
Y2Nlc3MgaW1tZWRpYXRlbHkuICBUaGlzIGNhdXNlcyBhIGJ1ZyB3aGVuIG9uZQ0KPiA+ID4gPiB2
aXJ0dWFsIEVQQyBpbnN0YW5jZSBpcyBzaGFyZWQgYnkgbXVsdGkgcHJvY2Vzc2VzIHZpYSBmb3Jr
KCk6IGlmIHRoZSBFUEMgcGFnZSBhdA0KPiA+ID4gPiBvbmUgaW5kZXggaXMgYWxyZWFkeSBwb3B1
bGF0ZWQgYnkgdGhlIHBhcmVudCBwcm9jZXNzLCB3aGVuIHRoZSBjaGlsZCBhY2Nlc3Nlcw0KPiA+
ID4gPiB0aGUgc2FtZSBwYWdlIHVzaW5nIGRpZmZlcmVudCB2aXJ0dWFsIGFkZHJlc3MsIHRoZSBm
YXVsdCBoYW5kbGVyIGp1c3QgcmV0dXJucw0KPiA+ID4gPiBzdWNjZXNzIHcvbyBhY3R1YWxseSBz
ZXR0aW5nIHVwIHRoZSBtYXBwaW5nIGZvciB0aGUgY2hpbGQsIHJlc3VsdGluZyBpbiBlbmRsZXNz
DQo+ID4gPiA+IHBhZ2UgZmF1bHQuDQo+ID4gPiA+IA0KPiA+ID4gPiBUaGlzIG5lZWRzIHRvIGJl
IGZpeGVkIGluIG5vIG1hdHRlciB3aGF0IHdheS4NCj4gPiA+IEkgdGhpbmsgeW91IG1lYW4gdGhh
dCB2bV9pbnNlcnRfcGZuKCkgZG9lcyBub3QgaGFwcGVuIGZvciBjaGlsZCBiZWNhdXNlDQo+ID4g
PiBvZiBlYXJseSByZXR1cm4/IEkgZGlkIG5vdCB1bmRlcnN0YW5kIHRoZSBwYXJ0IGFib3V0ICJk
aWZmZXJlbnQgdmlydHVhbA0KPiA+ID4gYWRkcmVzc2VzIiwgYXMgaXQgaXMgdGhlIHNhbWUgbWFw
cGluZy4NCj4gPiA+IA0KPiA+IA0KPiA+IElmIHVzZXJzcGFjZSBkbyBzb21ldGhpbmcgbGlrZSB0
aGlzLCB0aGUgY2hpbGQgd2lsbCBnZXQgImRpZmZlcmVudA0KPiA+IHZpcnR1YWwgYWRkcmVzcyI6
DQo+ID4gDQo+ID4gICAuLi4gcGFyZW50IHJ1biBlbmNsYXZlIHdpdGhpbiBWTSAuLi4NCj4gPiAg
IGlmIChmb3JrKCkgPT0gMCkgew0KPiA+ICAgICAgIGludCAqY2FkZHIgPSBtbWFwKE5VTEwsIDQw
OTYsIFBST1RfUkVBRCwgTUFQX1NIQVJFRCwgdmVwY19mZCwgMCk7DQo+ID4gICAgICAgcHJpbnRm
KCJjaGlsZDogJWRcbiIsIGNhZGRyWzBdKTsNCj4gPiAgIH0NCj4gPiANCj4gPiANCj4gPiAtICJ2
ZXBjX2ZkIiBpcyBpbmhlcml0ZWQgZnJvbSBwYXJlbnQgd2hpY2ggaGFkIG9wZW5lZCAvZGV2L3Nn
eF92ZXBjLg0KPiA+IC0gbW1hcCgpIHdpbGwgY3JlYXRlIGEgVk1BIGluIGNoaWxkIHdpdGggImRp
ZmZlcmVudCB2aXJ0dWFsIGFkZHJlc3NlcyIuDQo+ID4gLSAiY2FkZHJbMF0iIHdpbGwgY2F1c2Ug
YSBwYWdlIGZhdWx0IGFzIGl0J3MgYSBuZXcgbWFwcGluZy4NCj4gPiANCj4gPiAxLiBUaGVuIGtl
cm5lbCB3aWxsIHJ1biBpbnRvIHRoZSBjb2RlIHNuaXBwZXQgcmVmZXJlbmNlZCBieSBLYWkuDQo+
ID4gMi4gVGhlIGVhcmx5IHJldHVybiAwIHdpbGwgcmVzdWx0IGluIHNneF92ZXBjX2ZhdWx0KCkg
cmV0dXJuDQo+ID4gICAgIlZNX0ZBVUxUX05PUEFHRSIuDQo+ID4gMy4gVGhpcyByZXR1cm4gdmFs
dWUgd2lsbCBtYWtlIHRoZSBjb25kaXRpb24gYXMgdHJ1ZSBhdA0KPiA+ICAgIGZ1bmN0aW9uIGRv
X3VzZXJfYWRkcl9mYXVsdCgpDQo+ID4gDQo+ID4gICAgaWYgKGxpa2VseSghKGZhdWx0ICYgVk1f
RkFVTFRfRVJST1IpKSkNCj4gPiAgICAgICAgcmV0dXJuOw0KPiA+IA0KPiA+IDQuIFNpbmNlIHRo
aXMgcGFnZSBmYXVsdCBoYXMgbm90IGJlZW4gaGFuZGxlZCBhbmQgIiRSSVAiIGlzIHN0aWxsIHRo
ZQ0KPiA+ICAgIG9yaWdpbmFsIHZhbHVlLCBpdCB3aWxsIHJlc3VsdCBpbiB0aGUgc2FtZSBwYWdl
IGZhdWx0IGFnYWluLiAgTmFtZWx5LA0KPiA+ICAgIGl0J3MgYW4gZW5kbGVzcyBwYWdlIGZhdWx0
Lg0KPiA+IA0KPiA+IEJ1dCB0aGUgcHJvYmxlbSBpcyBuZWl0aGVyIHRoZSBlYXJseSByZXR1cm4g
aW4gX19zZ3hfdmVwY19mYXVsdCgpIG5vcg0KPiA+IHRoZSByZXR1cm4gb2YgVk1fRkFVTFRfTk9Q
QUdFIGF0IHNneF92ZXBjX2ZhdWx0KCkuICBUaGUgcm9vdCBjYXVzZSBoYXMNCj4gPiBiZWVuIGhp
Z2hsaWdodGVkIGJ5IEthaSwgb25lIHZpcnR1YWwgRVBDIGluc3RhbmNlDQo+ID4gY2FuIG9ubHkg
YmUgbW1hcCgpLWVkIGJ5IHRoZSBwcm9jZXNzIHdoaWNoIG9wZW5zIC9kZXYvc2d4X3ZlcGMuDQo+
ID4gDQo+ID4gSW4gZmFjdCwgdG8gc2hhcmUgYSB2aXJ0dWFsIEVQQyBpbnN0YW5jZSBpbiB1c2Vy
c3BhY2UgZG9lc24ndCBtYWtlIGFueQ0KPiA+IHNlbnNlLiAgRXZlbiB0aG91Z2ggaXQgY2FuIGJl
IHNoYXJlZCBieSBjaGlsZCwgdGhlIHZpcnR1YWwgRVBDIHBhZ2UNCj4gPiBjYW5ub3QgYmUgdXNl
ZCBieSBjaGlsZCBjb3JyZWN0bHkuDQo+IA0KPiBPSywgbWFrZXMgc2Vuc2UsIHRoYW5rcyBmb3Ig
dGhlIGV4cGxhbmF0aW9uIQ0KPiANCj4gV2h5IHdvdWxkIHdlIHdhbnQgdG8gZW5mb3JjZSBmb3Ig
dXNlciBzcGFjZSBub3QgdG8gZG8gdGhpcywgZXZlbg0KPiBpZiBpdCBkb2VzIGNhdXNlIG1hbGZ1
bmN0aW9uaW5nIHByb2dyYW0/DQo+IA0KPiBCUiwgSmFya2tvDQoNCkhpIEphcmtrbywgRGF2ZSwN
Cg0KSSd2ZSBiZWVuIHJlLXRoaW5raW5nIGFib3V0IHRoaXMgI01DIGhhbmRsZSBvbiB2aXJ0dWFs
IEVQQyBieSBzdGVwcGluZyBiYWNrIHRvDQp0aGUgYmVnaW5uaW5nLCBhbmQgSSB0aGluayB3ZSBo
YXZlIG1vcmUgcHJvYmxlbXMgdGhhbiB0aGlzICJ3aGV0aGVyIGtlcm5lbA0Kc2hvdWxkIGVuZm9y
Y2UgY2hpbGQgY2Fubm90IG1tYXAoKSB2aXJ0dWFsIEVQQyIuDQoNCkZpcnN0IG9mIGFsbCwgaWYg
d2Ugd2FudCB0byB1c2UgZXBjLT5vd25lciB0byBjYXJyeSB0aGUgdXNlcnNwYWNlIHZpcnR1YWwN
CmFkZHJlc3MsICJtYWtlIGtlcm5lbCBlbmZvcmNlIGNoaWxkIGNhbm5vdCBtbWFwKCkgdmlydHVh
bCBFUEMiIGFsb25lIGlzbid0IGdvb2QNCmVub3VnaCAtLSBub3RoaW5nIHByZXZlbnRzIHVzZXJz
cGFjZSB0byBjYWxsIG1tYXAoKSBzZXZlcmFsIHRpbWVzIHRvIG1hcCB0aGUNCnNhbWUgdmlydHVh
bCBFUEMgcGFnZXMuICBTbyBhZGRpdGlvbmFsbHksIHdlIGFsc28gbmVlZCB0byAibWFrZSBrZXJu
ZWwgZW5mb3JjZQ0Kb25lIHZpcnR1YWwgRVBDIGNhbiBvbmx5IGJlIG1tYXAoKS1lZCBvbmNlIi4N
Cg0KU2Vjb25kbHksIEkgYW0gdGhpbmtpbmcgdGhhdCB0aGUgY3VycmVudCBhcmNoX21lbW9yeV9m
YWlsdXJlKCkgY2Fubm90IHJlYWxseQ0KaGFuZGxlICNNQyBmb3IgdmlydHVhbCBFUEMgcGFnZSBj
b3JyZWN0bHkuICBUaGUgcHJvYmxlbSBpcywgZXZlbiB3ZSBtYXJrIHRoZQ0KcGFnZSBhcyBwb2lz
b25lZCwgYW5kIHNlbmQgc2lnbmFsIHRvIHVzZXJzcGFjZSB0byBpbmplY3QgI01DIHRvIGd1ZXN0
IHRvIGhhbmRsZSwNCnRoZSBwb2lzb25lZCB2aXJ0dWFsIEVQQyBwYWdlIGlzIG5ldmVyIHVubWFw
cGVkIGZyb20gdGhlIGd1ZXN0IGFuZCB0aGVuIGZyZWVkLg0KDQpUaGlzIG1lYW5zIGEgbWFsaWNp
b3VzIGd1ZXN0IGNhbiBhbHdheXMgdHJ5IHRvIHVzZSB0aGUgcG9pc29uZWQgRVBDIHBhZ2UgYWdh
aW4NCmFmdGVyIGl0IHJlY2VpdmVzICNNQyBvbiBzb21lIEVQQyBwYWdlLiAgSSBhbSBub3QgZW50
aXJlbHkgc3VyZSB3aGF0IGtpbmQNCmJlaGF2aW91ci9hdHRhY2sgY2FuIGJlIGRvbmUgaW4gc3Vj
aCBjYXNlLCBidXQgaXQgc2VlbXMgdGhlIHJpZ2h0IGJlaGF2aW91cg0Kc2hvdWxkIGJlIHRoZSBL
Vk0gdG8gaW5qZWN0IHRoZSAjTUMgYW5kIHVubWFwIHRoZSBwb2lzb25lZCBFUEMgcGFnZSBmcm9t
IGd1ZXN0Lg0KQW5kIGlmIGd1ZXN0IGV2ZXIgdHJpZXMgdG8gdXNlIHRoaXMgImd1ZXN0J3MgRVBD
IHBhZ2UiIChHRk4pIGFnYWluLCBLVk0gc2hvdWxkDQpraWxsIHRoZSBndWVzdC4NCg0KSGkgU2Vh
biwNCg0KSWYgeW91IGV2ZXIgc2VlIHRoaXMsIGNvdWxkIHlvdSBhbHNvIGNvbW1lbnQ/DQo=
