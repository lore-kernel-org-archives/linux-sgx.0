Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C5DECAAD8
	for <linux-sgx@archiver.kernel.org>; Tue, 13 Sep 2022 17:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbiIMRpd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 13 Sep 2022 13:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbiIMRo4 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 13 Sep 2022 13:44:56 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28B65E32E
        for <linux-sgx@vger.kernel.org>; Tue, 13 Sep 2022 09:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663087254; x=1694623254;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=F8FkV036w1DVXijp/tfd614gHkbuoGeveKVm2CqcCZ8=;
  b=J1kdjrHHux/2kx+s8+gxB4UMnClGDGk7WdMmkEYhNeiD7JaIVprcytLM
   KT8yfSHDWhtVNmxybpR1mUPpGrTCqRrD5xIAPFSdg/9+R+2RTrD8ZI7+0
   Ym31j8g1AwZc3zTbJXzWDkN76DfPG/JVGOgOvW3PmkXOCo+3uXhpUbjNi
   K5ZXtoFZnjS9N1PsATsgfS0OOzmThy9Sb3d/ca4NxD8ybtoMDKbH4m0W4
   ynDL9yAWQabwSAucHxEb6W/BidshZADJ97hyWfeuN728nmx1DPObs9FLi
   o/C8cJ9clm3PHAohAZzqO5vTC83PjcWSrQjEyl2JHPQ1DGRiYP8bGoSHB
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10469"; a="362137792"
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="362137792"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2022 09:40:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="646999529"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 13 Sep 2022 09:40:44 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 13 Sep 2022 09:40:44 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 13 Sep 2022 09:40:43 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 13 Sep 2022 09:40:43 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 13 Sep 2022 09:40:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lH08bOH67vZrKNj+4pdAM5bChHGzwrlYpm91/TtWLu+ApBdf0b1bzllbuP+p+fkYXhHJORWNULFxjsQXex2JRJxDIlc1Q3rJBiSVrMDbWIpK0kqAwyN+6w8eCj9JrU14UZMZU+BkcB3Z5RJAGDcAi++KfscoXNlw59O9DVBCMvt2G4cORITGzvdXnMcaAKD6oU2uYKw5En1eXFiYr8l1nYlXYkxUOHvqLCszix+qxHgdoMdM0HOWoa5+eCVgzdtDS+ET+2Ysb5l7GBkupCc1jJkgz/d6dTOjp5kbHb7GkRvGl2cm87V65lEo8s2PGxaXyTYabHvQwDGpmzhTeaCoIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F8FkV036w1DVXijp/tfd614gHkbuoGeveKVm2CqcCZ8=;
 b=a4ljTeeqGr0eoAPno/t3CKOYkFQNIHYWzc7KwNm3CC6msAN7p24kyqOpbFgicu2IyjH3OZfZ7gUG9AFcnsdOgWYfogkQvNB5uuzD06H1UYfJs0jqdckKvXfGK/iIOpEysIANNQLjylds9PHS5a+t5jIlsRXFn6fBwcLdGPRIAf4mB6D/Dy00QIXxMGf++nOupdjt/spSzOGP03+jCeesfxPb16820HadEh5JUXvyAVgWZvrEEIub25BsrTdzIhJaU/5aTvXmUjADQczvAgNUm6MZ7aa4B1alqjset502kpwRv0EBXyB7m4SOyVgqui5lh4Pldz3kUhBNbxAxH0UQ+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6534.namprd11.prod.outlook.com (2603:10b6:930:42::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Tue, 13 Sep
 2022 16:40:41 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::e03d:fd3:dad2:2248]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::e03d:fd3:dad2:2248%6]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 16:40:40 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Li, Zhiquan1" <zhiquan1.li@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
CC:     "Du, Fan" <fan.du@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>
Subject: Re: [PATCH v8 2/3] x86/sgx: Introduce union with vepc_vaddr field for
 virtualization case
Thread-Topic: [PATCH v8 2/3] x86/sgx: Introduce union with vepc_vaddr field
 for virtualization case
Thread-Index: AQHYx3/ZdLlKhCLs8kWxrrt2OWd7663dkB2A
Date:   Tue, 13 Sep 2022 16:40:40 +0000
Message-ID: <df29d6be949983aae3330557845babb31cab8e94.camel@intel.com>
References: <20220913145330.2998212-1-zhiquan1.li@intel.com>
         <20220913145330.2998212-3-zhiquan1.li@intel.com>
In-Reply-To: <20220913145330.2998212-3-zhiquan1.li@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6534:EE_
x-ms-office365-filtering-correlation-id: 0bceecd4-c0bf-4674-daa6-08da95a6b1d2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JqOH73gpcm7SyvMJ3ezcFpD1ibMBWGl/K0DJEeC1riZACfXGszGroTlg5HtjDjL7mZNl3rHgP8cfaZBlucqJMX6WGOZtTV9xS15yXqq5jKrMptxKg7lgNiuK5wCSixOngP86B7al+nK0kwA/72PDNUHP4gxJw1tGlV90dr7Ma4tCj155yKy2ozlvzsba42g8J+iTs2HtWaq36LZpK75z9mp0IvW85hzei6hCZgVrLy5laW4/KkJ2hTk95Hz0YbGq8GCELHLKNkSctcwrlurB5W1GoBW3SrziDpPXmQ5vHqtiCNcWc0wuxAR/cc0D32oUKA1wdhON/rEd0xqvEBpMdEp/WWSBogorl0L1H2YgK1HTZaOowTnEbZCfNTU20PY2hzx3D8Q1Z5xT2KsTVAynIkr/Cm3ArcuZh416CPD088SdgZF7NkhmDNmtgTNtsBq0tGL+uTFuJLlcF/kIurFtY1ErCLcDi993iB9PzFnZi19qGgNmAg430rB/0F8rwfjFbO1Q60niexm4rWFjecenFtszi6TGWgLWWSz6gDW6KsGKeJbxGBgatalmBCDZ7lmcjSc/q6ttjUlP2iwfAPq6Gtfv/JTIc1+53j7j6oV3kUTLHtyl7uykZcmAvEivvt0L3re5RwZbFO+pTE6gxviRGwvwBEFqAEpTKL7PCQmKSX9hg0mEJZ0sBuZ/SH6CcM8Fkbi1cZfNm9qBfHIomX7WN/YyNK8W0B76801lEnSRdnOCi+axn/77wyNg5scgNslz5YDZeMTduZ0tJgS2gKGQjg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(366004)(39860400002)(136003)(451199015)(2616005)(82960400001)(38100700002)(86362001)(122000001)(38070700005)(186003)(83380400001)(66476007)(66446008)(8676002)(8936002)(64756008)(66556008)(66946007)(2906002)(316002)(41300700001)(5660300002)(4326008)(6512007)(478600001)(26005)(6506007)(76116006)(91956017)(54906003)(110136005)(6486002)(71200400001)(558084003)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MVNHaVFSZEsycHRFS2dHV3ZoNlBZa1hFRmhMNlhFdkI1SWI4elQvbGZiTE1P?=
 =?utf-8?B?ZmgxUnhlU3NhR2NYRDdRZXpTbGh1M0ZreUk0aTR5UGxOWlpQWFZQdnlLKzBH?=
 =?utf-8?B?WmZVT3VBS2tkMWoyS1V0MzJxRExITERnVnlHRmJqZzhwblNIaHBvSDErRVJu?=
 =?utf-8?B?Qm1Jak9hRzVtWndsLzZRaU5EeWJ0RUhGcVJlMEdpaDRkaytJbTVWK3FoQ0N1?=
 =?utf-8?B?U3IxcTdsU0I0WjdDYVBZM0JhNHB4bFBtOFdOZlBoT1lENmVKTUVxWC8rRktD?=
 =?utf-8?B?b1ZaTjNZNHAwdHRRNDZnZm9mVGtvMTN0SzFKVXBjbzg2OEdhMXdkVTZDL3Ix?=
 =?utf-8?B?RWQ4VWhXalNUSldESWlhR0IwamZFdXhzK3VyYmNaU1hhYTY0KzFjaW5kRW93?=
 =?utf-8?B?bFRMNjM4ai9BbDZvdTVKK0ZrZmozN2gwTHJSWXFuUUVNQ2tYVmlNREZYZHk0?=
 =?utf-8?B?eCsvc1RvVTBCcHpLQW1nei9EMDdkdEk0c3l4eVZ0WmdKQmdwcldUbXFCcTR3?=
 =?utf-8?B?azJodEEyVnl6NDZMOU1jUDdneFB1ajJ5K3VkSUxDUENuQmJqYXJ6NDE0Q2FG?=
 =?utf-8?B?bFFiVTBESjhWdUtjaVRiYTN0ODUxNWVEOHFxYTNSMXhVSmtzVGxBdk1TL2RX?=
 =?utf-8?B?Q0QwY2orSEdRNC9RSGMxSUdWcG1MYXRCQlhIU2FJeFNJMGdyK1RFWkozcWU5?=
 =?utf-8?B?eEN1azI3SEFVOU1wcSt4K052Ulozejk3TkkyTXNXbHNVOVFCSTB3QndmdFQr?=
 =?utf-8?B?NkhvcURNTzl1OHJjL1BSM0Y5bjdoYnpZYUNwVGdXV2VKTUM5UFdsMXRtd253?=
 =?utf-8?B?bWQ2M1BZUFdscVlTbTdRQWFnT1ppUithbWp1Z3VORUlCR05BMXYxYXhNaytu?=
 =?utf-8?B?UElJcVpSakxrcmFITGNaQXByTjNlVWdLYmdORTRlL2hDL0FLQks4SE1MNFpl?=
 =?utf-8?B?Y2JhWUVRcXg4cjFNQ2grZ3Z5TzJIZW5rbmxnam1YTGw1blluQldQUmkyeEJU?=
 =?utf-8?B?elVydVdCTEttTWtCVjdHbC9EQTFmZ0VyUGRhMDZ3QUJmMmRVNll6U2tTRkZH?=
 =?utf-8?B?WTdzLzMwQklxODViK0NkQU0xSUtNUVRuK3pPcGd6aG51emxZQVpBL05GeHBK?=
 =?utf-8?B?UWo0OGVWRFB6UnM4aVh1d01WMW80L3dUMGd4a1pTYU13WWl0QWRWZktjTTVU?=
 =?utf-8?B?TnhjZllxa0p3SGg2MkdFSVJ3RHp2WW5WYmc3ZnZiNGp6a05EeVdsVGtNZW1z?=
 =?utf-8?B?ZTNKVlhQeG1SRlNKQjcveGU3ZERLemNNTFNhMHRFSjErdThNV3dIdGErc3dq?=
 =?utf-8?B?d0dSTHA5OGVkZzcza2xlRndxU1hPOWNBVFZHTEoxY09JQzRrQm5VOUp6Y2tx?=
 =?utf-8?B?ZXJNcnJjSUdhZjR5cUllZHk0ZVJFWWp5UTZQYnF6b0V3b1JMbnJUN3F5dHdt?=
 =?utf-8?B?bkpacm9MV05WNVdiVHdFQlEwN1NQTm5reXpEbVNnOEk4bFZ4MWw4Nm9sMFNy?=
 =?utf-8?B?b2ZkbzdIQjNrTHhNenF6dHpvRWEzdEFlQXpHZVliRHFjc2FDL2NPWVlTOHJt?=
 =?utf-8?B?TWNzUGhxOE1jOVdVWEJKTlJHbWN5QXdQU2puSVk0dlFFRG5NY29oTGx6enpl?=
 =?utf-8?B?U3dGUyt5VDV2Z3YySUtScEY5TFVKSStDSW5Jb0taOTlOcHZBQ0IrcnNkYy94?=
 =?utf-8?B?bTRmdnN3Y1RjNlF3M0VZVlcrL2hBODFLb0kvUEhsdVRrZmZXdVJDRGpTdVZl?=
 =?utf-8?B?YjZiNzdKUUg2a2hMQjhjaHU4cDgzODRWN1RTTlhsYWxYeVN2RVVSNzR5bkVQ?=
 =?utf-8?B?YlEydUNDczFjU05iNGZUUFI5RTNFNUN2L3dmUTQ1MVU3NWpNT0dMOTZ2MFRq?=
 =?utf-8?B?aVVRSkU0dGNlRVdQNHJSNnQyVm55clZ4Um52WitWMW5ZcEZlRzZiMDVMbUs5?=
 =?utf-8?B?SUttZmp2K0RWdFExcUlUNzlxblNXWDhLbVBQN0V2WGp3QWo0OCtDTEx0Wkw3?=
 =?utf-8?B?dnRWQXc4Q2kybXA4UlBabERmeXNJZjBtdE5IbUttUFR4NDJ6MlhIajNMVnh2?=
 =?utf-8?B?elBhdXlKZmZrNDI0R0hodmZDS3Jod1dsMURWbUZUNkRESzUyZG1PblY3SWlk?=
 =?utf-8?B?VlJsNmhpNjlWQVhNOTNHS1VDQWpWaWdxK21hbFJHVGNIaENyR0Y5SUZHc2kx?=
 =?utf-8?B?b3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <86BA54EF73913848A2D0E79F4C88026E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bceecd4-c0bf-4674-daa6-08da95a6b1d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2022 16:40:40.6217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3nTIFe64BlEHisz1eWPYf+Qgl3jzXdTdtAY/4gSR/DzTCV02wz9UIMhVtKpvv+wgrBqC0TWg0jBMnb/zMGyA0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6534
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gVHVlLCAyMDIyLTA5LTEzIGF0IDIyOjUzICswODAwLCBaaGlxdWFuIExpIHdyb3RlOg0KPiBS
ZXZpZXdlZC1ieTogSmFya2tvIFNha2tpbmVuIDxqYXJra29Aa2VybmVsLm9yZz4NCj4gQWNrZWQt
Ynk6IEphcmtrbyBTYWtraW5lbiA8amFya2tvQGtlcm5lbC5vcmc+DQoNCk5pdDogeW91IGNhbiBk
ZWxldGUgc29tZW9uZSdzIEFja2VkLWJ5IGlmIHlvdSBhbHJlYWR5IGhhdmUgdGhlIFJldmlld2Vk
LWJ5Lg0KDQooVGhlIHNhbWUgdG8geW91ciBwYXRjaCAzKS4NCg0KLS0gDQpUaGFua3MsDQotS2Fp
DQoNCg0K
