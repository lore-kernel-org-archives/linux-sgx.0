Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED064C05027
	for <linux-sgx@archiver.kernel.org>; Wed, 15 Feb 2023 02:39:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbjBOCjH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 Feb 2023 21:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbjBOCjG (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 14 Feb 2023 21:39:06 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4141E32519
        for <linux-sgx@vger.kernel.org>; Tue, 14 Feb 2023 18:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676428745; x=1707964745;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=eUnPRhWto/1mQiFwBJdyd1ELpkFHHNt44H8NfINwgGk=;
  b=kq9qt2PjxIIUCCLiYgLIuBbOEyndIwtDI6LujSAsMigO8jpgLUc/yajp
   s9ZHbTDMTxOCG/RlgEpkBjpCkAaQ4JCaHuPxzFniEQG51fbvzGIL7CkXF
   3Dq/2ycXGV4eYaot72MO8keg/Rk+RNFx6zkWviHB7kqUeFwCB1pItlBOW
   bgh74pGSU9sgx/oX2p4JJIHYlqTPHrphvQ25ZftrCZBMHjlgw27VBZgeE
   0VpVEj0gMXtgv5XsW4EyKKU7b9BpRW/S8i0n8GwdyDgSXNE+IQyboDT1w
   r74BFtubmp8Yjlxmr9/3gO7WKaa74pdDmAA2Dh7MmvihtRr9QillHvCdG
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="332638322"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="332638322"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 18:38:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="793324444"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="793324444"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 14 Feb 2023 18:38:32 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 18:38:32 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 18:38:31 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 18:38:31 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 18:38:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DL4S9G9Su/tgcDbbzwlgnPY7LhURlAnjLFEkFhNy7cHojjoUD7Iic1Jwe86JUyab896Fnn5J6GqDrgOV3wyePFUGRTMrIBI4remvMGCIxOyiZH+b1VNQF1lxZ3RiwH7Zkhs1Rj3kD88zL5k63ECTNCl3Muq9rqKBjeRluKHtXWDcEmbm4JgRY+sf920ddk8EMxQ/GbbnWYAwC45I5Z+FPbLLUG+Fp2Mqurkjk1R8hAUdyIylbmRnjDwWiP40K4mgmqhWAj7DJ9ObR76QwNaQfK9Z3VIrK6qdccoBH6nRht+7VeWof0fjE0id0mYXpj0f09ZF4WSpGwLuqZl73AFRYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eUnPRhWto/1mQiFwBJdyd1ELpkFHHNt44H8NfINwgGk=;
 b=VEYEHKo06g+ye9vJAk4PSP/6o8FX2xDBYyUEAKsXCzgPzqxTXAT5tS/6DucEsFyuhG61rH4lb8+lf9eL19aDHgIgRziJUf2g4banSHfJ7nZNduCDgNY5sC/Cv/nk2DD94PXa8kW8GD+7pWcaM5dawAfFLM/GR6wySJBXkqYtuyUhlSYSu99bnETGHSPEimiCm7HMkfbocAkHWxRjTQ+24ld8a2Y288f5NK8byhEze/ejfWiAhIriVZPWv79/aZWmq5yn+vJ0yOqfCgz4kPCja2xvJqubaCBL5bvrKDL/SGlTPhU2zkKbeWSXfK7jLAFIY35VsE0ZdrWezB3jFIk1QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB6815.namprd11.prod.outlook.com (2603:10b6:a03:484::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 02:38:29 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%7]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 02:38:29 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 4/4] selftests/sgx: Add test for madvise(...,
 WILLNEED)
Thread-Topic: [RFC PATCH v4 4/4] selftests/sgx: Add test for madvise(...,
 WILLNEED)
Thread-Index: AQHZMtTH5vmG3AnJqkqaKdt8RGDk367PZ38A
Date:   Wed, 15 Feb 2023 02:38:29 +0000
Message-ID: <66db7859f696743b036c9dba3d040d196477984d.camel@intel.com>
References: <20230128045529.15749-1-haitao.huang@linux.intel.com>
         <20230128045529.15749-2-haitao.huang@linux.intel.com>
         <20230128045529.15749-3-haitao.huang@linux.intel.com>
         <20230128045529.15749-4-haitao.huang@linux.intel.com>
         <20230128045529.15749-5-haitao.huang@linux.intel.com>
In-Reply-To: <20230128045529.15749-5-haitao.huang@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB6815:EE_
x-ms-office365-filtering-correlation-id: 6b2e8b03-2c0d-4096-e174-08db0efdb8c8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1mmMtj6+E7G5D2S8/r4nXkLBTD8XooZe+1bmJdCWyrqFEtMplATGU/3iX1p9H7JC10+Rhj2/C8oU2nhrMQZ+XVtVeqmczM9RNUJsm+IX/oVhPEPl9yD6QdrwkQ+eXPiZpHupVDLfybgxHXu0uOJV49kSsWbRaM6VPRQMHlCRMKVchJxEKLhB4M8l1q+2i8gW5Bw62UKy3Pibe03Ju6McMWD8lPGyXUonvYpoVT0pOEEYMT3USikCN0YATphXYvo93rDJXDzhTPD3OcxSYnjoNrpX7YSMD1GLxIAiuFDigIXz2Mbdi+NnUy2mOAjI/NqL6hAvQEcrw2L7zj1LGWKwXuFdb1BgyjD66BMXQWcb81poG1crfYusi4FieMKqQQ/yDjBaKWCRFJ+5Xm+adD3TBBDi2Vq5dH0ptKYLQbw05eFRn6hFgS3d2G7m+XGekegCfyhVZarc2R24OmzJLX1kqqGk/4Qbkl0MoBNw6mKjqTyaX90SL7tdf0+ZKiDRyW2XHIrq0FFdP+88pPeFR2zyuu0v0XTk/SieJcAClrEbilA9+NMfMYifCOsTbXQPpPcsRrt/AjIIPkSNZH3WALWyLlZakW+t4P2QtnejClelNwzNUn20UMlEO6XZGyuAFJEHh9Fqz0IcW8s3m3vV9OY0oY0nn+BrcrnMjQTWVYeXoVWbyvBc5KUzxgwmJ14uAjCrBdUrAikFbxqnz1ohsAEH0A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199018)(38070700005)(41300700001)(316002)(82960400001)(8936002)(110136005)(5660300002)(91956017)(66476007)(66556008)(38100700002)(66946007)(76116006)(122000001)(66446008)(64756008)(8676002)(4744005)(26005)(6512007)(186003)(2906002)(71200400001)(86362001)(6486002)(478600001)(36756003)(6506007)(83380400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R0IyOEsxWGxyVVM2WG90WloyRkRZdktPeG9kbkJGaEY1dlZ4TmY1SnJVN1ht?=
 =?utf-8?B?d1FSOWNKWTRPd0h1WFlRYmlhTzdhS3k1UUk2eWxkd0FUTkpiZ1krT1VpYW5V?=
 =?utf-8?B?SmV0MUo0Z2xYSktVSHZtRUhUTzlGREZIeEdqbjJkdlozeGJ6c0M0RlF1WExL?=
 =?utf-8?B?T3ppT0t1TmcrQzhUVWJ0aUxGREJVeUpIK2lMMHh5eFhzMGtVYnlickVKTU40?=
 =?utf-8?B?amd6bWxObjVnNU5UREtkVHc5NVNoTEpLOHArenE2UFdTdnZtYlZHWmVDMnBC?=
 =?utf-8?B?b3p5NkMraDFMME9LSDBjMXRLc1oxbEM3RndLeStQU3dKZXh4ZnFGYnNndWJ0?=
 =?utf-8?B?Z0xpUkZaVk9FSUxQdVlZbXBhRlJUbXpkeExob1NnOE80aWNzMXUrNlFwdDNI?=
 =?utf-8?B?d1pzbzBhRUV2aHRDanBiSmhZQ21mWVNHbEpETmlGV0dzdmV5L2Z4WEpwbnMx?=
 =?utf-8?B?WHkwK1BsTm92TzVsV2YzM3poaTY2M2I4cy9ObVdONnBKS1B6cy9nbjM3Umtj?=
 =?utf-8?B?NHF4aXF3N29ia3lzMUJmWWlaODJJdWZuYXZ0VTNtT2phOE1KSFdQU1huemZG?=
 =?utf-8?B?K05hMVpEOWE3elJURkNZeUpJbnljTXNxcmNOVnFWWXFUckdJL0h2eHY1MDJG?=
 =?utf-8?B?cUc4WTh5aU90R1hxaWpVRU0rMUZSdHFURGk0T09KazJ5TGVabkR3MDBxdklS?=
 =?utf-8?B?Rm4xOUNyd3JwbHAyQk5KNytOR29Gd1N3VStMa0VUMXI0cmlKbUM1Ry9sZ0Mx?=
 =?utf-8?B?RTlZMW9NcVU0NW1Yc0NyS0REbFhMYzBxYkltN2IxNnNSdUZwRHpFN0x2Y1k0?=
 =?utf-8?B?R05ZQmlUanJDTmU0dll3eXZ0SEk4K0pUZlBWRFZSSm1ZNDFpelJUQy9xMm5q?=
 =?utf-8?B?Mi9MOFFORXIzRkZpQS90RFZodjJ1MndYQjc4VFpHaSt2Z3UwcS9uTWpFYUNK?=
 =?utf-8?B?NGZmSmc5TmdFMXZ0MlRGMjBwbGJrc0w2Y2lMZ2hYZmhuSWVaM2d5eit5dTUy?=
 =?utf-8?B?Q2ppN1NNazMrSjNBNyszY3JmTDdsa1UzY2FVWVdZQzBsY1VHSSt0L1h1QS9j?=
 =?utf-8?B?blAxVzdjcERDTVk4aXlYUWYyVm4xWS9hRnZwazN4NzViK3VpbWRHeXFSSkJY?=
 =?utf-8?B?cGxYZ2N0ckN2R1BkRW1xU0xrOTVDR0trUm56TXpUUjFDbjJJcE4wTU9EeElO?=
 =?utf-8?B?TlhtcTlGTEU1Z3RnYnZxK2VXU25TQ3AyUHROWFJrMkN6c1NFN0FQZGw2ekRt?=
 =?utf-8?B?d1oyUFNacGt3OTJ4R2UwdWtTam11V1hFcVlvUVVnYjYzeGV2bE1EU3lOa0RN?=
 =?utf-8?B?TGd4NnNRUXFBeGdldmQ2ejBYbGpKNmpUWnJVK01aVTZvaHBIYmpTSGJFeUlt?=
 =?utf-8?B?R1U3dGNYUWxXOEpwUmJyWG5HMDdaUVRTMlVMQ0JDY1FOWjloU0tvUThKZTY0?=
 =?utf-8?B?dzJHY3RSS1J0bGFiaGtwYis1SGpkRjFpZUFNSjdHZU1IZ3piR1Y4ZXJzTkJv?=
 =?utf-8?B?Wklob1ZlQWI2Q2JFSy9PSWcrZmc2MmhhandTem8ydjliT3czTmcvekpVOEdm?=
 =?utf-8?B?ZlJ3NE5odVVydWltQ3JjVHA1Znk0QmRUZFo5YW1JU2NicmtCMnRlbHd1Y0ZT?=
 =?utf-8?B?eXVGYnYyNkpGMWJUZHBZVGZidy9zdWh4c2FTVklyRjhZNHBYNm40UXVZa3FM?=
 =?utf-8?B?Qmg5enJPYXBBdDdGTWFEb2YvZTBuRmZhT3FYQ08rNnJNQm02azhETFRWaTBx?=
 =?utf-8?B?YXhnNm1uM292am5aZUFqY3NKeUYxWDRabWZKQU45WFd6Vk9jOFRtdThYUlls?=
 =?utf-8?B?Z05wT3pHajZVYzVITjhBaWdTSnQrN3JMelY5Q2NLcXhCdzdDTnNJR0lVM2hs?=
 =?utf-8?B?dGJrU2luMHhDUFVJbGd6WXhhWVhadFdKRGc0WWprVFl0czhWVDdBTHFmODVG?=
 =?utf-8?B?RURTSVlzSEFxQTZIN3JxL1I1UTF0WUkveExQT1dRcU96TmJCZk5yL0c4eTJP?=
 =?utf-8?B?U1cxb3JuTXZGcW13QnhtZmUycnF3bjA4WmdZNTF1M2NYZWdKaCs5N2YwY1hm?=
 =?utf-8?B?V3hTWHFmWWhYaWl3V1loNkd3RGp1NDhUY3RlcFJmRmdKcUh3dldDTXpaZFlr?=
 =?utf-8?B?cGdBbjFZMHBVUVp1R0E0R0FjNnErQjA2d2I0TVAyNVdadmc4azhvSmMxR25Q?=
 =?utf-8?B?V3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1EAE71076065444F928CC06250589411@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b2e8b03-2c0d-4096-e174-08db0efdb8c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2023 02:38:29.2119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vwBezoRbu8Va31iSrXjQ4rFCir/k+oK1GQ6VhK8StXrgBAXWaCt7nEbUgFMvn6w7HtAqWnJ9kerc0Uh/97mJjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6815
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gRnJpLCAyMDIzLTAxLTI3IGF0IDIwOjU1IC0wODAwLCBIYWl0YW8gSHVhbmcgd3JvdGU6DQo+
ICsvKg0KPiArICogQ29tcGFyZSBwZXJmb3JtYW5jZSB3aXRoIGFuZCB3aXRob3V0IG1hZHZpc2Ug
Y2FsbCBiZWZvcmUgRUFDQ0VQVCdpbmcNCj4gKyAqIGRpZmZlcmVudCBzaXplIG9mIHJlZ2lvbnMu
DQo+ICsgKi8NCj4gK1RFU1RfRl9USU1FT1VUKGVuY2xhdmUsIGF1Z21lbnRfdmlhX21hZHZpc2Us
IFRJTUVPVVRfREVGQVVMVCkNCj4gK3sNCj4gDQpbLi4uXQ0KDQo+ICsNCj4gKwlmb3IgKGkgPSAw
OyBpIDwgc2VsZi0+ZW5jbC5ucl9zZWdtZW50czsgaSsrKSB7DQo+ICsJCXN0cnVjdCBlbmNsX3Nl
Z21lbnQgKnNlZyA9ICZzZWxmLT5lbmNsLnNlZ21lbnRfdGJsW2ldOw0KPiArDQo+ICsJCXRvdGFs
X3NpemUgKz0gc2VnLT5zaXplOw0KPiArCX0NCj4gKw0KPiArCWZvciAoaSA9IDE7IGkgPCA1MiAm
JiBhZHZpc2Vfc2l6ZSA8IG1heF9hZHZpc2Vfc2l6ZTsgaSsrKSB7DQo+ICsJCWFkZHIgPSBtbWFw
KCh2b2lkICopc2VsZi0+ZW5jbC5lbmNsX2Jhc2UgKyB0b3RhbF9zaXplLCBhZHZpc2Vfc2l6ZSwN
Cj4gKwkJCcKgwqDCoCBQUk9UX1JFQUQgfCBQUk9UX1dSSVRFLCBNQVBfU0hBUkVEIHwgTUFQX0ZJ
WEVELA0KPiArCQkJCQlzZWxmLT5lbmNsLmZkLCAwKTsNCg0KSSBzZWUgdGhlIHByb2JsZW0gbm93
LiAgSGVyZSAncGdvZmYnIGlzIGFsd2F5cyAwLiAgSSB0aGluayB0aGlzIGlzIHdyb25nLg0KDQpT
aG91bGRuJ3QgeW91IHVzZSB0aGUgYWN0dWFsIG9mZnNldCByZWxhdGl2ZSB0byB0aGUgZmlsZSBh
cyBwZ29mZiwgd2hpY2ggaXMNCgkNCgl0b3RhbF9zaXplID4+IFBBR0VfU0hJRlQNCg0KPw0KDQoN
ClsuLi5dDQoNCj4gKwnCoMKgwqAgbXVubWFwKGFkZHIsIGFkdmlzZV9zaXplKTsNCg0KSW5jb3Jy
ZWN0IGluZGVudCBoZXJlPw0KDQpQZXJoYXBzIHlvdSBzaG91bGQgdXNlIGNoZWNrcGF0Y2gucGw/
DQoNCj4gKwkJYWR2aXNlX3NpemUgPSAoYWR2aXNlX3NpemUgPDwgMVVMKTsNCj4gKwl9DQo+ICsJ
ZW5jbF9kZWxldGUoJnNlbGYtPmVuY2wpOw0KPiArfQ0KPiArDQoNCg==
