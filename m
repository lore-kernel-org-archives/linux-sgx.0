Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10BCDC00144
	for <linux-sgx@archiver.kernel.org>; Fri, 29 Jul 2022 19:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237332AbiG2TO0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 29 Jul 2022 15:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiG2TOZ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 29 Jul 2022 15:14:25 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC427D786
        for <linux-sgx@vger.kernel.org>; Fri, 29 Jul 2022 12:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659122065; x=1690658065;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kOhDrpHApX3WV5pXp4Yb/vzeYrR/x0RKD9Uq2ROkFs0=;
  b=avHmmTOk5W4shsmjWisWMURibVHn0p5pk5MHQW0Bo5sXx+JoXcXuoxSs
   6cMEeSiwo1KHrdiY6LavZ/7E4/gLo/x0cL3kt4OpGtXihYvewqTiGEjYa
   QS7/+czqPL86SjiPnuuAsx8nHyjUZog4+HTfn6njVwD4L+Z1d0SnHcifB
   P/w22eJLQYUdZcRg5UcP1sFaCtwxGtq69ijd2MS+eqg/pUqFDN/irJQ5U
   qO/SuujePXvXsyU8JOXATLFTknwXFq0IJqfnEG+mWNdNP6WC57aJylYS1
   3umyT8HT2vDtqcewBhstFKwPPo3qQDl+RNh0WPDF6NEqNMtFduyOM47cJ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10423"; a="288845164"
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="288845164"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 12:14:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="634227811"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 29 Jul 2022 12:14:24 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 29 Jul 2022 12:14:23 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 29 Jul 2022 12:14:23 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 29 Jul 2022 12:14:23 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Fri, 29 Jul 2022 12:14:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C7xBBKhULj9PGuR3H6RPbZJLfqYhat9yBjgaf+/RrPTL3z06+btf6pOpCxaHaDvNDidxn/c9cF4EO9Mz5bRQ+qc7yFkw6Irgqm6bJLMjFOaCu669tDS/69Qj8mbh/41EZairl5uFfINZyW8lQkEPNIifWjUpRnCuRAyAXNLzwdZ+Zv2j6NPbY2/Kho/ntudBhue52ZkRKnB2vDIkfQIgIloDrNkhsHwmMHS3Wy21xRIwOlVAYTNDZkHOQOOLcAoXGjxEWT1wQ5IkXN/AU/bhMANsytWJO+2WAhRaEQy2OR695sHD2jpvpr/L3U/dP/9jyjxOWx+xTHKYUv3AXBr/ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kOhDrpHApX3WV5pXp4Yb/vzeYrR/x0RKD9Uq2ROkFs0=;
 b=C2YYudpdqdbuPfzrVBoef2jo2t/ycvV9mjSX+uWPxoBKJd7jKcYO811cQ25dC5YwjUX3TH1pb3l4KQabWqPFg+RKdXhw+O5w2ULjlFVFWAJWWyYITG/ZrR3S2oob89VOt9zT/NhtQj83pu/T5mEi2GPLsp0bW1vGtos4nlEZt3ajjsPF/uV7lI2Q8Ixl9br1ikgZGPFjshxKS47vBhYb+G36ci9R/hYasJIOCe08WbpUAxvo/aDqIli3cy1s3WAFzbAySLcBG1JFHn2lktU9F9a7ifLabEzFcDMROHa7uDfZKqEyp8zPOPPnsVPVC8UvHCFpY2mOnUpjR9WzMaTl5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5591.namprd11.prod.outlook.com (2603:10b6:8:38::23) by
 BYAPR11MB2760.namprd11.prod.outlook.com (2603:10b6:a02:c0::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5482.6; Fri, 29 Jul 2022 19:14:16 +0000
Received: from DM8PR11MB5591.namprd11.prod.outlook.com
 ([fe80::b0ec:428e:d323:2bbc]) by DM8PR11MB5591.namprd11.prod.outlook.com
 ([fe80::b0ec:428e:d323:2bbc%4]) with mapi id 15.20.5482.012; Fri, 29 Jul 2022
 19:14:15 +0000
From:   "Dhanraj, Vijay" <vijay.dhanraj@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
CC:     "Huang, Haitao" <haitao.huang@intel.com>
Subject: RE: Support SGX2 V5: Seg-fault with EACCEPT for large number of EPC
 pages
Thread-Topic: Support SGX2 V5: Seg-fault with EACCEPT for large number of EPC
 pages
Thread-Index: AdijZFc8mcX23sq9QFWgzapOaA5FWAABTb0AAAVTAGA=
Date:   Fri, 29 Jul 2022 19:14:15 +0000
Message-ID: <DM8PR11MB55911E8F9DA739F215FD1D90F6999@DM8PR11MB5591.namprd11.prod.outlook.com>
References: <DM8PR11MB55912A7F47A84EC9913A6352F6999@DM8PR11MB5591.namprd11.prod.outlook.com>
 <1600d7b3-24c2-7455-4a7f-56366ccd03aa@intel.com>
In-Reply-To: <1600d7b3-24c2-7455-4a7f-56366ccd03aa@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ece977cd-ad56-4535-eacc-08da71968711
x-ms-traffictypediagnostic: BYAPR11MB2760:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nBvRCD2WAgmq8WyMWH2E3M8hok7cDk/w9yw9iD3kFGSLCnbs3O9fEkIe8tMZrCjdUsSVHjOcrnwtVYMtYMSLzED9dJjYU0Y9fdpkAEkdYrELeh+atQmRRZvsFx2ZYEkL3jwzSvZ2+IPnNyNVa3av7xg/nEzRh5vxG0GhRVWdPS+ge5ryFGMqAqDN9S8c3vGPk2ljiUBRRvIrtG5vScbGtc2smHl1YVbUL316eNtdjOILWDxgFshb8Uq1u+wN/NlC8xXhxYTlN0U8850nG4A5Q2JCpnmZwi0ax8oOy3W0j1lsrMu//6aRbegTBmv+LnXqQ4ProkVrReW36czAwHOFShpsUYyQKhJSyKQNzrSXrNh0xjwy6cdj8oWbDbr7Q60q90OvnfNSJbPTd8CeIMjdVBwgkYrpWdCFs/Y0/pAZ7JHdwB2Qk7Yx7xMve8g+0qETrLcZptfeoi8GRJSyNtaP4Rl9+m+sy76t9SdCkVbBE8Wxam8/l5E+5RicT0K68mjzjUY7/M2xpFgP5DTdX73JjKRoRAJ1ahLsMxlLfOOYTmgP/JQEJ+RFLUlJXn/OUJ1+bvuCnvqhmMAX3a0KutPhx+Hnubzew+9nts6yrBF6JE7ktCGnYeEgXl8UPBmcp06As6JCPO9PcHjiWr6qdFSu/B51Q1dsqsUKHL4kVJUMcNLcn2BeRiA1DH+LCRVU64nAYL9maMufEwKvCJooLBa2CRU9f0Jcgo84ZfnUw5BzI3WwdX7IpnIe90oyg9E7VRFOtDMU6/69WoOf+eOFyFJWMOkDLZjbwDKHu+zH+lM3kH5IfmxyGfXFFjVvrqXtKFJNIqCUcRNHW7CP0aXW7Nxl7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5591.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(376002)(136003)(366004)(39860400002)(66446008)(2906002)(55016003)(64756008)(4326008)(8676002)(66476007)(38070700005)(122000001)(8936002)(76116006)(66556008)(110136005)(5660300002)(86362001)(33656002)(66946007)(52536014)(41300700001)(316002)(186003)(478600001)(9686003)(26005)(71200400001)(7696005)(966005)(82960400001)(6506007)(53546011)(83380400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aWVod0lFMXZpMGloTzg3UlRzTWZJR2RHNG1qVzluTHJMVi9teHJkYlB5NDd6?=
 =?utf-8?B?TGYyOWRFQlA3Sko4UkdWUlN0dVpnVUdwSkNyS0xkWkxmWEFoVHNaNTZCSHZu?=
 =?utf-8?B?VDk3b1o1Y2xlQzdhNFgrMVFYM2lycWo2NytBbHNpcXJFLzltTHFZaVVOV1pv?=
 =?utf-8?B?UWNQRkVkL2d1dDRWTVNqRzFGck5PdTF1Z0tlS1Rudi9BTjEzRjMycjFwSTFa?=
 =?utf-8?B?THNpaFZtQytxK0VqL2JnZzl1M2lyYWZjdDhiTDhWcmZqY3V1Mlp2RHovU3NW?=
 =?utf-8?B?Z1ZOR1dXWm5udWVaSVFJV2oraWZYU1pDOWoxYWwxTVRpWWpOSEhTR0J5U1ZB?=
 =?utf-8?B?R0NIRVZObUpJSnJYQ1JnRHV4a1QxNk1mNC8wQTR3SERwb1VNMVNYSkZrOTlF?=
 =?utf-8?B?UzZ2WnlhTUtzOE5RNUhXMU90eXlXQ0VBemw2OW1HWVhoQkhPdDlUYWp1OXQ4?=
 =?utf-8?B?Nzl2TmZXM1lNMzBqaElHTzFkMFFEVWRxSzdpemQ4dTBSNmZXc3p0bGR2VnZx?=
 =?utf-8?B?VFJTMXdmRktmWFV5ZmEyLzBNLzg2am1WenB0STQwNW92VFdSWlpDSzM3a0RM?=
 =?utf-8?B?OGl0L0I2dXVsRUFEK2dqd2Z1NlVDK2RxN25hbnZZbjdZV1JpRy9aVWhmc0JM?=
 =?utf-8?B?MXgxczd0RmRIM2owbnBNU0V3KzNuV2dEUUhRcHkzZlJhRHFTNW1GOXVjSUZu?=
 =?utf-8?B?amg2RE5hbmEvc2ZGNDgwOWNDV29ManhlWFk5RW1LQUMwVEdVN2ZNMU95ZVRW?=
 =?utf-8?B?OFdNRnRUd2ZNQ3pBUTFueG16Z1JObHVZVHNabVhhQTQrWGZpM2ExSUpnb3Vp?=
 =?utf-8?B?aHFvTWNuK3FHYnZaWUNNMGZENUNpaCsxVWxqK20xbXhXWWE1YVFOTFMrL0ts?=
 =?utf-8?B?SERsb0JoQWFTbUx3S1ExTEgyNkx3aW9CQlV5ejB5NTJDWHhFbkt2RWt0Q3ZI?=
 =?utf-8?B?WEhBMzNVWlBXckx2KzJlbkFtd0xCNU5ialVvZElUaVZqaXpkSEU0QlIwdUFQ?=
 =?utf-8?B?VFNES29RdUE1a2NCbzhxeHVXMklLb2Z6b3UwQW4wTngwSkZLWEV0K2FrMk5U?=
 =?utf-8?B?WGlsU3lIYjJCZzlYK2o0Z3ZDd0ZzYURER2x1TzVKQ1A5dmI3WnhyQWxFRFdy?=
 =?utf-8?B?SjI2T1B4amd0RXEzaUtuTms2ejhWQ3hNZnZQR1ZLVkt1U2VtNW5oQi91aG1I?=
 =?utf-8?B?ZWthVEs0ZjhLNXgyb1AyNnhLb1J0Y083SFE5OXhTNEtiSTc0blRta0l4VjZs?=
 =?utf-8?B?REovNkhXeFEzTVVlcWg5ZDJvMWVpa1pLeUx6eVFmNVA5ZXJ2aEgxeHpMNDFL?=
 =?utf-8?B?cTVpWGVla2ozdG5qdkF3emc5MkhnSUY0SW5QTjFOckN6UlJ4TVE2b2NGUnQy?=
 =?utf-8?B?a3NsaGlZSXFMRis2T3FMMDFYT0F1NVA5eDdSTVBjeGhnUFZTM2FqbGkwYzBt?=
 =?utf-8?B?ejE1U1l2VEEzbGdBSnFQdTNKTTZCOXF4TjlHUjgxS21OaEZvTm9KRndiZENN?=
 =?utf-8?B?cTFxRFFvN3dxRUZPL1ZpQ3NRS0NtV3pCN002Sjc5eGpWUExoSHRpc25rc1lO?=
 =?utf-8?B?OC9peUxKWXdTZUsxWjNPMCtYT3RRVGV2ZENyRjlONVpnalRRamRDaXgzaTc1?=
 =?utf-8?B?OFlyYXQ1MkI5NE1yeGxHYW80b2FWQVdqVmgvOUZVUUlNd3QxV2dsOTQ2bDZx?=
 =?utf-8?B?ZEZRTVJQeEV2WnpudkN4WXRZZi9DWWhscnM2UXpidWd0TEUvakRqTFFZaGlX?=
 =?utf-8?B?RVp5K0YwRTN4dTVGWkJZMHNpV0t5alJiN0JYRHpwSXhobHdTcHZCMUV4aHZO?=
 =?utf-8?B?d2FxaHQ4bjFyV1dmQWJaek9ZSnVzd0I3K2tqOEJiUmRWMW9aVFNITHNZZ2dF?=
 =?utf-8?B?RjRQVzF6VlJDRGp0bW9EekhuMWRvK3JudUhGL205eXFsTm1BeHJEZkZrVWJH?=
 =?utf-8?B?eHhPQVREcGcrUENlUmVnc1NJZCsyWnZySTYvRERHN1p4MmpiaDhIVmY0bzRZ?=
 =?utf-8?B?aEU5NzJyWUdsVTlzaTVrZjdNeER5cy91VkRISmNpYyt6bjVsSWlCSklMd3h3?=
 =?utf-8?B?MjVHcjdPVVdFQ2kvcEFPTDVWc1VWRXpFMEw2dEZyQW0rY0RSUWlLZWRqUDFP?=
 =?utf-8?Q?2fE5uZIFaEA7LaK4ZCtf/GkWn?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5591.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ece977cd-ad56-4535-eacc-08da71968711
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2022 19:14:15.1322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kevCQcrwqzmNm3K4vb/EHyOlRHeSzSBC9gDozCCie4NzO2jIDNZ520ilx/9tXf6NQEm6mcJsaBi6pko4tOEhew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2760
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

SGkgRGF2ZSwNCg0KVHJpZWQgd2l0aCB0aGUgbGF0ZXN0IHRpcCBhbmQgSSBzdGlsbCBvYnNlcnZl
IHRoZSBpc3N1ZS4gSSB0cmllZCAyRywgNEcgYW5kIDhHIHNpemVkIHJlcXVlc3RzIGFuZCBhcyBi
ZWZvcmUsIDJHQiBzaXplIHJlcXVlc3RzIHdvcmtzIGZpbmUgYnV0IDRHQiBhbmQgOEdCIHJlcXVl
c3RzIGZhaWxlZC4NCg0KQ29tbWl0IEkgaGF2ZSBhcHBsaWVkIG15IHRlc3QgcGF0Y2g6IA0KY29t
bWl0IDAzOGVmOTkyOGUxYWNiMzdiYmU4MDhjMjNhNDIxMTg5ZjFmZDk2Y2IgKG9yaWdpbi94ODYv
c2d4KQ0KTWVyZ2U6IGUwYTU5MTVmMWNjYSBlMGRjY2MzYjc2ZmINCkF1dGhvcjogSW5nbyBNb2xu
YXIgPG1pbmdvQGtlcm5lbC5vcmc+DQpEYXRlOiAgIFR1ZSBKdWwgMjYgMDk6MTQ6MjggMjAyMiAr
MDIwMA0KDQogICAgTWVyZ2UgdGFnICd2NS4xOS1yYzgnIGludG8geDg2L3NneCwgdG8gcmVzb2x2
ZSBjb25mbGljdHMNCg0KS2VybmVsIHZlcnNpb246DQpMaW51eCBzZHAgNS4xOS4wLXJjOC1jdXN0
b20gIzEgU01QIFBSRUVNUFRfRFlOQU1JQyBGcmkgSnVsIDI5IDEwOjI4OjI1IFBEVCAyMDIyIHg4
Nl82NCB4ODZfNjQgeDg2XzY0IEdOVS9MaW51eA0KDQpUaGFua3MsDQotVmlqYXkNCg0KDQo+IC0t
LS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEhhbnNlbiwgRGF2ZSA8ZGF2ZS5oYW5z
ZW5AaW50ZWwuY29tPg0KPiBTZW50OiBGcmlkYXksIEp1bHkgMjksIDIwMjIgOTozOCBBTQ0KPiBU
bzogRGhhbnJhaiwgVmlqYXkgPHZpamF5LmRoYW5yYWpAaW50ZWwuY29tPjsgQ2hhdHJlLCBSZWlu
ZXR0ZQ0KPiA8cmVpbmV0dGUuY2hhdHJlQGludGVsLmNvbT47IGRhdmUuaGFuc2VuQGxpbnV4Lmlu
dGVsLmNvbTsNCj4gamFya2tvQGtlcm5lbC5vcmc7IGxpbnV4LXNneEB2Z2VyLmtlcm5lbC5vcmcN
Cj4gQ2M6IEh1YW5nLCBIYWl0YW8gPGhhaXRhby5odWFuZ0BpbnRlbC5jb20+DQo+IFN1YmplY3Q6
IFJlOiBTdXBwb3J0IFNHWDIgVjU6IFNlZy1mYXVsdCB3aXRoIEVBQ0NFUFQgZm9yIGxhcmdlIG51
bWJlciBvZg0KPiBFUEMgcGFnZXMNCj4gDQo+IE9uIDcvMjkvMjIgMDk6MDEsIERoYW5yYWosIFZp
amF5IHdyb3RlOg0KPiA+IEh1YW5nLCBIYWl0YW8gYW5kIEkgY3JlYXRlZCBhIHNpbXBsZSBwYXRj
aCB0byByZXBybyB0aGlzIGlzc3VlIHVzaW5nIHRoZSBTR1gNCj4gc2VsZnRlc3RzIGFuZCB3ZSBk
byBzZWUgdGhlIGlzc3VlIHdoZW4gdXNpbmcgVjUgKDUuMTguMC1yYzUpIGJ1dCBjYW5ub3QNCj4g
cmVwcm8gdGhlIGlzc3VlIGluIFY0ICg1LjE4LjAtcmMyKS4gTm90IHN1cmUgaWYgdGhpcyBpcyBh
IGRyaXZlciBpc3N1ZSBvciBrZXJuZWwsDQo+IGNhbiB5b3UgcGxlYXNlIGNoZWNrPw0KPiANCj4g
VGhhbmtzIGZvciB0aGUgcmVwb3J0Lg0KPiANCj4gQ291bGQgeW91IHBsZWFzZSB0cnkgdGhlIGNv
ZGUgdGhhdCdzIGdvaW5nIHRvIGdvIHRvIExpbnVzIHNob3J0bHk/ICBJdCdzIHJlYWxseQ0KPiB0
aGUgb25seSB2ZXJzaW9uIHRoYXQgbWF0dGVycyBhdCB0aGlzIHBvaW50Pw0KPiANCj4gaHR0cHM6
Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcC5naXQvbG9n
Lz9oPXg4Ni9zZ3gNCg==
