Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33983C433FE
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Oct 2022 11:17:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiJLLRq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 12 Oct 2022 07:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJLLRp (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 12 Oct 2022 07:17:45 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFC1C1DBD
        for <linux-sgx@vger.kernel.org>; Wed, 12 Oct 2022 04:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665573464; x=1697109464;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jv3pv/fZm8riJCcHAce8WGzY+XJaHyN64RUeAnGkIxw=;
  b=Sm2dqQiwzz+BU5Ustit8c+hDOG2QxQke29bFOWsJ2J6yadafaQIwMp3P
   99ZLNOCtEPSaUk20wKbm2xJRhGfWMdt4S7mSicB/tUZls4fpN5SOIlJpO
   +bB78TH5k0yIODR3KUCy6EOXOT/CdlPIBIkX1j/Cwmghcio+Li/n0FhRP
   iCChJ1n5pPjByLFQeSOVgHYRpn96/hqc4RtbY7dAbuBtdymtNJ24bjnAH
   i8r93Sa+yhe2mluTTseikhSunlxVBYmVxYqwX6NmB7NfdXF5szOqrluy6
   stVHY+PnVkjruEbfor/pVQ2F50d2jLQk/TI5xw6i16bykoTt0rtQLzesS
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10497"; a="284491879"
X-IronPort-AV: E=Sophos;i="5.95,179,1661842800"; 
   d="scan'208";a="284491879"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2022 04:17:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10497"; a="577795497"
X-IronPort-AV: E=Sophos;i="5.95,179,1661842800"; 
   d="scan'208";a="577795497"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 12 Oct 2022 04:17:43 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 12 Oct 2022 04:17:43 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 12 Oct 2022 04:17:43 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 12 Oct 2022 04:17:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lHBdRQfcToDFZDDtd+WncM/cmGQ/0QSLDSy5ThDhCLVJ4bL+WHF1sMDRO3i+dzKhgzQYgJGJeciCD6KVAEiWYCTZ6zXyUjoN1af82qX6rn27jydFxpGvXS97oRbLFC+Rd6v+s3J12ATRJXzUxoyKzZVpMZcs99AK4M6T2iIrHJXRONqo0V8kXfpzEo9uTEwgacMV2mnE/JPYnW7exjHyNxShZCzYs6uzibs2aYereJmlJrykYmpfJsiAoHSKdt+ddm4HQXxw1xwJilxpiHkCw/DPzEpJyf7ENEDPEPfQKOGBz/eXp0t+2fFFX5fYud8ZbbgCYYBqaalG6a4jsRBOdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jv3pv/fZm8riJCcHAce8WGzY+XJaHyN64RUeAnGkIxw=;
 b=hxlokBO8+13p4fJMq9AhHXPlsuGYtCUq/2bMTByeWrzZsybge2PRZQS6qAQkqnWjE/KdU9+JNiwTudV6TjWZ0lt/yuHJi03idfBRgO1Bi2fLyllSFTapkb9j8diLcYEwl5rQR4Dujvc8JAQC1bll84FvITCj68TAR/8S7BWMmW1fHzLdaCnWr4Dyb1+vVJlNCbfve56wtl7evEsTDQ2tFAruhM6Z1fosNYv/nBJcYLQbd/X8CkKpAg4f1fYlT8aAm0hiSKzgbSrrmVSmwFGig6D9Db53QELA50iwgCN0w0AI5BCiFAY2Jtojsj7X2bWFbmRNqraigrXMyZTmymswyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM8PR11MB5574.namprd11.prod.outlook.com (2603:10b6:8:39::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.19; Wed, 12 Oct
 2022 11:17:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5676.032; Wed, 12 Oct 2022
 11:17:36 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Li, Zhiquan1" <zhiquan1.li@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "Du, Fan" <fan.du@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>, "bp@suse.de" <bp@suse.de>
Subject: Re: [PATCH v9 2/3] x86/sgx: Introduce union with vepc_vaddr field for
 virtualization case
Thread-Topic: [PATCH v9 2/3] x86/sgx: Introduce union with vepc_vaddr field
 for virtualization case
Thread-Index: AQHYzLsLt7qgxIs35EuzmVJ46fsmt64IYWMAgABvhoCAAIhVAIAA90YAgABueQA=
Date:   Wed, 12 Oct 2022 11:17:35 +0000
Message-ID: <23065b3710d794a73edd6658f0a32dfe8f72b4cd.camel@intel.com>
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
         <20220920063948.3556917-3-zhiquan1.li@intel.com>
         <f6180914-2b63-29dd-8dc3-de48c4197769@intel.com>
         <540df1d4-d784-b33e-e1e3-573aa5f804c6@intel.com>
         <277c494c-7e55-2d73-dbf3-7a841836a395@intel.com>
         <2dd703b6-66a9-0a35-b02e-6a66e356277f@intel.com>
In-Reply-To: <2dd703b6-66a9-0a35-b02e-6a66e356277f@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM8PR11MB5574:EE_
x-ms-office365-filtering-correlation-id: 85ac42c8-722b-44b1-ac5d-08daac435d8a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /chchGi0TgS4LwrwMDwJM7hlUT2GV4AFkaGPuZj/l6qGCnNVNeo6vAAdGbD3dJONWO0blBygfSObVg4csnaFsgpL7UbLT7CTPRZH11IgaJwv2e3v2cdM2SjEGAThEP9lmARKNGwmuKa69Pu5SDJ7JKnl31NTcIDQJhU3mKfBLqML6RzxzRImMY7OS7xHptyZdluGQ6aFcsi7D2ExAV5ZetNG6lRZcxVBA7iNX0exWFBsrs5WLSy7GmntD1e7fZmV3PCyaQHiG3pKo1rx8sRISrGFfGqDwsYcEOvpf17mCCIjlwuqaingKhvRKsgsyt9A3Ijln9WO2gwCnc7Z8YHm+ktsDKgv3CpJfqbKMPi/2naUtNbe8hJJEcDfpNlXl0xJ6X+B67YB4ZfmqHYTLKsIyRHX4/NnQXIj7Bo3lEDAFfvLh0U2u1val4/zsbTHxSAd3AfVGAfXYyIN8ksjaD37uQuRtHEQxS9RyhBi9EWnjhEalFw24SvdPRBvzC4M3K2XeG5NcHkaG1BWxRAzYjVkhqHVuApcwIJeqeTa4fv1BTOtJkcEii4NxmOFHg3JWOvxFlumXOmTPIlBZT/U2g+Kr1ywtn4cM6j+zWYA4DyxKvO9VhmlpXzjmn4mmINMY8qa8Km9eZ3sBHFyGOcVutYmM/Ut81gGDRAuImMAmPf4zLb8dMOKIfkQdIf/A7GCm8PEA7lhsSMpNTDhNk+g0CvOv3bhqoxpAChAoADTv6vwGUVH78N7vTy6gX9mzBi9eZ3p/sIdH9/lV08vS3FbTCrhaQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(376002)(366004)(39860400002)(451199015)(36756003)(86362001)(5660300002)(38100700002)(82960400001)(122000001)(186003)(2616005)(38070700005)(2906002)(6506007)(478600001)(76116006)(26005)(6512007)(91956017)(66476007)(83380400001)(64756008)(66946007)(8676002)(316002)(66556008)(66446008)(8936002)(4001150100001)(4326008)(6486002)(41300700001)(110136005)(71200400001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZHhjdDZUeTQ2dHN1b3BiMm81SHZNeWs1Y2VjenVOWGIvVWNTWFhSdHJPQ2FF?=
 =?utf-8?B?emFLV0d1L1hmWWwrMjNPaVFlY3l5KzRFT3dPOWhVYW4rOVV0cWdhNHJvbGN0?=
 =?utf-8?B?ejN5Y1pBT2s4SFRzS1ovVlZjN1dPczR0a1BORGJZaDhWd2ViTldqR216cmlM?=
 =?utf-8?B?bURtbjdNZlZITGFVL1VnUERUMlFRaEtZWUIvL1k4Z25DOW93YW9WOWpwQ3N4?=
 =?utf-8?B?aGxFc1lhYVIvT0txYmhxcUVYVkRsWFZVbDdRTXdUcFdMclE1dldpcVhVd2Ns?=
 =?utf-8?B?L2NQQmdGeDhlYVJybFh1OS9yOFZmc3N0MFpONW5DT1ZNVkhSNUkrZVNGV2hu?=
 =?utf-8?B?am9XNnpzS2dzWkRnWmhrVk9ySWtoRGEzb3kvWWllbCt2UFQ1bEdpalFYRHZF?=
 =?utf-8?B?dHVkWC9FS3V3UURGbFVNclBGZzd6d1FCbDVFV0JKako1TUVCN1dlenozQkMv?=
 =?utf-8?B?WGZaeXVFMFNXaEFJeFR5S1BNSk1kUUJ6S2grcVdHZmJpVzdSYVNMODdaVldE?=
 =?utf-8?B?RHVCM0s3aTZRMjB3QU1qK2w3YUU5WkN6TWZibnY1OE52bTZnVDJheGZ5dStv?=
 =?utf-8?B?dXc5RGFVbldzVlhCM0ZVaU42NEc3cFF2ZzJBSkE0SUlmYW90akdFMG5lNjRS?=
 =?utf-8?B?UnUxTGpJbWd4cU5uWHZTb05mZ0prd2ZrSHFGR0hIWVplWWxXWGh4Q0ZlcmJ4?=
 =?utf-8?B?T3BxOGQ1ZmFpSXpVamVzOE5MUGl4NVI3dkhJM2xUVk55dXU1Zlp1RTZDVDM5?=
 =?utf-8?B?aG54bWJzTVA2NklSSWhxSkJyeVRaRXZFOUQ3RkRmQWxSYkZwWkFqMnRHR3Iw?=
 =?utf-8?B?d0RBTnNLaDlhaXU5cE5va1hEMTV5WHRzUU82OUV3UFZYQ25PNXVVb1MvSFhv?=
 =?utf-8?B?dzR1OTdIQ05WNTU2YXozSnk2UUhzNTkwUXpPMVpsQVljdzdjN1E3L0ZkUEdV?=
 =?utf-8?B?bUFYR09zRkpNTzhvWWxwT1BRMzNqYW41cS93cXhwKzVLSjg5V3FKKzNZeDht?=
 =?utf-8?B?OEhIVXRRMUdLUFB0UlcyclVoaU81VXJaMlJZZzVUZC9KaVpRdWZYWHBETXZK?=
 =?utf-8?B?VjBBdjduZmxBeHhqdTlZT0xzWVZNQUttNUJXcW9TaDUycElMeGN6WXBsMjE1?=
 =?utf-8?B?eVRVakxUM0Nzd1NZUnhwSnNnTDRzWlVhVXY3NUJYWmxzN21Yc01uN2VtUm1V?=
 =?utf-8?B?RlVTSFl4RVJxZkpXTG4xK3JiYWtSQlRMUksxYzVETkIyZ0FZSDVUdG04TkU0?=
 =?utf-8?B?YU5VRWxpb092aXNuT0R4VW1oaGx0WFZWeGNwU3RXQlptQjI1NDAyZHI0YUkx?=
 =?utf-8?B?cThUQU1KekVDeVl4ZGdZVDFyaUVPUVZPOHlqYm5OcTlReEZESkk4VGhSMi9Y?=
 =?utf-8?B?eUVWTjE3MjVWaUkxTnV5NEtBWlZBNEJuQ2VhME43OHB5aUV5UHhnam8yL1g3?=
 =?utf-8?B?RTlkM2ZPTmFJbHBKOTFoUmtZWWdtNmRQTUpUQU9Obk54M041ei8xRGV6TlJ5?=
 =?utf-8?B?S0tpWjRDMXZBSCtrdnB4d1B4QjVxaWhGMnVFVG1mNjJDYWNwbUovY1Bldlc5?=
 =?utf-8?B?Yzg3TUxSVFJsL0QxSmRiYjAzMGFiKzNJUUNlWENKK0k5eVdvT2cxd21mT1Vs?=
 =?utf-8?B?em04YzdMNFZkNjNLTVpaV041d2hXMU1MYkV3VzhrR0QwRjl5QlR4b3pYQTh4?=
 =?utf-8?B?TVhhdzBMVzhTaHRpWW40RG4wM3FFSDJvTTJKTjFUQTYzODBUVFBQOU90VWR2?=
 =?utf-8?B?ZDdKdkIyZGV4U2N2VEE2K3FUcU5nelV5ZUtxb1AxQWNKY21MSkgveVBPZ1h6?=
 =?utf-8?B?SWJDclBBY3ByY1JxQ3Aya3AwU2ZXQWxhOUdENHB2b3lHWGdWWktZeUdFSXJB?=
 =?utf-8?B?YUEzdy9WcUZmZ2l4Q251TGRYRU5tQVNzNTJ4TGR2QUxtWnRTcUtoR3R4eVcv?=
 =?utf-8?B?bXpVM3YyQmpjdmVIV3dySU01QkNLaUk5aE5WZnhGQjZ3d3NuaGV0bEgzKzF0?=
 =?utf-8?B?Z29RZldLMCtwa2lCeitGWkUvMm5EMjJvUzJ6NnhCU2VKMGcySjRYenpkU1RP?=
 =?utf-8?B?ZHEvUXM2SzRNTmdFbzdyT1NiWUNzVm5KT2lCbjQ3a2ZmczdDSldnSTFLUmgv?=
 =?utf-8?B?RkwyMmVKdStpMjc4bVFYbG5UcXFiazh0V1NwNmhIYXRjUmhNUXJXVW1LNXIr?=
 =?utf-8?B?NFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <02780CDD96B3264BA6755537A704087A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85ac42c8-722b-44b1-ac5d-08daac435d8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2022 11:17:35.8189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BJWpVrS8CvOORtFPuDuHq/7xFnCiQYACOjA3VYdSkwKv0AR8mdPzgQeaYS8JNprS1Toa6kBYN+xIRWRD6V9lag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5574
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gV2VkLCAyMDIyLTEwLTEyIGF0IDEyOjQyICswODAwLCBaaGlxdWFuIExpIHdyb3RlOg0KPiBJ
IGFkZGVkIG1vcmUgZGVzY3JpcHRpb25zIGZvciBtb3RpdmF0aW9uIGFuZCByZWR1Y2VkIGV4cGxh
bmF0aW9ucw0KPiBmb3IgZGV0YWlscyBpbiBjaGFuZ2Vsb2cgYXMgYmVsb3csIGNvdWxkIHlvdSBo
ZWxwIG1lIHJldmlldyBpZiBpdCBpcw0KPiBlYXNpZXIgdG8gdW5kZXJzdGFuZCBub3c/DQo+IA0K
PiDCoMKgwqAgV2hlbiBhIHBhZ2UgdHJpZ2dlcnMgYSBtYWNoaW5lIGNoZWNrLCBpdCBvbmx5IHJl
cG9ydHMgdGhlIFBGTi7CoCBCdXQNCj4gwqDCoMKgIGluIG9yZGVyIHRvIGluamVjdCAjTUMgaW50
byBWTSB0aHJvdWdoIGh5cGVydmlzb3IsIHRoZSB2aXJ0dWFsDQo+IMKgwqDCoCBhZGRyZXNzIG9m
IHZpcnR1YWwgRVBDIHBhZ2UgaXMgcmVxdWlyZWQuwqAgVG8gYXZvaWQgaW50cm9kdWNlIGEgbmV3
DQo+IMKgwqDCoCBkZWRpY2F0ZWQgc3RydWN0dXJlIHRvIHRyYWNrIGl0LCByZXB1cnBvc2UgdGhl
ICdlbmNsX293bmVyJyBmaWVsZCBhcw0KPiDCoMKgwqAgaXQgaXMgdXNlbGVzcyBpbiB2aXJ0dWFs
aXphdGlvbiBjYXNlLCBzbyB0aGF0IGFyY2hfbWVtb3J5X2ZhaWx1cmUoKQ0KPiDCoMKgwqAgY2Fu
IHJldHJpZXZlIHRoZSB2aXJ0dWFsIGFkZHJlc3MgZWFzaWx5IGFuZCBhdHRhY2ggaXQgdG8gdGhl
IGV4dHJhDQo+IMKgwqDCoCBpbmZvIG9mIFNJR0JVUyB3aGljaCB3aWxsIGJlIHNlbnQgdG8gaHlw
ZXJ2aXNvci4NCj4gDQo+IMKgwqDCoCBUaGUgdW5pb24gY2FuIHByZXZlbnQgcGxheWluZyB0aGUg
Y2FzdGluZyBnYW1lcyB3aGlsZSB1c2luZyBpdC7CoCBBbmQNCj4gwqDCoMKgIGFkZCBhIG5ldyBF
UEMgcGFnZSBmbGFnIC0gU0dYX0VQQ19QQUdFX0tWTV9HVUVTVCB0byBpbnRlcnByZXQgdGhlDQo+
IMKgwqDCoCBtZWFuaW5nIG9mIHRoZSBmaWVsZC4NCj4gDQo+IMKgwqDCoCBUaGUgY2hhbmdlcyB0
YWtlIHBsYWNlIHdoaWxlIGFsbG9jYXRpbmcgYW4gRVBDIHBhZ2UgdG8gYSBLVk0gZ3Vlc3RzLg0K
PiDCoMKgwqAgQWZ0ZXIgYXBwbHlpbmcgaXQsIHRoZSByZXZlcnNlZCByZWxhdGlvbnNoaXAgZnJv
bSBhbiBFUEMgcGFnZSB0bw0KPiDCoMKgwqAgdmlydHVhbCBFUEMgZG9lc24ndCBleGlzdCwgaW4g
cHJhY3RpY2UsIHN1Y2ggcmVsYXRpb25zaGlwIGlzDQo+IMKgwqDCoCB1c2VsZXNzLiBCZXlvbmQg
dGhhdCwgb3RoZXIgYmVoYXZpb3JzIGhhdmUgbm90IGJlZW4gY2hhbmdlZC4NCg0KVG8gbWUgdGhl
IGFib3ZlIGxhc3QgcGFyYWdyYXBoIGlzIHZlcnkgaGFyZCB0byBjb21wcmVoZW5kLiAgSSB3b3Vs
ZCBqdXN0IHBvaW50DQpvdXQgdGhlIGZhY3Q6DQoNClZpcnR1YWwgRVBDIHBhZ2VzJ3MgJ2VuY2xf
b3duZXInIGlzIG5vdCB1c2VkIHNvIGl0J3Mgc2FmZSB0byByZXB1cnBvc2UgaXQgdG8NCmNhcnJ5
IHZpcnR1YWwgRVBDIHBhZ2UncyB2aXJ0dWFsIGFkZHJlc3MuwqANCg0KKGFuZCBwZXJoYXBzIHNv
bWVob3cgdG8gbWVyZ2UgdG8geW91ciBmaXJzdCBwYXJhZ3JhcGggd2hlcmUgd2h5IHRoZSB2aXJ0
dWFsDQphZGRyZXNzIGlzIG5lZWRlZCBpcyBleHBsYWluZWQuKQ0KDQotLSANClRoYW5rcywNCi1L
YWkNCg0KDQo=
