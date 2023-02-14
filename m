Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D12F3C61DA4
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Feb 2023 20:55:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbjBNUy7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 Feb 2023 15:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjBNUy6 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 14 Feb 2023 15:54:58 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2BD2B636
        for <linux-sgx@vger.kernel.org>; Tue, 14 Feb 2023 12:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676408097; x=1707944097;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=vXqn+ADKIwF2WEk+HecMhQx/3kYH55/IeWb9AmV3aBI=;
  b=C3OiNzeVFHNkyWdJhzd12cx0bqx+hlkwXQCpiVWQ9CRKIB8PCDkXcTZj
   vb8BROF637Gwbil6nX9k3LcZ1oAJdmqG9ah6K9/Eb+owyVN4P7fg+LPX2
   tBudC3gEJ3YMKOyAdP7slR8XlPrH734sU0RA5t8e9/TdxpT12NJxiAQGf
   B7uhn2awBpzgU75kgafAx/mP/jOPhemtADjH6zNIReDNQugzz6Cm3KAWq
   Wesz7191MUEmiPxD8o344yACW09cW6a9BvYLhy+253NDHLfCZ01uvPDCt
   IQsxMbrrGdj5ZmMjT9muz4eUBcO5N2gTLv36jiSR7P+1eogyDD8Bsq58x
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="328981527"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="328981527"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 12:54:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="758132162"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="758132162"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Feb 2023 12:54:57 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 12:54:56 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 12:54:56 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 12:54:56 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 12:54:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DI1SJax6meWqozvRx9w1TYMFBALVLAQyveobOJ1fbZ3V34dIGMb+Bo3RBoFw8/VR4Osgnnv45MiQY4/yoO5Ru+SdCDSRFdau5P9hCmeNMJ+Mo4uLENXB8Cz0XOsNJsHfLkjV2WKJIZMK6GNF2XIR73K++I73vtQgmymkV2ycBLRsdTcR6qdj9fEkoyPhPw1fgWuawM5QhO4preIcIufRggs/VnFbarqxmGqczsJvhJ8ti8Pad7dM+zIhmJAjZvF3d/4ZaXLULU39EWwAfA3HS3gXcj5iy3fKWS5Q2raLFSgWYD9cJSxPww2UmZXKkTDz21V8X/TPrSp3bgLRaqD0Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vXqn+ADKIwF2WEk+HecMhQx/3kYH55/IeWb9AmV3aBI=;
 b=eSjTxZ1vkVbSrTfppVITLA7UeowiOc1QVp0k24Fg4nTnrHzyTx59EJIFIOdVJT+5LF0L7775RO7FnElYAnBzhYhv2eDnrtlE6atpJtK3vzIegqiArBK0p31m5PdA9dIETUTp/Lb2E3m0D876COeY+BbBpGcJXFyqeZvxcjthCo9XY5AISU8j3cUOXsKgh+0jKWu6EZiYlDb/x5cSayOVMuXvRw1Vc97cGt2xhJApuxJzjJOWoA9V/h6qcY15Nkp0b/sT7EN1h8GEhOvPkS0mtV6/LEbE61gPORdzc7ikQRTQJr9cSirc3nzqQaRAlJwe5gkm3ghVqgbGn2BqtIbwtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 20:54:53 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%7]) with mapi id 15.20.6086.026; Tue, 14 Feb 2023
 20:54:53 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Topic: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Index: AQHZMtTIU78a0A3o9UaUPrwPUmNX5q7OTQIAgACfroCAABrOAA==
Date:   Tue, 14 Feb 2023 20:54:53 +0000
Message-ID: <39903b057751d963e4e9b2a8cd5271fe3c102509.camel@intel.com>
References: <20230128045529.15749-1-haitao.huang@linux.intel.com>
         <20230128045529.15749-2-haitao.huang@linux.intel.com>
         <20230128045529.15749-3-haitao.huang@linux.intel.com>
         <3c7b4f7bf3e7c2a213662b1c9fdaa979050a9327.camel@intel.com>
         <op.10dekzjhwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <op.10dekzjhwjvjmi@hhuan26-mobl.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW3PR11MB4764:EE_
x-ms-office365-filtering-correlation-id: 816574c6-5a9b-4feb-2517-08db0ecdb8c2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GSX78gZju6Gnu1R4CktJp/4w9qJ+mzqUfXTJZlNVLHai6QsNkok+12ZxHgKhAKqAMGuQyn98zWgY4FpHlI2g5IXQlONIGICRf0AElFq8VWj83YBWs4Q2M2VESp3TCUfvp2yy6YU1isS1Rsn95te0D/WHFJLyrbO75Oo1BGABHKRqI3pDMly5bO5t4/+5Ai25OOmOjcRPLOEijCJ13IBkMxW6BgeaNZwEB+AHQGOaKWvnSX1GcKN0W3DMbzzJXodtK6aiRm3i73bQ5R++u1pEtS7qw5hkecBmPC1GaQn679llSnE0y+7DuKXV7yMgFo15vzrwaa/JnDmQ92y29k9XxSe6tSLLLnfE2BXBVMLM1WS8XuSQtFegWVmhmyNsyodiIV8RyyMwHVwVAy2TxvYwCFeDvdqY8i0ykCN6t+XGi/7/GrNcem9re9i20uXdhNAybzeheDsmJJ3QOh3BApoQQ3YuV9hPziesF/tWjQ65+UH60UW6IVY+XTfShv5WdZPNIj0SkzEIyvJ+rX42bVANAChk/VPs4Anfxtq8Y2BHqnr7L3NbB0Gf57TQ1sC5UNpFL9cnFXpj7NfLTv/7aM2iZeliFDfVZNPPDqaUpDWS49ctzRh+EHbD10AOKQx2aXs2m345ERTdUC6nXVdD2eAtyC00I/0aD89OkQa31FTnCYZ0uplwrl01jddGGCrWUI8P
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(39860400002)(376002)(396003)(136003)(451199018)(110136005)(6512007)(186003)(2616005)(66946007)(2906002)(41300700001)(66446008)(6486002)(66476007)(66556008)(966005)(76116006)(8676002)(91956017)(64756008)(8936002)(5660300002)(26005)(71200400001)(6506007)(82960400001)(38070700005)(122000001)(38100700002)(86362001)(478600001)(316002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?emw4SytMeHlYaU1uRnVPMzBidWJXUHVFMnd5SHFEK0hpNFJXN0Q0ajREdVBT?=
 =?utf-8?B?Y1JFTTl3cFFiQmd5UkI4MlljclJESlZQNHdZQjJpbmsyekttRjNLVUlpWjVY?=
 =?utf-8?B?M29qbG1MNzI1elJGZWsvZkpFcWZXT2dXUC9IZkt6ZkZ2VzI5ZkxMU3pyMWNF?=
 =?utf-8?B?ZEs0Mloxb1lrRXZwLzVaZEN3M3hQYW5hTHR3VUI0aU5ObzBTVldURGFWT2Ja?=
 =?utf-8?B?WmhBNFBrTGpvZWEyM1prNENpaFQybkJvd2RzSzNXTGwvbXNlTlgydUZMRkly?=
 =?utf-8?B?K01VdUp3NC9ZWUhJamEwZHdtU3JhRWJSWnRadnpvY0gwZzlmenpFVUczTTJS?=
 =?utf-8?B?bWp1NUpKQWdCbzl0RVFSaFZ0M3dzRTkwVkxRT2RWWnU4cnFqYTl5NW9PR1Mz?=
 =?utf-8?B?RU8vUGNlaTlKMEEvbWJlYXFkcGJ0enVoY2hkU3I3Nm0veFJtSVBtbDRWY1lr?=
 =?utf-8?B?WDBMOVE1ak84cXdkRzZYUmJwN3cyV3drQlMvMk1qV09QWXpscncwcXJxRmtK?=
 =?utf-8?B?S3A1QTgvTkJMRDlidHhobWV4WE1Xb1BpR1U3KzlORGNsNStZb1ZId28zT1Ix?=
 =?utf-8?B?N1lNcUdIMXhqNWltRXBOMFp2UmtWbTE1WXN2U1FEZEM0YWNjU09OVEtvb1Vm?=
 =?utf-8?B?alJNNFg0NnovUUREWGlkcmE3YTZpQndXTFNtWFBZSFNZUW50bWFtaWIzdmwv?=
 =?utf-8?B?MlpPM3pBa2FxVUp5elJGTk9nVnJBUTJuejlneDBnMjNtOGI5NUdYS05Gd0pR?=
 =?utf-8?B?S2cxZ0cwbXJjS2pIY3VQbEZzN1gvQ0QrU3JWbGZMN3czci9ScUQ1SHV1eHht?=
 =?utf-8?B?aEpzajBvQ1lOQnZUenVmZ2d3ZE5tbTEvdnFCSnUxbVFmcjl4OEtUelQyMXF0?=
 =?utf-8?B?bjFvSHpJUUoxSmo0aEgrUEZJN00zQnBMQks4dkZyNldxdDk0R3UxRkU1MFZU?=
 =?utf-8?B?MjE3d3NPNnBhNnZvZmlkRjdQUUhIY0ZDZVM5OUh5Mmk4ejFCWVJPWHRtbDVL?=
 =?utf-8?B?b1dNTXdrcEQyK0ZONEhGRVhGUy9BdzNpTDFsQUk1NWdtajdvZ0Z5T0l1Sndi?=
 =?utf-8?B?R0FWZXNzT3ByOUVrNGNzOTZzTmJWNnhudm5NeGlMYUt4TWcrM2V6b1o1dllN?=
 =?utf-8?B?ZGp0N3M2RDYvTzdGZWsrc1FtczB4SzlBZVVkd0Rua1JUdHBnMWxwT3FTa2hC?=
 =?utf-8?B?djZNZnlzTjdOTlNlZjA2aS8wVFdmL290QnZaczFtelVSQlFhTkY4ME1yalFQ?=
 =?utf-8?B?ZTgwa1g5aDZxZmMyQzZoWkZPTTdGOEJhemJvZVNYdm9vL3pSVUZpcTk2TGp4?=
 =?utf-8?B?TlRncDlGQ28vMG4ybW5UVklKK3pEbWwzek9NaWNZRGs2RUxGWlZyNC9mTWJr?=
 =?utf-8?B?cmR1MVBiTS80eXZNZWRpaTQ4QVlSdGttU1hLYWpvWVlNK3R0blM0WDZwY0h0?=
 =?utf-8?B?SmZnS2NhNEhJMk1OVTR1T3FreTdJc0puS0NiSmEvRmJOTkM2ME9OWS9CN1Fu?=
 =?utf-8?B?ZXlFTmJiY2txL3dnK09VdzVNQTJWOWNOS3hCUEV2aG5Id3hjaUpsclY3L3R6?=
 =?utf-8?B?bVlYTHp2WmM1V01acnd2NlhGNjhuS1dxaHNlVVY0TjN3UkZnLzk4ZzNxZlN3?=
 =?utf-8?B?SnNWenRxSTN2blJxUnI3ZUlDMDZaTFNUNDhjYkZ1bTIvdUd2T0hwdjFERUJ4?=
 =?utf-8?B?aXJkK29ycmo3WFhoN05IeG00RWhwRnlIUmxhT20zMS80aXlXWVQwQUZ5Vm56?=
 =?utf-8?B?SXA3RjdqckZGd0JIWmZJYXlidjZ5SlUvaVU1SnJYbXRpRUpTa3ZWUzcwU3Rp?=
 =?utf-8?B?THhIRlNtQ1RhUXpSakh6YkZsSDA4T1oyb1ZkamJQMGNIc0lHRldkTWlLb2Y3?=
 =?utf-8?B?S1pXdWhYWDJ0TEJ4Z1FjWmFZRjBKNjJQTTBja28zQU1OOTRqMFd5dnNTZjBT?=
 =?utf-8?B?b20zREVKYTBkckd5RjJtNGM0NU4zdEpJNi9NYktxcm5JSDNacTRQY2RsRzU3?=
 =?utf-8?B?KzhLNTFSb0ZXSGp0bEJ1ci8xaHNXcjNGOU95Z3hicFFIK2IwZkhnTWh6WCtm?=
 =?utf-8?B?NFVwWGpwYlhORytxM2F5cHc0UmRpbkNlS2ZRT2ZiZEZoZlUxWHRHWmZhWDFl?=
 =?utf-8?B?a1lPWm9HRk5iVTdVcm1wMi81LytMa3JjdUFuekNjU3lLWHRJQ0ZjbHdQMnI4?=
 =?utf-8?B?TEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F7701D57F7FB66459C5B68A5AA90C633@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 816574c6-5a9b-4feb-2517-08db0ecdb8c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 20:54:53.3716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AEf1B3hLb0b8v/3sH8IGqx7x5aV648YDghJBAIoLJL7yoWco+v+RXQE5TBj0hA+jGECGmrMEI+tTI+QVyvTarg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4764
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gVHVlLCAyMDIzLTAyLTE0IGF0IDEzOjE4IC0wNjAwLCBIYWl0YW8gSHVhbmcgd3JvdGU6DQo+
IEhpIEthaQ0KPiANCj4gT24gVHVlLCAxNCBGZWIgMjAyMyAwMzo0NzoyNCAtMDYwMCwgSHVhbmcs
IEthaSA8a2FpLmh1YW5nQGludGVsLmNvbT4gd3JvdGU6DQo+IA0KPiA+IE9uIEZyaSwgMjAyMy0w
MS0yNyBhdCAyMDo1NSAtMDgwMCwgSGFpdGFvIEh1YW5nIHdyb3RlOg0KPiA+ID4gQEAgLTk3LDEw
ICs5OSw4MSBAQCBzdGF0aWMgaW50IHNneF9tbWFwKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3Qg
IA0KPiA+ID4gdm1fYXJlYV9zdHJ1Y3QgKnZtYSkNCj4gPiA+ICAJdm1hLT52bV9vcHMgPSAmc2d4
X3ZtX29wczsNCj4gPiA+ICAJdm1hLT52bV9mbGFncyB8PSBWTV9QRk5NQVAgfCBWTV9ET05URVhQ
QU5EIHwgVk1fRE9OVERVTVAgfCBWTV9JTzsNCj4gPiA+ICAJdm1hLT52bV9wcml2YXRlX2RhdGEg
PSBlbmNsOw0KPiA+ID4gKwl2bWEtPnZtX3Bnb2ZmID0gUEZOX0RPV04odm1hLT52bV9zdGFydCAt
IGVuY2wtPmJhc2UpOw0KPiA+ID4gICAJcmV0dXJuIDA7DQo+ID4gPiAgfQ0KPiA+IA0KPiA+IFBl
cmhhcHMgSSBhbSBtaXNzaW5nIHNvbWV0aGluZywgYnV0IGFib3ZlIGNoYW5nZSBsb29rcyB3ZWly
ZC4gIA0KPiA+IENvbmNlcHR1YWxseSwgaXQgZG9lc24ndC9zaG91bGRuJ3QgYmVsb25nIHRvIHRo
aXMgc2VyaWVzLCB3aGljaCAgDQo+ID4gZXNzZW50aWFsbHkNCj4gPiBwcmVhbGxvY2F0ZXMgYW5k
IGRvZXMgRUFVRyBFUEMgcGFnZXMgZm9yIGEgKG9yIHBhcnQgb2YpIGdpdmVuIGVuY2xhdmUuICAg
DQo+ID4gVGhlIEVBVUcNCj4gPiBsb2dpYyBzaG91bGQgYWxyZWFkeSBiZSB3b3JraW5nIGZvciB0
aGUgbm9ybWFsIGZhdWx0IHBhdGgsIHdoaWNoIG1lYW5zICANCj4gPiB0aGUgY29kZQ0KPiA+IGNo
YW5nZSBhYm92ZSBlaXRoZXI6IDEpIGhhcyBiZWVuIGRvbmUgYXQgb3RoZXIgcGxhY2U7IDIpIGlz
bid0IG5lZWRlZC4NCj4gPiANCj4gPiBJIGhhdmUga2luZGEgZm9yZ290dGVuIHRoZSB1c2Vyc3Bh
Y2Ugc2VxdWVuY2UgdG8gY3JlYXRlIGFuIGVuY2xhdmUuICBJZiAgDQo+ID4gSSByZWNhbGwNCj4g
PiBjb3JyZWN0bHksIHlvdSBkbyBiZWxvdyB0byBjcmVhdGUgYW4gZW5jbGF2ZToNCj4gPiANCj4g
PiAJMSkgZW5jbF9mZCA9IG9wZW4oIi9kZXYvc2d4X2VuY2xhdmUiKTsNCj4gPiAJMikgZW5jbF9h
ZGRyID0gbW1hcChlbmNsX2ZkLCBlbmNsX3NpemUsIDAgLyogcGdvZmYgKi8pOw0KPiA+IAkzKSBJ
T0NUTChFQ1JFQVRFLCBlbmNsX2FkZHIsIGVuY2xfc2l6ZSk7DQo+ID4gDQo+ID4gV291bGQgdGhl
IGFib3ZlIGNvZGUgY2hhbmdlIGJyZWFrIHRoZSAibW1hcCgpIiBpbiBhYm92ZSBzdGVwIDI/DQo+
ID4gCQ0KPiANCj4gTm8sIHZtX3Bnb2ZmIHdhcyBub3QgdXNlZCBwcmV2aW91c2x5IGZvciBlbmNs
YXZlIFZNQXMuIEkgaGFkIHRvIGFkZCB0aGlzICANCj4gYmVjYXVzZSB0aGUgb2Zmc2V0IHBhc3Nl
ZCB0byBzZ3hfZmFkdmlzZSBpcyByZWxhdGl2ZSB0byBmaWxlIGJhc2UgYW5kICANCj4gY2FsY3Vs
YXRlZCBpbiBtbS9tYWR2aXNlLmMgbGlrZSB0aGlzOg0KPiANCj4gICAgICAgICAgb2Zmc2V0ID0g
KGxvZmZfdCkoc3RhcnQgLSB2bWEtPnZtX3N0YXJ0KQ0KPiAgICAgICAgICAgICAgICAgICAgICAg
ICAgKyAoKGxvZmZfdCl2bWEtPnZtX3Bnb2ZmIDw8IFBBR0VfU0hJRlQpOw0KDQpCdXQgc2hvdWxk
bid0ICdvZmZzZXQgaXMgcmVsYXRpdmUgdG8gdGhlIGZpbGUgYmFzZScgYmUgY29uY2VwdHVhbGx5
IGNvcnJlY3QgZnJvbQ0KdGhlIGZhZHZpY2UoKSdzIHBvaW50IG9mIHZpZXc/DQoNCkkgdGhpbmsg
eW91IHNob3VsZCBkbzoNCg0KCWVuY2xfb2Zmc2V0ID0gb2Zmc2V0ICsgZW5jbC0+YmFzZTsNCg0K
aW5zaWRlIHNneF9mYWR2aWNlKCk/DQoNCj4gDQo+IEkgaGFkIGEgY29tbWVudCBpbiBmaXJzdCB2
ZXJzaW9uIGJ1dCByZW1vdmVkIGl0IGJhc2VkIG9uIEphcmtrbydzICANCj4gc3VnZ2VzdGlvbiBo
ZXJlOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvWTJCMGpCc0c2SEU0S1ZrN0BrZXJuZWwu
b3JnLw0KPiANCj4gVGhlIG9yaWdpbmFsIGNvbW1lbnRzIHByb2JhYmx5IHNlZW1lZCByZWR1bmRh
bnQgdG8gdGhlIGRlZmluaXRpb25zIG9mIHRoZSAgDQo+IHZtX3Bnb2ZmIGZpZWxkIGFuZCB0aGUg
ZmFkdmlzZSBpbnRlcmZhY2UuIEJ1dCBsZXQgbWUga25vdyBpZiB3ZSBuZWVkIGFkZCBhICANCj4g
bW9yZSBoZWxwZnVsIHZlcnNpb24gb2YgY29tbWVudHMgb3IgYW55IHN1Z2dlc3Rpb24gb24gdGhl
IGNvbW1lbnRzLg0KDQpJIHN0aWxsIHRoaW5rIHRoaXMgY29kZSBjaGFuZ2UgaXMgd3JvbmcuDQoN
CkZvciBpbnN0YW5jZSwgSUlVQywgaXQgYXQgbGVhc3QgYnJlYWtzIHRoZSBjYXNlIHdoZXJlIGVu
Y2xhdmUgaGFzbid0IGJlZW4NCmNyZWF0ZWQvaW5pdGlhbGl6ZWQsIHdoZXJlIGVuY2wtPmJhc2Ug
PT0gMCAoYWx0aG91Z2ggbm9ybWFsIGNvZGUgcGF0aCBkb2Vzbid0DQp1c2Ugdm1fcGdvZmYsIGNv
bmNlcHR1YWxseSBpdCdzIHN0aWxsIHdyb25nIElJVUMpLg0KDQpNYXliZSBJIGFtIG1pc3Npbmcg
c29tZXRoaW5nPw0KDQo=
