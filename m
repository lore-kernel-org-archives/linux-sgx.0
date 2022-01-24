Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D245C433EF
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Jan 2022 17:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244317AbiAXRpK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 24 Jan 2022 12:45:10 -0500
Received: from mga17.intel.com ([192.55.52.151]:17419 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241255AbiAXRpK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 24 Jan 2022 12:45:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643046310; x=1674582310;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tuTDjF0XXjVbSFR48fJA2pSfjEamCOZPluJVfMHejZA=;
  b=Hl3xLkst8FR/ZT1XgWN3kdeil1X+ksRH29PqV8qszJD+eaNNXeRxSI31
   lsesf/LxqIbnjCKbDCJJFIc9Y/WIiFbXNNZwtu0qn/nYgEhoiZXwG+g4u
   boeSofHiTERfuIug9QUhEMIebwowHh0Uw3SoqWsmV7YF8oaO8/fiOk25Y
   3LenWB2Oco/bo7DGHf/Sf+RktGLaMY0Q/3ujaavoJPucw5nrfnndg7ujs
   3fSJEUCyt5HOsqoEjxRatJ4krvBA1PTtkHjo2tYiut71Mdp/dnEdBSFXw
   mLms8OBkTTv9GlKFicht33BEN92IRT57nPLWeQKTGoUmkVIBfqbEwaSWH
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="226776422"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="226776422"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 09:45:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="532150864"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 24 Jan 2022 09:45:09 -0800
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 24 Jan 2022 09:45:09 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 24 Jan 2022 09:45:09 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 24 Jan 2022 09:44:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Znsu+IsWLiUJXqw2asgQs4DABMilED4gq6kAMH5tbFU75rPHUDZ8ZReAqzZbMQM7PMWcE3zSVr1zD7iwL55kJ8zcAsK+aiQvKXgjcck1QiHvW5W76hQVm8Ny1eBS0QHKP+SXW1bu/ygPVnHQ7aztggfZvVz0+QmrZb65do2EElaYIJWR8ZbTH/dR3hS3oyoTr2sqOnaIdjNQ5cc1i0Y34fcoA+RX9t6c4sENbWTWKClhPBb2BN3yyFeJSJuSbU2gANlJWpNfPjHIcW6NwzbfSMJoBNMvh7MQAAr2mgmc1ZPQqUSnFxpzAW0RksttFmpugUgdDr7IapU8Zsw/oBJ5bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tuTDjF0XXjVbSFR48fJA2pSfjEamCOZPluJVfMHejZA=;
 b=KOX6d/qSjb+evubn2S9tPDjDdsS0zIJEMnuGAH3nHa0QNtEpCLa9kUHKvnGcjdO7pmKwSMaIovI5f4tlZJelv7aMrdJBKRfgx66ofLWJRPd7e6tWqNqTgRDoIA5l1XlSr67FMMkoD0bPeXiLSZ1u3AeAgrxzdhRwKp1XIVivlLSawi83Qfqj68rs4tb+yNG3GC2sGbPpB9T0wcD9hDrJqmP8f8tYFVHCx3+mwpav/G+KSKAsnkQxbeVTYpjYQ1XEjUApG9nDDzasTAlVGMp98Y10583e/fQqgLeCcfGZGVCFR0/YbVSElvAl0LqztA8m7EMY6NNqN/NyykGv24luHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SJ0PR11MB5069.namprd11.prod.outlook.com (2603:10b6:a03:2ad::6)
 by BYAPR11MB3350.namprd11.prod.outlook.com (2603:10b6:a03:1a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Mon, 24 Jan
 2022 17:44:43 +0000
Received: from SJ0PR11MB5069.namprd11.prod.outlook.com
 ([fe80::a479:6130:7e5:b145]) by SJ0PR11MB5069.namprd11.prod.outlook.com
 ([fe80::a479:6130:7e5:b145%3]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 17:44:43 +0000
From:   "Accardi, Kristen C" <kristen.c.accardi@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "jarkko.sakkinen@intel.com" <jarkko.sakkinen@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     "Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: Testing 5.17 bugfix material
Thread-Topic: Testing 5.17 bugfix material
Thread-Index: AQHYDwExVXZhV/EzqUedym6PXVsG2qxydh8A
Date:   Mon, 24 Jan 2022 17:44:43 +0000
Message-ID: <06fa9c6e691db71abec906ebce14167bb896ade2.camel@intel.com>
References: <53bf06e8-f523-83db-ed4d-039c34f634cd@intel.com>
In-Reply-To: <53bf06e8-f523-83db-ed4d-039c34f634cd@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5 (3.30.5-1.fc29) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e00d9ce-c25c-4189-5eff-08d9df61345a
x-ms-traffictypediagnostic: BYAPR11MB3350:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BYAPR11MB3350F7010F27CB4F49D777B4AF5E9@BYAPR11MB3350.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ErMgEidjfc6bXHhHGnKM/oXp7qJFqTD0GfvqJa6LnhblomuwL1oJEEaSjhFLZVdQTGuwvjxx04DaL0KQBOMpXDToOeE4Wr03lusNaBfEqNki9WyGRXJxK0+CDmP7hbS77WpQG2EUORyXw6l96MX1DNl4n6HC9eYsI4kJ7hE5bdupow374cfHbpTX7qcnk078Vaqgh0cI0rz20NMTNM+GZ7U09ZqJx/lUnSKnb/0BxVFJg0RPM0qvxWdwjroDEBOMP9oG2j10dMLFbaZ1V9R26sRxl40G4PXymwcPAukjHeHkjp9D8oAteeAcZUZiWU9+Q0gczt4q9zqDxHkgfZYjQOpWYSZdHGZdn4m+RmHnrm+9yX4tvDnOBNoC9XtGSSfgdN6ZqCSTwKlR/ynf+xnP7MWI4yjhimqnDRm0efIew3dF7n2lSjZIAlYdXq7PcMVknifi9tWOp2kqhgYKyFtjNc1nM8mrwhi8eq7FhkE5TSCbrE5Lj0ysrCWAKCEs50wBMKi6DnGmx8OPzCZQpVhqcaZNwcl9elNnTAado6HmaEriePOCL5RSdob5exda2eoM0jUnWYeZJ5H5OgMP4I/w1aKg2TAw5csiTKEB/eqUTVd91TzRTb83tRiBBkomHpzIcavz39ywE1EZXQaftT0T2Ypxkf8NLjWLPI5//NGQ7ZxRri9LwcNt8pKGLGuDmEw96fY0eOZbz7MBQ3vpydZw/Ka/GWPI0kqnBVgKySHFgUIN1XJz0vjOOM+J53OK3w0eavA8jmnWESGhiP55aYU5r8cKGCwoSkl9L21HcmOMHyY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5069.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(6512007)(7116003)(110136005)(5660300002)(107886003)(316002)(36756003)(6636002)(508600001)(2616005)(86362001)(64756008)(66556008)(66476007)(66446008)(76116006)(966005)(6486002)(91956017)(4326008)(8936002)(122000001)(186003)(26005)(82960400001)(6506007)(53546011)(38100700002)(2906002)(71200400001)(38070700005)(8676002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SzhMRkcvOTJKU1dkMHdML2VWbmoyVVl4c3RLOHVsTGZwaWY1djRlY1I0UVJK?=
 =?utf-8?B?V25OOW1sb0xPek02RnB2bTZFTWthYUQwRTVwUVVXcEpxUWV3cGVsdjBzdWlJ?=
 =?utf-8?B?Q3M0VExrUTVJMmxObzgzV1h5VGYwQjVYdGdtRFFyR00waWZLd2ZGU1dJV1d6?=
 =?utf-8?B?alhZUENzMmt0Vk9TQ1JPKzNickNzZzVvU0ZTUU9qR2d1MmpJRTNCeDVOTjFp?=
 =?utf-8?B?RVBKTk9BcFYydWxPU0ZmdnV5b3B5U3Bqd1UwL05nY01wZ2R2bC9sc2tmZ2U5?=
 =?utf-8?B?TC9ZTUpGeVB2dHpTYkUzbkhVTVA5WmNaUVkzQjZFWHZkK2xBQVBPQVVZRGRq?=
 =?utf-8?B?enNhdENMNmlQcFNON3JLQkpvTVlxQWc3Y2FMcDl5OEtpQ2o4WDBSZXVaZkxG?=
 =?utf-8?B?dXBNZGpOdEZFZitWdGcrUXVOMDJteFg1UTVkM2xqeXpPMlBtNkYrTWlPUG9F?=
 =?utf-8?B?Vk5wWWZxWlRkSWV6aXFzVlJsWjdZUTFzZ2NlT3Z5dHozNjAyN0JydHl3OGZ3?=
 =?utf-8?B?dVlXTHBoWjYzQWVGZGlrUXFqWTlNOHpWbXNKelhZamF3dzloeHUzOEVrOHNU?=
 =?utf-8?B?cVBTbjFCQVJOVTFYdWkwdFFCTU5mdDJPczdKNnRxOGtXSG9vdFBjOTR6dnJV?=
 =?utf-8?B?TWZXK1VBT0FHemZpSnEvVGxUdTAyZm5UT2ZEYm5oaWR2SGZXK3ZqMW96c0sv?=
 =?utf-8?B?MFBCRmcycHhTMWdUNERsTjVoSzk5T2xLcHhQVlBqUVlIbmhFOXFGQmx5YWp6?=
 =?utf-8?B?c2NaUkZUN1ROZS85cHZuYmk5bXVvbWhrcVZOWU9zajludVl5SnB4Szl4YzRi?=
 =?utf-8?B?dkVLVDNKNzhJRUR3TVVFeGUwOUZVRTV6b1JQQ0x2VlB1QkF3bkhzazhGSENI?=
 =?utf-8?B?OWFaZEJtSlhjVUV6emg1SGc5L1NzTld1Q2dlbWRHejRNaG95NjlFZ0VEdjll?=
 =?utf-8?B?MlJRM2pjSlYzZngrMXVJUnd3N3VlY290eTlDTVdpcHdNWERWY2ZQSDB5dnpo?=
 =?utf-8?B?MEtYTEgvZ0tvYXBneEdaQnlqckJnOG81U2g0M1pEOXdCUzlUd0Z0WGk2TGJy?=
 =?utf-8?B?RFVnemhLdjRLcWY1emFra0dIenFFMTZSTDZvNDNFNUMwTXcvcDR2VVF3T05w?=
 =?utf-8?B?MERHbVJ1NkRiWVB4UWNhVVQ1OWMrRDZlcklwVDh5U0UxSERvSDR6eTgydW1G?=
 =?utf-8?B?czVoM0YwaVc2K3dyTkRyNFNZcHpUVEhtc2gvQ1JmT08vcFlWcEdEb0hYUEZj?=
 =?utf-8?B?bHRCcGxXdi91ZmF2U1MwazhOb1RZM1JqNmFjQWtzRlE3eW1wdDRnZ2ZXcEwv?=
 =?utf-8?B?SDF1ZWZZazk4cEZ0WmtUd0h0cWtta3NWNm5mamswTXFHQzVSYU02NURpN3l1?=
 =?utf-8?B?YkNqbUdmWkx4bVp6VHpJNDhRK01QamVMT2pVTGFSOGpydGw3bE1SK2RyQTZ1?=
 =?utf-8?B?NTVGU0lHUnpoQzg2aXV4MmtmOUdXUDJ4aFdRS0VoZ2JibVZ4MkdSM0ZYM095?=
 =?utf-8?B?V2g5aHlNWGQ0N2k4Tm1HTk5NVGNXWitxczU3RTkxSGFOYnorbjd0UmhSMGJH?=
 =?utf-8?B?Z1ZZZ1hEeFB0YUk5T242d0dBekJ6NmZOUVJxY1lVaFFLZVBMRVMwSDZNbWR0?=
 =?utf-8?B?cTVLRGZZTWtYVEM4Sk5RVm9UOFVWdGo0QzZBczVMYjlzdmN4K3VCK2VTOFNS?=
 =?utf-8?B?eXEvNVhpNWlPTXhIamtxS05XaHFjZ1RURmFrRW95U3J2eW5oMkxzV0NMMzdl?=
 =?utf-8?B?NkU5SG9LSnRhYVZNYUt6TXkxa1FZbE50aFJFMWpyYlJWTER5MmhaaVNZNjAz?=
 =?utf-8?B?ekUrcWVBSTdXWi9uZmJ0RVpvNlVyRlFkOHJrRmMrRndHcTUyczV4a2t4a0NZ?=
 =?utf-8?B?aC9YR1NoOHJCcU5DbndXTm0xSHBTU0lWb0w4clk2U3l5QjJWTlJBOVF0VURI?=
 =?utf-8?B?T1pySUNadU9YU0ZOUW5SYkdhbk1KWVJBQmRTZ1laeC82bkJZaVlvbTFwTXdZ?=
 =?utf-8?B?bFpOaEZIaVJkc0tqaU9ZZWtIZks1M25zR2dETm04bkFRWS9mN0RISmZIcmxy?=
 =?utf-8?B?c1NnYjB5QzEzT21jdU5hOXQrajg0NDQyYWRMRXBWVWFrWkpFR0Q1aDJDNmJT?=
 =?utf-8?B?TXhZWmNqbTBaVGNqTnR5Nys5alVoM0phYjEvRDNFNzI0aVRPRjlmNkNoa0N3?=
 =?utf-8?B?WC8wdTlxMy9SQnR5N0FaaWdmRnRKQ1ZtZ2VYZ3NpMkkxOVN0cEVYSkJJalpP?=
 =?utf-8?Q?PzvhJOUzhFmCR0REWicxZU1PCmPRa/NE5cUSlre+hE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC2C2F155CBC7C44B07D120EBAC4F9A6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5069.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e00d9ce-c25c-4189-5eff-08d9df61345a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2022 17:44:43.1858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TmGHT4PbGEnH7s6lBoOjyJmhSRpcewDGe7DtRgOFAP3j4/vaP4205+FQLbb80Mn3sl9uUVv1CrSV4p79ZcU5D5TlX1odzyIDgZ6/XB1zJ2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3350
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gRnJpLCAyMDIyLTAxLTIxIGF0IDExOjU3IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
SGkgRXZlcnlvbmUsDQo+IA0KPiBUaGVyZSBhcmUgYSBmZXcgU0dYIGZpeGVzIHRoYXQgaGF2ZSBz
aG93ZWQgdXAgaW4gdGhlIGxhc3Qgd2VlayBvciBzbywNCj4gbW9zdGx5IGFyb3VuZCBSQVMgYW5k
IGZpeGluZyB0aGUgYmFja2luZyBzdG9yYWdlIGlzc3Vlcy4gIENvdWxkIGZvbGtzDQo+IHBsZWFz
ZSBnaXZlIHRoaXMgYnJhbmNoIGEgZ29vZCB0aHJhc2hpbmc/DQo+IA0KPiA+IGh0dHBzOi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2RhdmVoL2RldmVsLmdpdC9sb2cv
P2g9eDg2L3NneA0KPiANCj4gSSdtIHBsYW5uaW5nIHRvIHNlbmQgdGhpcyBidW5jaCB1cCB0byBM
aW51cyBhZnRlciA1LjE3LXJjMSBjb21lcyBvdXQuDQo+IA0KPiBLcmlzdGVuLCBJIHJlYWxseSBk
dWcgaW50byB0aGUgY2hhbmdlbG9ncyBvZiB5b3VyIHR3byBwYXRjaGVzIHRvIG1ha2UNCj4gaXQN
Cj4gbW9yZSBjbGVhciB0aGF0IHRoZXkgYXJlIGJ1Z2ZpeCBhbmQgc3RhYmxlQCBtYXRlcmlhbC4g
IEknZCBhcHByZWNpYXRlDQo+IHNvbWUgYWRkaXRpb25hbCBleWViYWxscyB0aGVyZS4NCg0KVGhl
cmUncyBhIGJ1ZyBpbiB0aGUgY2FsY3VsYXRpb24gZm9yIHRoZSBhdmFpbGFibGUgYmFja2luZyBi
eXRlcywNCnBvaW50ZWQgb3V0IGJ5IEhhaXRhbyBhbmQgdGVhbS4gSGVyZSdzIGEgZml4IGFwcGxp
ZWQgdG8geW91ciB0cmVlLg0KDQpGcm9tIDJlYmNmMGU3MGIxMjM1MjI0NDEwZTA4Yzk4M2UzNTdk
NWFjM2M0MzUgTW9uIFNlcCAxNyAwMDowMDowMCAyMDAxDQpGcm9tOiBLcmlzdGVuIENhcmxzb24g
QWNjYXJkaSA8a3Jpc3RlbkBsaW51eC5pbnRlbC5jb20+DQpEYXRlOiBNb24sIDI0IEphbiAyMDIy
IDA5OjI4OjU2IC0wODAwDQpTdWJqZWN0OiBbUEFUQ0hdIHg4Ni9zZ3g6IGZpeHVwIGZvciBhdmFp
bGFibGUgYmFja2luZyBwYWdlcyBjYWxjdWxhdGlvbg0KDQpSZW1vdmUgaW1wcm9wZXIgcGFyZW50
aGVzZXMgZnJvbSBjYWxjdWxhdGlvbiBmb3IgYXZhaWxhYmxlIGJhY2tpbmcNCmJ5dGVzLiBXaXRo
b3V0IHRoaXMgZml4LCB0aGUgcmVzdWx0IHdpbGwgYmUgaW5jb3JyZWN0IGR1ZSB0bw0Kcm91bmRp
bmcuDQoNClNpZ25lZC1vZmYtYnk6IEtyaXN0ZW4gQ2FybHNvbiBBY2NhcmRpIDxrcmlzdGVuQGxp
bnV4LmludGVsLmNvbT4NCi0tLQ0KIGFyY2gveDg2L2tlcm5lbC9jcHUvc2d4L21haW4uYyB8IDIg
Ky0NCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCg0KZGlm
ZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L21haW4uYyBiL2FyY2gveDg2L2tlcm5l
bC9jcHUvc2d4L21haW4uYw0KaW5kZXggN2VkNmExYjEwYzIxLi4xMGE2YWY4OWJmNjQgMTAwNjQ0
DQotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L3NneC9tYWluLmMNCisrKyBiL2FyY2gveDg2L2tl
cm5lbC9jcHUvc2d4L21haW4uYw0KQEAgLTkyMiw3ICs5MjIsNyBAQCBzdGF0aWMgYm9vbCBfX2lu
aXQgc2d4X3BhZ2VfY2FjaGVfaW5pdCh2b2lkKQ0KIAkJcmV0dXJuIGZhbHNlOw0KIAl9DQogDQot
CWF2YWlsYWJsZV9iYWNraW5nX2J5dGVzID0gdG90YWxfZXBjX2J5dGVzICogKHNneF9vdmVyY29t
bWl0X3BlcmNlbnQgLyAxMDApOw0KKwlhdmFpbGFibGVfYmFja2luZ19ieXRlcyA9IHRvdGFsX2Vw
Y19ieXRlcyAqIHNneF9vdmVyY29tbWl0X3BlcmNlbnQgLyAxMDA7DQogCWF0b21pY19sb25nX3Nl
dCgmc2d4X25yX2F2YWlsYWJsZV9iYWNraW5nX3BhZ2VzLCBhdmFpbGFibGVfYmFja2luZ19ieXRl
cyA+PiBQQUdFX1NISUZUKTsNCiANCiAJcmV0dXJuIHRydWU7DQotLSANCjIuMjAuMQ0KDQo=
