Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E9BBEB64DD
	for <linux-sgx@archiver.kernel.org>; Fri, 30 Jun 2023 00:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjF3A4b (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 29 Jun 2023 20:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbjF3A43 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 29 Jun 2023 20:56:29 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156FA30D1
        for <linux-sgx@vger.kernel.org>; Thu, 29 Jun 2023 17:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688086587; x=1719622587;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=khkJyQ0lRCXvcv7hMhedNLbVCTvXxSApmH0jL9mjHi4=;
  b=Tlc8XtBlrcPBM7V2+KOuh1ydJP1+hmD+rBuIIDlQt2hD3cd708Jq4806
   pbSKcWwyWRVHb9oWG+faAWVeX+X8fLZHFo8+BTyRstsJK7URp9xbF1sBa
   dNrr4/zI3FIqvx0iD7isSO1m4NHAUgefxlFPSjG0C1G4IFNHiL8Nv7psG
   pJrKgw6lLPPrF4AR3AIaKH3PX8dKRktBrZG5ErVVdlUOsVLKTMR2w4qG4
   sjC+g5lH+IMe4qMQWZLNbLcuHaEACQUajCw8FLmyLm++9/M71uClPbAks
   h5s80umLsYjAU7FqLt/OjafL8Sx706enA+C2FtHLCW82R1kCas8gQpMUG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="393001309"
X-IronPort-AV: E=Sophos;i="6.01,169,1684825200"; 
   d="scan'208";a="393001309"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 17:56:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="1048026288"
X-IronPort-AV: E=Sophos;i="6.01,169,1684825200"; 
   d="scan'208";a="1048026288"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 29 Jun 2023 17:56:26 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 29 Jun 2023 17:56:25 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 29 Jun 2023 17:56:25 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 29 Jun 2023 17:56:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f+C/OpML4W8p8hLrGChdBpT8PPpeaU9PZ0VauWJ7Q5+4S6C9//TMej9NZokrTu3zo9b5OBTBm38Kdyk1WE1W5HDBc/UockhspiK7Dl5zgoTXqVCQQTKhqs6Sczx/RaGme8fiMnQFBCedlvZmxTiTSJm3G+1Ko/Z8u/P7tmRjBxSc1voumd7801JMCtQb2pqV1TXDAOplMIw7KMjdn8lbTbL/D+CKQwhf8dUm8pNLHrjXKESbcdtDbsk4iIHfth6LIEokTit6/seuePwheLkDLwrvZFD2T3GVJ6Jysalx09biNfMGn8uj40AaCYGuX6gWbMhwqjybblwwtjsldw7pPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=khkJyQ0lRCXvcv7hMhedNLbVCTvXxSApmH0jL9mjHi4=;
 b=hWrzjpMvkQrYPLBBOuOG8aVc7Sg4RF9UfvWFNl4NMOzCX3fLe903Qo0Q9jaJrSkNC1Bzl+s05uToq+RzJK8Jjh8KQKSvBAfNYY9QrtIGU0OfT6kABJ2JU6Hq+MQ2wVYo1NyR/L7CYjfOLt7jT1xZ+G2qjzrHsszn7RbnyPSLJjdRtZldgR7QGRhv4mDvjpBk5rjA99Uk5LV4dA61gMUEj+mYG03ShS8Hg6IKPpOzKs+pjoFa1QlDJ4i5Ks/t17rM6TinaBhuMY64ukHB+RFRzJFhaXpKThZMVlNz+5BzlmHgWagY2T306ZNulLJv1YgoP8ADdVKpRQJcRVx0uCQLgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB5311.namprd11.prod.outlook.com (2603:10b6:5:392::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Fri, 30 Jun
 2023 00:56:23 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Fri, 30 Jun 2023
 00:56:23 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Topic: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Thread-Index: AQHZMtTIU78a0A3o9UaUPrwPUmNX5q7OTQIAgACfroCAABrOAIAADTuAgAAPNoCAAFobgIAAUaaAgABy3wCAA5ciAIAACKGAgAY6gQCAADnpAIAV3bGAgAGoFwCAALMwAIB7cDIAgA/0eQCAD7ESgIABMj4AgAQB+wCABWrEAIAAFpKAgAY6eYCAAN3pAIAANG0AgAE6tgCAAFmGgIAAzOeAgAC7/ICAAJiegIAADIKAgAALpQA=
Date:   Fri, 30 Jun 2023 00:56:22 +0000
Message-ID: <0d04080a827c56f6e1a78c82eb694319b0097c6b.camel@intel.com>
References: <ZJTEpH2yYtHmTRWr@google.com>
         <66f22efc5a920a805d6863dcc152c3c12e8fb6fb.camel@intel.com>
         <ZJoRHU1CHxIuDH29@google.com>
         <7e78ec8fd22ad9f8b828fa00b9811bbfcf855b2c.camel@intel.com>
         <ZJr3PthzDgugKDcO@google.com>
         <1a980d3ce2caec1cf44bf97d52fa08fbe72e741f.camel@intel.com>
         <ZJxKV1/2M+OeIXAN@google.com>
         <60f96055b73932ef3550eb562d2f42440d534e69.camel@intel.com>
         <ZJ2T6zJSnLtKMPnE@google.com>
         <50913a11353b17861c13ebb53305dd370c8b8b43.camel@intel.com>
         <ZJ4eb8wGbLa06+wX@google.com>
In-Reply-To: <ZJ4eb8wGbLa06+wX@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.3 (3.48.3-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB5311:EE_
x-ms-office365-filtering-correlation-id: 08a1d966-a807-4306-6b55-08db7904d2ad
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bd53jGXPJICRsfqY00fd1gugULqf+vQyWGy/QycY4dF5b7K3u/6kpbkDaZXDWvr4pyfJrqspTpI0A6cUVVPbDupmmkL4PC6Wrx1CEs1Muqlc2jyHp9LpGhPkHRLkd6jElykfg+HwoRc51g7zG3eRwBdpjGXT1J6FY/YKgKIeHH/2Izuxn6jOChC+z1qseVq3cMVSPgAy8LaxxiT0d/LgFhqhXz8iO6jY6/oVkAfQvJmalL+37vRKbeVSvHdQdBbSap4w9USX1TYSWLKVy5isD8EGa1GwSeE5uzfUSCApvv5zHcq7YxCDgPRTWlzs0w+tGLkqisPB1HaygF27zy3zKIjbH/0uGM5Knh8a85T/NIDj5T7Y3adLL5b/95P2i0EIRTj2Q26xE6bR2PT2+wIlgx3ErhLKWaUPEOMvjV5CmBHPhjY4tGeFGW6JfhtvtMhBwxC2PE4UaMsxdY07hYRkshpkWUZLS49StqgQPH/5tMTQxaih+na8mgUFlR1xFI3h7cctI5vZlz/2pXoqOt8gBXBdudwGUHqT1Uc1HRGRsT3JKmF61LLKYlvuOfhFsGLkiCcVWaY29zTMwquOFKAS/ux7m42lgIFu4TSE4wBqkx5gyKZ8tIzHdPZ+fjA4fLe1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(136003)(39860400002)(396003)(346002)(451199021)(54906003)(478600001)(6486002)(4744005)(38070700005)(66946007)(2906002)(186003)(26005)(71200400001)(66446008)(66476007)(66556008)(6512007)(64756008)(6506007)(316002)(41300700001)(5660300002)(76116006)(38100700002)(8676002)(6916009)(8936002)(36756003)(91956017)(122000001)(4326008)(86362001)(2616005)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bGQwaGZjbTgyeGFiWVVuZGVoZk04ZDFhS3dBZVFtTHBpYUJKbnpoTy9RTmI3?=
 =?utf-8?B?TXNPamNreUVWNXRudEhPR1ZIeUVCMUlPRXFiZmVmSmY0ekFOV0VHZzR4QUFi?=
 =?utf-8?B?Tmd3SUdPeUhWczNDcVhrZjh6alpmdm0xUnE1OVNQT2dwUUkyS2doV0phNzhF?=
 =?utf-8?B?YlMzeFJGdkd5ZDFXcWpHZFNrUHh3cEplQXA1TnpEOEV6cWJIUmxxQlNrSndr?=
 =?utf-8?B?ZkZKQXdBTFR0VWk5UTJxaGR6MzlxM1FpemRMQW5qSTIvS0s4eHEvWExDUFR5?=
 =?utf-8?B?T2FtWGMvbGlobUZ3MGwvb3BJTFFZYzIzbi9XdHBqbkVSK2I1WkZ3RDF4dmV2?=
 =?utf-8?B?WkozRkNJMGxsVStLK2JrNlZhOUNFVS8xaE5Bdk5XRUVpVWRwdFp2UFNISDl2?=
 =?utf-8?B?ZSt2RzBGYTF0SkVRYmNjU3hMT1FZZkZyNUFjVXRUczBHNVY3dTIwQWI1dndz?=
 =?utf-8?B?NTM3TVk0c3JjRzhYSkNtSlA0SW5QaTVKV0VONkhCR09PNlhKK3lsam5qRlB2?=
 =?utf-8?B?b0hMYWVqeGZpMXl3UnlFYnJCUDJ2N0o5MDRMTXJGcDBObDcwMlBVUDN6MjBz?=
 =?utf-8?B?NnVMSkVmbGpHbXVFNzBZU1BuRWh4TmtZWHNtM2RwcyszbVF6V0JYZEYrTVFR?=
 =?utf-8?B?TFhUYXVlUHVvZkJHYWFlcy9tQ3lMSkxMWDc0TUUxWlV6aGNIUEhOOFZGa2Iv?=
 =?utf-8?B?TENaWmdjaG81Y3EwYUJ0VW1NUExDdVVoMUYzT3VLV2xoUmlaVnhXQ0U4WTZW?=
 =?utf-8?B?TFVTZTFFck5qRUFYdk56U3lMSVlOYm1ZRG1sQ0ZZbHpaM0lFdXdTckk5SVlV?=
 =?utf-8?B?djUzTW1OZkdxaVVjZHpTRXNOWCtoVWpLUGhIVlowbW9wYWlkTUd2c2JSWXlo?=
 =?utf-8?B?S0Iyb3V3MUtMVkhZRi8yaXBRaCtIdStseGx3d1k4SUsvRFRYeWhjYWpPR2lP?=
 =?utf-8?B?NXY2RTczeVRoTG0wMVJLeXE3dkcvYjMvWjduOEVDYnI5Tkl6d1NnSWlhZHJo?=
 =?utf-8?B?TFJ6bGRMTk5sWHBJdWVHdnl1SDhLYmluWjBUZWYwVkU4ekI5SWNIelkzSS9K?=
 =?utf-8?B?SXdZKzNxVk9nSFNnR0t1b3lYbSsvV2FLd0lKS0N3enJNL0tFZGZyZlpwWTlB?=
 =?utf-8?B?RVE2a0R2cUtoakJaN2ZNOE5LYmdORkJLT2hiZGlZMUhWcTlBZnFWNy91cklP?=
 =?utf-8?B?SlBtdE50aHl3SVpTdXRjOTV4OGdWb3VwZ29UbE41dEpmUkZDNExSMHlPZk5n?=
 =?utf-8?B?NTJiV0tkVnFHWXQxczdSanAvRG5ZbWJlNTdQSU9YYllzLzVJWTlTYXd3S1Nl?=
 =?utf-8?B?SWtDYnZsMEc1MHFOQ1JXN0pwWk1wQ1R3NnZlUElxOGU2cEhGeUhQNCt6L3lW?=
 =?utf-8?B?bFJJb1EyWGRPa2xNMHlubnVSNjFMNUVReGlZVTdYV2xMclp6N2dWbExWOEhz?=
 =?utf-8?B?MEU0UVNuUDFHcFJmeERQOE9JQTlBbUhpbUY3MG90cVpLZmpPUzFjNmx6ajYr?=
 =?utf-8?B?WXBjRCtDQTFKdFVIS0JlaG8yV1drUnlrOXRGTGNVTzF1K041aEozbW9Pd214?=
 =?utf-8?B?VlkyWWtZa2RScE1vNm5QTGw3RUltaE10MWhDK3E1US80bVhxSXFGaCtlcTJ1?=
 =?utf-8?B?a2MrczJjb1djcDVOQW5NTWJTS3FSMmxPMUlJYlU3MGc4SGVvU3p6YklhRk4v?=
 =?utf-8?B?QVVGUWQrMHBhSWpnWGIwd29EaDEyQ3E2WDVMb3hxdW1ta1VRazhVQ0toazFS?=
 =?utf-8?B?TmRnckdDSkZ2d3EveDYwcE9IQkc4MDl2d2xEUkVnVUFSRVQrNzc4OWZjbTNr?=
 =?utf-8?B?YlpuQU1ZMzV2aCsyTWdlczE0bDk2dXFDR1pzYXptN2JQOE9aaUIrRlk5eHoy?=
 =?utf-8?B?RUx3R3hVY2dXaVBTVlJJalBQenRuVk1CLzJXSURSeGoyNTJzV1pCckd3VUY5?=
 =?utf-8?B?MjVhRER5bDVCRDI1V1RFWUpoOXhuSFlvSFk5YTU3cG1lVFQ4RFpXcjJaUjE2?=
 =?utf-8?B?OUliRy9DTTQxelVObHpwcnBhd3IxQVJxUjBibGZxVzZtbWRkc3FKNjJIajhu?=
 =?utf-8?B?NElLK0lWS1FCeXM4aWNlTVpyVjlaWUlpM242aVFQTER4WENGOTljL0RzREY1?=
 =?utf-8?B?VUd5QUFxcUMvQ3ZENGRMdTlIU3JtbHBocXZKMzFFb0FCb3NKdHBMeGZ6N1Zx?=
 =?utf-8?B?cEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D8DD4FA388C57B4E88FCBB7F221FC1E2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08a1d966-a807-4306-6b55-08db7904d2ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2023 00:56:22.4075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xcAhbZLyz/AamTPaAfyIi7GCCfWCkqB+SCw5va3JHNERlgJu/93GvUHdR8+rIbv8AMC7oDH8bjSYJVx56KOPsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5311
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gVGh1LCAyMDIzLTA2LTI5IGF0IDE3OjE0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEp1biAyOSwgMjAyMywgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IEJ1dCBT
R1ggdXNyZXNwYWNlIG5lZWRzIGEgKmV4YWN0KiBhZGRyZXNzLiAgTUFQX0ZJWEVEIGlzIHRoZSBv
bmx5IEFCSSBjYW4NCj4gPiBndWFyYW50ZWUgdGhpcy4NCj4gDQo+IFllcywgYnV0IHlvdSdyZSBh
c3N1bWluZyB0aGF0IHVzZXJzcGFjZSBpcyBzYW5lIGFuZCByb2J1c3QuICBJdCdzICp2ZXJ5KiBw
b3NzaWJsZQ0KPiB0aGF0IHRoZXJlIGV4aXN0cyB1c2Vyc3BhY2UgdGhhdCBkb2Vzbid0IHNwZWNp
ZnkgTUFQX0ZJWEVELCBidXQgd29ya3MgYW55d2F5cw0KPiBiZWNhdXNlIHRoZWlyIHNldHVwIGRv
ZXNuJ3QgY2F1c2UgY29uZmxpY3RzIGFuZCBzbyB0aGUgaGludCBpcyBzdWZmaWNpZW50Lg0KDQpJ
IG11c3QgaGF2ZSBtaXNzZWQgc29tZXRoaW5nLiAgRUxSQU5HRSBpcyB0aGUgZmlyc3QgVk1BIHRo
YXQgdXNlcnNwYWNlIG5lZWRzIHRvDQpkbywgYW5kIGdpdmVuIGVuY2xhdmUgYWRkcmVzcyBtdXN0
IGJlIHdpdGhpbiBFTFJBTkdFLCB0aGUgc3Vic2VxdWVudCBtbWFwKClzDQp3aWxsIGFsd2F5cyBj
b25mbGljdCB3aXRoIHRoZSBFTFJBTkdFIFZNQT8gIE5vPw0K
