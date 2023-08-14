Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB349C001E0
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Aug 2023 23:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbjHNX7E (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 14 Aug 2023 19:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232758AbjHNX6m (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 14 Aug 2023 19:58:42 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D061722
        for <linux-sgx@vger.kernel.org>; Mon, 14 Aug 2023 16:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692057521; x=1723593521;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1bV80+DnrZVGdmc7iwkqQQ1ugIHyN4z2Olvu4vFWP+Q=;
  b=a0giTNLBboOd2b8WeqS8cLFdC5DVvWvHbbWKUNuOj9xCKiSxiolqZv4n
   U2D48J60Xu84NpcG9KaTcJn1t/QBiwWsOVOHxKrk/+0ZFBgX6v2WPL5aW
   X+24K70IBGCSt609catFj+bl8DmIt9NifJ9Gq8xieyTeUIG3wLAVdQ1AH
   K5eaWWgzUOtCMJhpB/coNRV+OMvuIfLT9rW6xroKIUnrV1RnmHxFD3gdy
   +yj1wlTj9coHrm+v5CAdFzky7dBWXm9qdr9sRX0Kz8eUUR3MWDY5jtEe+
   pBWL0siHuVxYRB4jHug1dRNFkXh+JODDPyPTUskNQIxqR5SK6N0N1xq0V
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10802"; a="403144711"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="403144711"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2023 16:58:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10802"; a="980196468"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="980196468"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 14 Aug 2023 16:58:40 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 14 Aug 2023 16:58:40 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 14 Aug 2023 16:58:40 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 14 Aug 2023 16:58:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SQiIYG+E1xAL09nd9rCpqmGo5In+ImobyLxE2aYQxFP++bQ5VvbJYqsFu9XHozUdR+nMUwbRd51iP1kjjbN/z6Difx8true+3cA4sB75nXfxakrepZTs0dDtdVYLvTAbNU2ePOxRv6Y7Pky9OP2iGEOyZmDlwfFt99IhbAobs/DnMO6Sm6i4ovUeZNJAuGReU2Ed2WFCmIzxjzYsGbgGLAEdLFgG5AWzZWftHtIhviDEcRfSj6CfVvDZt7caok47f//utM32mrOeFQEj06249iAJtXk420o1mbce4rpb3UfbMTBk9lrkkHR5Q0Dr475nD28/s/U2zwX3y+i9QNIFNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1bV80+DnrZVGdmc7iwkqQQ1ugIHyN4z2Olvu4vFWP+Q=;
 b=FFpJz8GHUdVMiGcfcuVxcBx+0kRVNYMF5WhCcCvktufGObGlm3/I57Xv7cmMYBAwZFygu0PnLIc/TzQhoqxcFjbaXXfEcF7HSLwWgXqstnc6oqcfjeImpFeaRLCAZsz7fjHVCVGGDx539/34uWYolSC8qCfwVUsQlzxTo5R4ZyK7lh6j3W+3O+geS6ISQGKQWVhQh0Aw1LBfoaMUqEYOmEopm7YPB/4HNOI1LTgHiW7Ii1C9PhuiTt067DZizDS3nagx3yR6Pf742FFahLinAVeBxA/LiMjVFXli6MVGv0c0ew8o/lnUIa2Hf9EOLVVkLIekRJARP3gUqqdwdQqz6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB6043.namprd11.prod.outlook.com (2603:10b6:8:62::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6678.26; Mon, 14 Aug 2023 23:58:38 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::980d:80cc:c006:e739%4]) with mapi id 15.20.6678.025; Mon, 14 Aug 2023
 23:58:38 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "jinpu.wang@ionos.com" <jinpu.wang@ionos.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "yu.zhang@ionos.com" <yu.zhang@ionos.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>
Subject: Re: [PATCH] x86/sgx: Avoid softlockup from sgx_vepc_release
Thread-Topic: [PATCH] x86/sgx: Avoid softlockup from sgx_vepc_release
Thread-Index: AQHZzmkroZaxadBVA0ehaaHZdR7fIa/qeaaA
Date:   Mon, 14 Aug 2023 23:58:38 +0000
Message-ID: <3954697abb1a6c84c4b30fbd0d5edcafae6f6966.camel@intel.com>
References: <20230814043714.107971-1-jinpu.wang@ionos.com>
In-Reply-To: <20230814043714.107971-1-jinpu.wang@ionos.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB6043:EE_
x-ms-office365-filtering-correlation-id: 1342a740-e2c5-45a3-8e24-08db9d2260d6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QO0jLaWkA3BwQlmXkXv8A5Nsbl7bY4eFp9WmmxdeR3exYcM95qzblwSEU0TVxemyegw/XoFXJRx6nz2bA+YqQJJYbOs+37/4X1Vpx4+8+a3nAHqyDWkXsLNZ1KMlZpgEvuZwOWE8sOlZT4KPd/TxZBvfOH5paJzNcTfXPfjfabJAWATTexz0zyr6UxypabPotn2uBP6Zk+P+4Nzg2hCmu+luaVz1wrShveqmrr+ns7YpWS4/GpfEX1QWKRl3ovmLzYmgIUVRfPhw7w/TgWOHgTV/tVByr9eSm5snzrhXHORUfhqfg32XleVf7RuGiTriDFbSJvlKNSeiGPoNIciiHTmSnCwkHhwg/UgpMOeh8Ey2blClPcVd5nDN+89r2dnZ3NHOxen0vC1Br0DFq81vOsvLZx+bfCzX851nwoQTz6jiOmEBQTeVAlMq+pkm5w2V+4opJH8+Xm9uwKs5UgbBFn9/xcFgFyebYud4Ue+udKggm68Uolt7uLBN33sqZxUtAarghfMQPDy6+Q3A1b3qINEzlBuW9AgfWRiv/ZijCA1hjw2Rs6mAzGjtuNPxqKGWNcxukeME9iU6nRAQZABn18hb6RTbi8F3oxXelsxr0RmxCKaGi+YsONkE80fwxPmO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(376002)(396003)(136003)(366004)(186006)(1800799006)(451199021)(38070700005)(82960400001)(122000001)(38100700002)(36756003)(86362001)(6512007)(6506007)(71200400001)(478600001)(2906002)(6486002)(26005)(2616005)(83380400001)(41300700001)(316002)(54906003)(66476007)(110136005)(66556008)(64756008)(66946007)(76116006)(91956017)(66446008)(5660300002)(8936002)(8676002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bXlFdWJPTytCczRuaG0xTWpiVDJmdjhWTExEVkRHUW8wYXA4NTVqNnlUbmdX?=
 =?utf-8?B?WHZ5MTdYMEtBMUJjeEdvWXNseFBNRS9rT09xZ1kwb1phMUo0RmlXZExFYXNW?=
 =?utf-8?B?TVdPTmtrZTVaOVlNRktUTXJrQnBmTmVHZ0VkSUhJOUxiS3BTVGFlUUV6eGo4?=
 =?utf-8?B?Ny9zS1RNb1dkMlpXNG85c0l3WmlOVVpkK243b1pJeEp6SS9Kc0l0ZkgwUWpm?=
 =?utf-8?B?Rm5pUzZaaU5xQjR4NEREaG5zazlqTTNYcUZBcGhiY3o3Y2gxUW9wa09ybDUy?=
 =?utf-8?B?MDAzVnBPTlQ2WGpWaHNuV3JUQUFhVTdTa0lDeFdlY0lXKzZYdTdNSXVoeFl0?=
 =?utf-8?B?NEk3MHQyMEtMTkRVbHh2VnIyNWtZQlQ3d0k3UEsyQWZIL0tkRWppb01rK1Zr?=
 =?utf-8?B?OWwvZkNQT1VjTDg3dW5xcklMY2I2M21yRnlndjl6dm5XdGhFZ3FzQTF4aytq?=
 =?utf-8?B?RDJrYUUwZC81NVFRRG12SGRRQ0JPd1BwREg4aHBjSzZBVFBXU3Ezbms4UDFN?=
 =?utf-8?B?Q3V4NXdGUUFlTHFDODc3cnExd2VwdWtJR0VBdVQ4UURTdE5YSFc3OC9oYTdn?=
 =?utf-8?B?M3RjbTZTdU5vMjVlak5QZ01SbkJzVVJUSjRMRFFTYkJlUDE0bm4zcyswU1ht?=
 =?utf-8?B?MkxOM05aQjl1K0FObkttbXp1UG96a21GbWJwNXgrZDVBeEsySmp1RElMM0Qw?=
 =?utf-8?B?ZXdUaG9rVHZkZTBrS3JHd3hvU2NUWVdCZE9acnU4M3dhY25ZK1NOR0ErdmtM?=
 =?utf-8?B?OTZ6bnZURTNyR2N0em9kSXU3MTFyMWhoKzNSaVRGUnhFYnE5WDlMbUl6Q1hI?=
 =?utf-8?B?aGpQMk1FNnM4djZVN0FvbEhZcFlnckVTdzRXRDV6aTJEbE5pbmxaYjJ0M3dI?=
 =?utf-8?B?ZmV6WFVBTGthUFJoeG9qR2RtaFlBcjQzSWVhZ3djSGd6RThEbGRDalMrdmdq?=
 =?utf-8?B?V21OQWdwaVpzZkNuRDdoNGdDVlBnMkZ2NEs3alBvQkZHRDQ1T2VpOWxPVjU0?=
 =?utf-8?B?ZFJ2RjlmdXFsaEEvOWhCNi9rQU1jMjhiTlNQK1VZTXNIZHFuVGVHZHAyRy9F?=
 =?utf-8?B?R1Q0NGFrU09WQzZtSVdUZ3dNelhsT2sxejRsbVdJRGJRZ21DUHFqcmhOSHgz?=
 =?utf-8?B?RlZrckQvQlVjV3E0Zm8zMUVLdnlrQ3FFWDN3dzNSUmFvbnRLTUhVbU00MDZP?=
 =?utf-8?B?SEJBWmFKcEJzUi9sVkltSWpTcGdZTXRYZm94YzkwQ3QwSGV1L1hhVzR5SkVl?=
 =?utf-8?B?Ti9lbVBmN29TYzhLU3JpU0tBMWJIbUFETk4vMlNJZXhYSlRpZ24rYjQ2bnpC?=
 =?utf-8?B?bDloc2ZubVhrUlV1R3ZwZ00zc3B4aytHZEdYSFg1OThLcnlPZ21qSjFCdlov?=
 =?utf-8?B?bVd4WjNrdWQ0ajlTeU1RUUJPTThBN3IxcFUxbzFqcDUzdThCRkJIUVZwRXFT?=
 =?utf-8?B?OGVVNFUwSEVtRWNNZGZBSDN6bXJiNnZHK2FXUnpPNjJIbVdQM0xDKzB4aVky?=
 =?utf-8?B?TzJ5Nm01emh3WnFQa2pJN0I3NGxIeE5GalNoVGNHeUgrakFqczNEU2syOG5B?=
 =?utf-8?B?eWJhUFp3Y21ZeWRvNGNGcCtlSzZSUitGdytLOG82WXJKdFV5VlI0b2JEV0t3?=
 =?utf-8?B?cWtJUDNQcTNuekIyRUNQL3c5TmpsN2RXRTZtUk1jNlM5eVp1ZEs0ZHErUzF5?=
 =?utf-8?B?akpRck9yZ1l1S0tHSm5Ka25iSEVwdURYREtTZGpnaU5PSWxBelRGRlQzM1M0?=
 =?utf-8?B?bFl5dHdleWxncG5UN3hFTW93WXMxTE5GY2RGamgzLzhPcTNuUGlBbTdrUlpM?=
 =?utf-8?B?WEVrd1V2alE5Y1hCZzBKUEVnQ1BndysxUWxjQmxidkQrSG1TK3E4UFNXMURz?=
 =?utf-8?B?K3UveHVQNTVlQ041aHEwVkJyN3JhQWhURjhuNWpneDdkSVd3Ny9lc0VRejFt?=
 =?utf-8?B?MThYZFlkNk1UQ1plNEE4NGh2TVU2UDBiRjhIbXpuS05LMmxhUzJib3k1R0I2?=
 =?utf-8?B?aFQ2d3dzaWZBdkZOUVVJMDlaajVLYzN2UHNqaGI3VFJKSVA4MkU3OHpnMVhD?=
 =?utf-8?B?YjVvSWRKU0I3MUFZK1VrUnRUbTB4VDA1bGc3U0thTm9iQThXM1hSMFNzdTh1?=
 =?utf-8?Q?FVEpdEOGsEmYCy9mzPQFtO2qg?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C6FE9AC906D0B5409EE249ADC69C9A8B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1342a740-e2c5-45a3-8e24-08db9d2260d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2023 23:58:38.1605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CQ3Avay+nYL7cj5KQn5TsMf12GAtw/h0VmT/G1DDSDx9sUbyjSbfbAXMVl6QAyjOYMVmxT+OhQ0JoHAyIjjL9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6043
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gTW9uLCAyMDIzLTA4LTE0IGF0IDA2OjM3ICswMjAwLCBKYWNrIFdhbmcgd3JvdGU6DQo+IFdl
IGhpdCBzb2Z0bG9jdXAgd2l0aCBmb2xsb3dpbmcgY2FsbCB0cmFjZToNCj4gIGtlcm5lbDogWyAy
MDQxLjI4ODIxMF0gQ2FsbCBUcmFjZToNCj4ga2VybmVsOiBbIDIwNDEuMjg4MjEzXSAgPElSUT4N
Cj4ga2VybmVsOiBbIDIwNDEuMjg4MjE2XSAgPyB3YXRjaGRvZ190aW1lcl9mbisweDFiNC8weDIx
MA0KPiBrZXJuZWw6IFsgMjA0MS4yODgyMjJdICA/IGxvY2t1cF9kZXRlY3Rvcl91cGRhdGVfZW5h
YmxlKzB4NTAvMHg1MA0KPiBrZXJuZWw6IFsgMjA0MS4yODgyMjVdICA/IF9faHJ0aW1lcl9ydW5f
cXVldWVzKzB4MTI3LzB4MjgwDQo+IGtlcm5lbDogWyAyMDQxLjI4ODIzMF0gID8gaHJ0aW1lcl9p
bnRlcnJ1cHQrMHhmYy8weDIxMA0KPiBrZXJuZWw6IFsgMjA0MS4yODgyMzNdICA/IF9fc3lzdmVj
X2FwaWNfdGltZXJfaW50ZXJydXB0KzB4NTkvMHhkMA0KPiBrZXJuZWw6IFsgMjA0MS4yODgyMzdd
ICA/IHN5c3ZlY19hcGljX3RpbWVyX2ludGVycnVwdCsweDZkLzB4OTANCj4ga2VybmVsOiBbIDIw
NDEuMjg4MjQyXSAgPC9JUlE+DQo+IGtlcm5lbDogWyAyMDQxLjI4ODI0Ml0gIDxUQVNLPg0KPiBr
ZXJuZWw6IFsgMjA0MS4yODgyNDRdICA/IGFzbV9zeXN2ZWNfYXBpY190aW1lcl9pbnRlcnJ1cHQr
MHgxNi8weDIwDQo+IGtlcm5lbDogWyAyMDQxLjI4ODI1MF0gIHhhX2VyYXNlKzB4MjEvMHhiMA0K
PiBrZXJuZWw6IFsgMjA0MS4yODgyNTZdICA/IHNneF9mcmVlX2VwY19wYWdlKzB4MjAvMHg1MA0K
PiBrZXJuZWw6IFsgMjA0MS4yODgyNjBdICBzZ3hfdmVwY19yZWxlYXNlKzB4NzUvMHgyMjANCj4g
a2VybmVsOiBbIDIwNDEuMjg4MjYzXSAgX19mcHV0KzB4ODkvMHgyNTANCj4ga2VybmVsOiBbIDIw
NDEuMjg4MjY5XSAgdGFza193b3JrX3J1bisweDU5LzB4OTANCj4ga2VybmVsOiBbIDIwNDEuMjg4
Mjc1XSAgZG9fZXhpdCsweDMzNy8weDlhMA0KPiANCj4gU2ltaWxhciBsaWtlIDg3OTUzNTllMzVi
YyAoIng4Ni9zZ3g6IFNpbGVuY2Ugc29mdGxvY2t1cCBkZXRlY3Rpb24gd2hlbiByZWxlYXNpbmcg
bGFyZ2UgZW5jbGF2ZXMiKQ0KPiBUaGUgdGVzdCBzeXN0ZW0gaGFzIDY0R0Igb2YgZW5jbGF2ZSBt
ZW1vcnksIGFuZCBhbGwgYXNzaWduZWQgdG8gYSBzaW5nbGUNCj4gVk0uIFJlbGVhc2UgdmVwYyB0
YWtlIGxvbmdlciB0aW1lIGFuZCB0cmlnZ2VycyB0aGUgc29mdGxvY2t1cCB3YXJuaW5nLg0KPiAN
Cj4gQWRkIGEgY29uZF9yZXNjaGVkKCkgdG8gZ2l2ZSBvdGhlciB0YXNrcyBhIGNoYW5jZSB0byBy
dW4gYW5kIHBsYWNhdGUNCj4gdGhlIHNvZnRsb2NrdXAgZGV0ZWN0b3IuDQo+IA0KPiBDYzogSmFy
a2tvIFNha2tpbmVuIDxqYXJra29Aa2VybmVsLm9yZz4NCj4gQ2M6IEhhaXRhbyBIdWFuZyA8aGFp
dGFvLmh1YW5nQGxpbnV4LmludGVsLmNvbT4NCj4gUmVwb3J0ZWQtYnk6IFl1IFpoYW5nIDx5dS56
aGFuZ0Bpb25vcy5jb20+DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBKYWNrIFdhbmcgPGppbnB1Lndh
bmdAaW9ub3MuY29tPg0KPiAtLS0NCj4gIGFyY2gveDg2L2tlcm5lbC9jcHUvc2d4L3ZpcnQuYyB8
IDIgKysNCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC92aXJ0LmMgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1
L3NneC92aXJ0LmMNCj4gaW5kZXggYzNlMzdlYWVjOGVjLi4wMWQyNzk1NzkyY2MgMTAwNjQ0DQo+
IC0tLSBhL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L3ZpcnQuYw0KPiArKysgYi9hcmNoL3g4Ni9r
ZXJuZWwvY3B1L3NneC92aXJ0LmMNCj4gQEAgLTIwNCw2ICsyMDQsNyBAQCBzdGF0aWMgaW50IHNn
eF92ZXBjX3JlbGVhc2Uoc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGUpDQo+
ICAJCQljb250aW51ZTsNCj4gIA0KPiAgCQl4YV9lcmFzZSgmdmVwYy0+cGFnZV9hcnJheSwgaW5k
ZXgpOw0KPiArCQljb25kX3Jlc2NoZWQoKTsNCj4gIAl9DQo+ICANCj4gIAkvKg0KPiBAQCAtMjIy
LDYgKzIyMyw3IEBAIHN0YXRpYyBpbnQgc2d4X3ZlcGNfcmVsZWFzZShzdHJ1Y3QgaW5vZGUgKmlu
b2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkNCj4gIAkJCWxpc3RfYWRkX3RhaWwoJmVwY19wYWdlLT5s
aXN0LCAmc2Vjc19wYWdlcyk7DQo+ICANCj4gIAkJeGFfZXJhc2UoJnZlcGMtPnBhZ2VfYXJyYXks
IGluZGV4KTsNCj4gKwkJY29uZF9yZXNjaGVkKCk7DQo+ICAJfQ0KPiAgDQo+ICAJLyoNCg0KVGhp
cyBhZGRzIGNvbmRfcmVzY2hlZCgpIHRvIHRoZSBmaXJzdCB0d28gbG9vcHM6IHJlbGVhc2luZyBu
b24tU0VDUyBwYWdlcyBhbmQNCnJlbGVhc2luZyBTRUNTIHBhZ2VzIHdoaWNoIGRvbid0IGhhdmUg
Y2hpbGRyZW4gb24gcmVtb3RlIHZlcGMgaW5zdGFuY2UocykuIA0KVGhlcmUgaXMgYSB0aGlyZCBy
b3VuZCBsb29wIHRvIHJlbGVhc2UgU0VDUyBwYWdlcyB3aGljaCBoYXZlIGNoaWxkcmVuIG9uIHJl
bW90ZQ0KdmVwYyBpbnN0YW5jZShzKS4gIEkgdGhpbmsgaXQncyBiZXR0ZXIgdG8gYWRkIGNvbmRf
cmVzY2hlZCgpIHRoZXJlIHRvbywgYWx0aG91Z2gNCml0J3MgZXh0cmVtZWx5IHVubGlrZWx5IGl0
IGNvdWxkIHRyaWdnZXIgc29mdGxvY2t1cCB3L28gY29uZF9yZXNjaGVkKCkuDQoNCkFsc28gc2lt
aWxhciB0byA4Nzk1MzU5ZTM1YmMgKCJ4ODYvc2d4OiBTaWxlbmNlIHNvZnRsb2NrdXAgZGV0ZWN0
aW9uIHdoZW4NCnJlbGVhc2luZyBsYXJnZSBlbmNsYXZlcyIpLCB0aGlzIGxvb2tzIHN0YWJsZS1r
ZXJuZWwgbWF0ZXJpYWwuICBTbyBwZXJoYXBzIGFkZDoNCg0KQ2M6IHN0YWJsZUB2Z2VyLmtlcm5l
bC5vcmcNCg==
